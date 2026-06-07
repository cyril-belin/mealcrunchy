import { HttpsError } from "firebase-functions/v2/https";

export type AuthContext = {
  uid: string;
};

export type CallableLikeRequest = {
  auth?: AuthContext | null;
  data: unknown;
};

export type UserProfile = {
  goal: string;
  dietStyle: string;
  allergies: string[];
  customAversions: string[];
  activityLevel: string;
  mealTiming: string[];
  age: number;
  heightCm: number;
  currentWeightKg: number;
  targetWeightKg: number;
};

export type Meal = {
  id: string;
  type: string;
  name: string;
  calories: number;
  protein: number;
  carbs: number;
  fat: number;
  imagePrompt: string;
  duration: string;
  ingredients: string[];
  instructions: string[];
};

export type MealPlanDay = {
  id: string;
  label: string;
  meals: Meal[];
};

export type MealPlanSummary = {
  targetCalories: number;
  proteinPercent: number;
  carbsPercent: number;
  fatPercent: number;
};

export type MealPlan = {
  days: MealPlanDay[];
  summary: MealPlanSummary;
};

export type GenerateMealPlanInput = {
  userId: string;
  profile: UserProfile;
  days: number;
  locale: string;
};

export type ReplaceMealInput = {
  userId: string;
  profile: UserProfile;
  currentMeal: Meal;
  planContext: Record<string, unknown>;
  locale: string;
};

export type AiProxyDependencies = {
  generateMealPlan(input: GenerateMealPlanInput): Promise<unknown>;
  replaceMeal(input: ReplaceMealInput): Promise<unknown>;
};

const defaultLocale = "fr-FR";
const requiredDays = 7;

export function buildGenerateMealPlanHandler(
  dependencies: AiProxyDependencies,
) {
  return async (request: CallableLikeRequest) => {
    const userId = requireUserId(request);
    const data = asRecord(request.data);
    const profile = readProfile(data.profile);
    const days = readDays(data.days);
    const locale = readLocale(data.locale);

    const payload = await callOpenAi(() =>
      dependencies.generateMealPlan({ userId, profile, days, locale }),
    );
    const plan = readMealPlan(payload, days);

    return { plan, usage: null };
  };
}

export function buildReplaceMealHandler(dependencies: AiProxyDependencies) {
  return async (request: CallableLikeRequest) => {
    const userId = requireUserId(request);
    const data = asRecord(request.data);
    const profile = readProfile(data.profile);
    const currentMeal = readMeal(data.currentMeal);
    const planContext = asRecord(data.planContext);
    const locale = readLocale(data.locale);

    const payload = await callOpenAi(() =>
      dependencies.replaceMeal({
        userId,
        profile,
        currentMeal,
        planContext,
        locale,
      }),
    );
    const output = asRecord(payload);
    const meal = readMeal(output.meal ?? payload);

    return { meal };
  };
}

function requireUserId(request: CallableLikeRequest): string {
  const uid = request.auth?.uid;
  if (!uid) {
    throw new HttpsError(
      "unauthenticated",
      "Vous devez etre connecte pour utiliser la generation IA.",
    );
  }
  return uid;
}

async function callOpenAi(load: () => Promise<unknown>): Promise<unknown> {
  try {
    return await load();
  } catch (error) {
    throw mapOpenAiError(error);
  }
}

function mapOpenAiError(error: unknown): HttpsError {
  const status = readStatus(error);
  if (status === 429) {
    return new HttpsError(
      "resource-exhausted",
      "Quota IA temporairement atteint.",
    );
  }

  if (status === 400) {
    return new HttpsError(
      "invalid-argument",
      "La requete IA est invalide.",
    );
  }

  return new HttpsError(
    "unavailable",
    "Generation IA momentanement indisponible.",
  );
}

function readStatus(error: unknown): number | null {
  if (error && typeof error === "object" && "status" in error) {
    const status = error.status;
    if (typeof status === "number") {
      return status;
    }
  }
  return null;
}

function readProfile(value: unknown): UserProfile {
  const json = asRecord(value);
  return {
    goal: readNonEmptyString(json, "goal"),
    dietStyle: readNonEmptyString(json, "dietStyle"),
    allergies: readStringList(json, "allergies"),
    customAversions: readStringList(json, "customAversions"),
    activityLevel: readNonEmptyString(json, "activityLevel"),
    mealTiming: readStringList(json, "mealTiming"),
    age: readPositiveInteger(json, "age"),
    heightCm: readPositiveInteger(json, "heightCm"),
    currentWeightKg: readPositiveNumber(json, "currentWeightKg"),
    targetWeightKg: readPositiveNumber(json, "targetWeightKg"),
  };
}

function readDays(value: unknown): number {
  if (value === undefined) {
    return requiredDays;
  }
  if (value !== requiredDays) {
    throwInvalidArgument("days must be 7.");
  }
  return requiredDays;
}

function readLocale(value: unknown): string {
  if (value === undefined) {
    return defaultLocale;
  }
  if (value !== defaultLocale) {
    throwInvalidArgument("locale must be fr-FR.");
  }
  return defaultLocale;
}

function readMealPlan(value: unknown, days: number): MealPlan {
  const json = asRecord(value);
  const plan = asRecord(json.plan ?? value);
  const dayValues = readArray(plan, "days");
  const parsedDays = dayValues.map(readMealPlanDay);

  if (parsedDays.length !== days) {
    throwInvalidOpenAiResponse("Invalid meal plan day count.");
  }

  return {
    days: parsedDays,
    summary: readMealPlanSummary(plan.summary),
  };
}

function readMealPlanDay(value: unknown): MealPlanDay {
  const json = asRecord(value);
  return {
    id: readNonEmptyString(json, "id"),
    label: readNonEmptyString(json, "label"),
    meals: readArray(json, "meals").map(readMeal),
  };
}

function readMealPlanSummary(value: unknown): MealPlanSummary {
  const json = asRecord(value);
  return {
    targetCalories: readPositiveInteger(json, "targetCalories"),
    proteinPercent: readPercent(json, "proteinPercent"),
    carbsPercent: readPercent(json, "carbsPercent"),
    fatPercent: readPercent(json, "fatPercent"),
  };
}

function readMeal(value: unknown): Meal {
  const json = asRecord(value);
  return {
    id: readNonEmptyString(json, "id"),
    type: readMealType(json, "type"),
    name: readNonEmptyString(json, "name"),
    calories: readPositiveInteger(json, "calories"),
    protein: readNonNegativeInteger(json, "protein"),
    carbs: readNonNegativeInteger(json, "carbs"),
    fat: readNonNegativeInteger(json, "fat"),
    imagePrompt: readNonEmptyString(json, "imagePrompt"),
    duration: readNonEmptyString(json, "duration"),
    ingredients: readNonEmptyStringList(json, "ingredients"),
    instructions: readNonEmptyStringList(json, "instructions"),
  };
}

function readMealType(json: Record<string, unknown>, key: string): string {
  const value = readNonEmptyString(json, key);
  if (
    value !== "PETIT-DEJEUNER" &&
    value !== "DEJEUNER" &&
    value !== "COLLATION" &&
    value !== "DINER"
  ) {
    throwInvalidOpenAiResponse(`${key} has an unsupported value.`);
  }
  return value;
}

function readNonEmptyString(
  json: Record<string, unknown>,
  key: string,
): string {
  const value = json[key];
  if (typeof value !== "string" || value.trim().length === 0) {
    throwInvalidArgument(`${key} must be a non-empty string.`);
  }
  return value;
}

function readStringList(
  json: Record<string, unknown>,
  key: string,
): string[] {
  const value = json[key];
  if (!Array.isArray(value) || !value.every((item) => typeof item === "string")) {
    throwInvalidArgument(`${key} must be a string list.`);
  }
  return value;
}

function readNonEmptyStringList(
  json: Record<string, unknown>,
  key: string,
): string[] {
  const values = readStringList(json, key);
  if (values.length === 0 || values.some((item) => item.trim().length === 0)) {
    throwInvalidOpenAiResponse(`${key} must be a non-empty string list.`);
  }
  return values;
}

function readArray(json: Record<string, unknown>, key: string): unknown[] {
  const value = json[key];
  if (!Array.isArray(value)) {
    throwInvalidOpenAiResponse(`${key} must be an array.`);
  }
  return value;
}

function readPositiveInteger(
  json: Record<string, unknown>,
  key: string,
): number {
  const value = json[key];
  if (typeof value !== "number" || !Number.isInteger(value) || value <= 0) {
    throwInvalidArgument(`${key} must be a positive integer.`);
  }
  return value;
}

function readNonNegativeInteger(
  json: Record<string, unknown>,
  key: string,
): number {
  const value = json[key];
  if (typeof value !== "number" || !Number.isInteger(value) || value < 0) {
    throwInvalidOpenAiResponse(`${key} must be a non-negative integer.`);
  }
  return value;
}

function readPositiveNumber(
  json: Record<string, unknown>,
  key: string,
): number {
  const value = json[key];
  if (typeof value !== "number" || !Number.isFinite(value) || value <= 0) {
    throwInvalidArgument(`${key} must be a positive number.`);
  }
  return value;
}

function readPercent(json: Record<string, unknown>, key: string): number {
  const value = json[key];
  if (
    typeof value !== "number" ||
    !Number.isInteger(value) ||
    value < 0 ||
    value > 100
  ) {
    throwInvalidOpenAiResponse(`${key} must be between 0 and 100.`);
  }
  return value;
}

function asRecord(value: unknown): Record<string, unknown> {
  if (value && typeof value === "object" && !Array.isArray(value)) {
    return value as Record<string, unknown>;
  }
  throwInvalidArgument("Expected an object payload.");
}

function throwInvalidArgument(message: string): never {
  throw new HttpsError("invalid-argument", message);
}

function throwInvalidOpenAiResponse(message: string): never {
  throw new HttpsError("internal", message);
}
