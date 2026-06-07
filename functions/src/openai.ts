import type {
  AiProxyDependencies,
  GenerateMealPlanInput,
  ReplaceMealInput,
} from "./proxy";

type FetchLike = typeof fetch;

const responsesUrl = "https://api.openai.com/v1/responses";
const defaultModel = "gpt-5-mini";

export function buildOpenAiDependencies(options: {
  apiKey: () => string;
  fetchImpl?: FetchLike;
  model?: string;
}): AiProxyDependencies {
  const fetchImpl = options.fetchImpl ?? fetch;
  const model = options.model ?? defaultModel;

  return {
    generateMealPlan(input) {
      return callStructuredOutput({
        apiKey: options.apiKey(),
        fetchImpl,
        model,
        schemaName: "meal_plan_response",
        schema: mealPlanResponseSchema,
        prompt: buildMealPlanPrompt(input),
      });
    },
    replaceMeal(input) {
      return callStructuredOutput({
        apiKey: options.apiKey(),
        fetchImpl,
        model,
        schemaName: "replace_meal_response",
        schema: replaceMealResponseSchema,
        prompt: buildReplaceMealPrompt(input),
      });
    },
  };
}

async function callStructuredOutput(options: {
  apiKey: string;
  fetchImpl: FetchLike;
  model: string;
  schemaName: string;
  schema: Record<string, unknown>;
  prompt: string;
}): Promise<unknown> {
  if (options.apiKey.trim().length === 0) {
    throw { status: 401, message: "Missing OpenAI API key." };
  }

  const response = await options.fetchImpl(responsesUrl, {
    method: "POST",
    headers: {
      Authorization: `Bearer ${options.apiKey}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      model: options.model,
      input: [
        {
          role: "system",
          content:
            "Tu es MealCrunchy, un assistant culinaire francais. " +
            "Tu retournes uniquement des donnees JSON conformes au schema.",
        },
        { role: "user", content: options.prompt },
      ],
      text: {
        format: {
          type: "json_schema",
          name: options.schemaName,
          strict: true,
          schema: options.schema,
        },
      },
    }),
  });

  if (!response.ok) {
    throw {
      status: response.status,
      message: await response.text(),
    };
  }

  const json = (await response.json()) as Record<string, unknown>;
  const outputText = extractOutputText(json);
  return JSON.parse(outputText) as unknown;
}

function buildMealPlanPrompt(input: GenerateMealPlanInput): string {
  return JSON.stringify({
    task: "generate_meal_plan",
    locale: input.locale,
    days: input.days,
    userId: input.userId,
    profile: input.profile,
    rules: [
      "Generer exactement 7 jours.",
      "Chaque jour contient petit-dejeuner, dejeuner, diner et collation si utile.",
      "Respecter allergies, aversions et style alimentaire.",
      "Ne pas donner de conseil medical.",
    ],
  });
}

function buildReplaceMealPrompt(input: ReplaceMealInput): string {
  return JSON.stringify({
    task: "replace_meal",
    locale: input.locale,
    userId: input.userId,
    profile: input.profile,
    currentMeal: input.currentMeal,
    planContext: input.planContext,
    rules: [
      "Remplacer uniquement le repas courant.",
      "Conserver le type du repas remplace.",
      "Respecter allergies, aversions et style alimentaire.",
      "Retourner une alternative concrete et cuisinable.",
    ],
  });
}

function extractOutputText(response: Record<string, unknown>): string {
  const directOutput = response.output_text;
  if (typeof directOutput === "string") {
    return directOutput;
  }

  const output = response.output;
  if (Array.isArray(output)) {
    for (const item of output) {
      if (!item || typeof item !== "object" || !("content" in item)) {
        continue;
      }
      const content = item.content;
      if (!Array.isArray(content)) {
        continue;
      }
      for (const part of content) {
        if (part && typeof part === "object" && "text" in part) {
          const text = part.text;
          if (typeof text === "string") {
            return text;
          }
        }
      }
    }
  }

  throw { status: 502, message: "OpenAI response did not contain text." };
}

const mealSchema = {
  type: "object",
  additionalProperties: false,
  required: [
    "id",
    "type",
    "name",
    "calories",
    "protein",
    "carbs",
    "fat",
    "imagePrompt",
    "duration",
    "ingredients",
    "instructions",
  ],
  properties: {
    id: { type: "string" },
    type: {
      type: "string",
      enum: ["PETIT-DEJEUNER", "DEJEUNER", "COLLATION", "DINER"],
    },
    name: { type: "string" },
    calories: { type: "integer", minimum: 1 },
    protein: { type: "integer", minimum: 0 },
    carbs: { type: "integer", minimum: 0 },
    fat: { type: "integer", minimum: 0 },
    imagePrompt: { type: "string" },
    duration: { type: "string" },
    ingredients: {
      type: "array",
      minItems: 1,
      items: { type: "string" },
    },
    instructions: {
      type: "array",
      minItems: 1,
      items: { type: "string" },
    },
  },
};

const mealPlanResponseSchema = {
  type: "object",
  additionalProperties: false,
  required: ["plan"],
  properties: {
    plan: {
      type: "object",
      additionalProperties: false,
      required: ["days", "summary"],
      properties: {
        days: {
          type: "array",
          minItems: 7,
          maxItems: 7,
          items: {
            type: "object",
            additionalProperties: false,
            required: ["id", "label", "meals"],
            properties: {
              id: { type: "string" },
              label: { type: "string" },
              meals: {
                type: "array",
                minItems: 3,
                items: mealSchema,
              },
            },
          },
        },
        summary: {
          type: "object",
          additionalProperties: false,
          required: [
            "targetCalories",
            "proteinPercent",
            "carbsPercent",
            "fatPercent",
          ],
          properties: {
            targetCalories: { type: "integer", minimum: 1 },
            proteinPercent: { type: "integer", minimum: 0, maximum: 100 },
            carbsPercent: { type: "integer", minimum: 0, maximum: 100 },
            fatPercent: { type: "integer", minimum: 0, maximum: 100 },
          },
        },
      },
    },
  },
};

const replaceMealResponseSchema = {
  type: "object",
  additionalProperties: false,
  required: ["meal"],
  properties: {
    meal: mealSchema,
  },
};
