import assert from "node:assert/strict";
import test from "node:test";

import {
  buildGenerateMealPlanHandler,
  buildReplaceMealHandler,
  type AiProxyDependencies,
} from "./proxy";

const profile = {
  goal: "Perdre du poids",
  dietStyle: "Mediterraneen",
  allergies: ["Cacahuetes"],
  customAversions: ["Olives"],
  activityLevel: "Moderement actif",
  mealTiming: ["3 repas classiques"],
  age: 32,
  heightCm: 178,
  currentWeightKg: 82.5,
  targetWeightKg: 76,
};

const meal = {
  id: "breakfast",
  type: "PETIT-DEJEUNER",
  name: "Omelette aux herbes",
  calories: 420,
  protein: 31,
  carbs: 18,
  fat: 24,
  imagePrompt: "omelette healthy breakfast",
  duration: "15 min",
  ingredients: ["2 oeufs", "Herbes fraiches"],
  instructions: ["Battre les oeufs.", "Cuire a feu doux."],
};

const plan = {
  days: Array.from({ length: 7 }, (_, index) => ({
    id: `day-${index + 1}`,
    label: `Jour ${index + 1}`,
    meals: [meal],
  })),
  summary: {
    targetCalories: 2000,
    proteinPercent: 30,
    carbsPercent: 45,
    fatPercent: 25,
  },
};

test("generateMealPlan refuses unauthenticated requests", async () => {
  const handler = buildGenerateMealPlanHandler(fakeDependencies({ plan }));

  await assert.rejects(
    () => handler({ auth: null, data: { profile, days: 7, locale: "fr-FR" } }),
    errorWithCode("unauthenticated"),
  );
});

test("generateMealPlan refuses invalid profiles", async () => {
  const handler = buildGenerateMealPlanHandler(fakeDependencies({ plan }));

  await assert.rejects(
    () =>
      handler({
        auth: { uid: "user-1" },
        data: { profile: { ...profile, age: -1 }, days: 7, locale: "fr-FR" },
      }),
    errorWithCode("invalid-argument"),
  );
});

test("generateMealPlan maps OpenAI quota errors", async () => {
  const handler = buildGenerateMealPlanHandler(
    fakeDependencies({ generateError: { status: 429, message: "quota" } }),
  );

  await assert.rejects(
    () => handler({ auth: { uid: "user-1" }, data: { profile, days: 7 } }),
    errorWithCode("resource-exhausted"),
  );
});

test("generateMealPlan refuses invalid OpenAI payloads", async () => {
  const handler = buildGenerateMealPlanHandler(
    fakeDependencies({ plan: { days: [], summary: {} } }),
  );

  await assert.rejects(
    () => handler({ auth: { uid: "user-1" }, data: { profile, days: 7 } }),
    errorWithCode("internal"),
  );
});

test("generateMealPlan returns a validated plan", async () => {
  const handler = buildGenerateMealPlanHandler(fakeDependencies({ plan }));

  const result = await handler({
    auth: { uid: "user-1" },
    data: { profile, days: 7, locale: "fr-FR" },
  });

  assert.equal(result.usage, null);
  assert.equal(result.plan.days[0]?.meals[0]?.name, "Omelette aux herbes");
});

test("replaceMeal returns a validated alternative meal", async () => {
  const handler = buildReplaceMealHandler(fakeDependencies({ meal: { meal } }));

  const result = await handler({
    auth: { uid: "user-1" },
    data: {
      profile,
      currentMeal: meal,
      planContext: { meals: [meal] },
      locale: "fr-FR",
    },
  });

  assert.equal(result.meal.id, "breakfast");
  assert.equal(result.meal.name, "Omelette aux herbes");
});

function fakeDependencies(options: {
  plan?: unknown;
  meal?: unknown;
  generateError?: { status?: number; message?: string };
  replaceError?: { status?: number; message?: string };
}): AiProxyDependencies {
  return {
    async generateMealPlan() {
      if (options.generateError) {
        throw options.generateError;
      }
      return options.plan;
    },
    async replaceMeal() {
      if (options.replaceError) {
        throw options.replaceError;
      }
      return options.meal;
    },
  };
}

function errorWithCode(code: string) {
  return (error: unknown) => {
    return Boolean(
      error &&
        typeof error === "object" &&
        "code" in error &&
        error.code === code,
    );
  };
}
