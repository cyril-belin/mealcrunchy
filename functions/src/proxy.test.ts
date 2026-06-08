import assert from "node:assert/strict";
import test from "node:test";

import {
  buildGenerateMealPlanHandler,
  buildReplaceMealHandler,
  type AiQuotaDependencies,
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
  const handler = buildGenerateMealPlanHandler(
    fakeDependencies({ plan }),
    quotaDependencies(),
  );

  await assert.rejects(
    () => handler({ auth: null, data: { profile, days: 7, locale: "fr-FR" } }),
    errorWithCode("unauthenticated"),
  );
});

test("generateMealPlan refuses invalid profiles", async () => {
  const handler = buildGenerateMealPlanHandler(
    fakeDependencies({ plan }),
    quotaDependencies(),
  );

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
  const quotaStore = new FakeAiQuotaStore();
  const handler = buildGenerateMealPlanHandler(
    fakeDependencies({ generateError: { status: 429, message: "quota" } }),
    quotaDependencies(quotaStore),
  );

  await assert.rejects(
    () => handler({ auth: { uid: "user-1" }, data: { profile, days: 7 } }),
    errorWithCode("resource-exhausted"),
  );
  assert.equal(quotaStore.mealPlanGenerationsUsed, 0);
});

test("generateMealPlan refuses invalid OpenAI payloads", async () => {
  const quotaStore = new FakeAiQuotaStore();
  const handler = buildGenerateMealPlanHandler(
    fakeDependencies({ plan: { days: [], summary: {} } }),
    quotaDependencies(quotaStore),
  );

  await assert.rejects(
    () => handler({ auth: { uid: "user-1" }, data: { profile, days: 7 } }),
    errorWithCode("internal"),
  );
  assert.equal(quotaStore.mealPlanGenerationsUsed, 0);
});

test("generateMealPlan returns a validated plan", async () => {
  const handler = buildGenerateMealPlanHandler(
    fakeDependencies({ plan }),
    quotaDependencies(),
  );

  const result = await handler({
    auth: { uid: "user-1" },
    data: { profile, days: 7, locale: "fr-FR" },
  });

  assert.deepEqual(result.usage, {
    periodKey: "2026-06",
    limit: 1,
    used: 1,
    remaining: 0,
  });
  assert.equal(result.plan.days[0]?.meals[0]?.name, "Omelette aux herbes");
});

test("generateMealPlan refuses exhausted app quotas before OpenAI", async () => {
  const dependencies = fakeDependencies({ plan });
  const handler = buildGenerateMealPlanHandler(
    dependencies,
    quotaDependencies(new FakeAiQuotaStore({ mealPlanGenerationsUsed: 1 })),
  );

  await assert.rejects(
    () => handler({ auth: { uid: "user-1" }, data: { profile, days: 7 } }),
    errorWithCode("resource-exhausted"),
  );
  assert.equal(dependencies.generateMealPlanCalls, 0);
});

test("replaceMeal returns a validated alternative meal", async () => {
  const handler = buildReplaceMealHandler(
    fakeDependencies({ meal: { meal } }),
    quotaDependencies(new FakeAiQuotaStore({ mealReplacementsUsed: 9 })),
  );

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
  assert.deepEqual(result.usage, {
    periodKey: "2026-06",
    limit: 10,
    used: 10,
    remaining: 0,
  });
});

test("replaceMeal refuses exhausted app quotas before OpenAI", async () => {
  const dependencies = fakeDependencies({ meal: { meal } });
  const handler = buildReplaceMealHandler(
    dependencies,
    quotaDependencies(new FakeAiQuotaStore({ mealReplacementsUsed: 10 })),
  );

  await assert.rejects(
    () =>
      handler({
        auth: { uid: "user-1" },
        data: {
          profile,
          currentMeal: meal,
          planContext: { meals: [meal] },
          locale: "fr-FR",
        },
      }),
    errorWithCode("resource-exhausted"),
  );
  assert.equal(dependencies.replaceMealCalls, 0);
});

type FakeAiProxyDependencies = AiProxyDependencies & {
  generateMealPlanCalls: number;
  replaceMealCalls: number;
};

function fakeDependencies(options: {
  plan?: unknown;
  meal?: unknown;
  generateError?: { status?: number; message?: string };
  replaceError?: { status?: number; message?: string };
}): FakeAiProxyDependencies {
  const fake: FakeAiProxyDependencies = {
    generateMealPlanCalls: 0,
    replaceMealCalls: 0,
    async generateMealPlan() {
      fake.generateMealPlanCalls += 1;
      if (options.generateError) {
        throw options.generateError;
      }
      return options.plan;
    },
    async replaceMeal() {
      fake.replaceMealCalls += 1;
      if (options.replaceError) {
        throw options.replaceError;
      }
      return options.meal;
    },
  };
  return fake;
}

function quotaDependencies(
  quotaStore = new FakeAiQuotaStore(),
): AiQuotaDependencies {
  return {
    quotaStore,
    now: () => new Date(Date.UTC(2026, 5, 8, 12)),
  };
}

class FakeAiQuotaStore {
  constructor(options: {
    mealPlanGenerationsUsed?: number;
    mealReplacementsUsed?: number;
  } = {}) {
    this.mealPlanGenerationsUsed = options.mealPlanGenerationsUsed ?? 0;
    this.mealReplacementsUsed = options.mealReplacementsUsed ?? 0;
  }

  mealPlanGenerationsUsed: number;
  mealReplacementsUsed: number;

  async getUsage(input: {
    kind: "mealPlanGeneration" | "mealReplacement";
    periodKey: string;
    limit: number;
  }) {
    return this.usage(input);
  }

  async incrementUsage(input: {
    kind: "mealPlanGeneration" | "mealReplacement";
    periodKey: string;
    limit: number;
  }) {
    if (input.kind === "mealPlanGeneration") {
      this.mealPlanGenerationsUsed += 1;
    } else {
      this.mealReplacementsUsed += 1;
    }
    return this.usage(input);
  }

  private usage(input: {
    kind: "mealPlanGeneration" | "mealReplacement";
    periodKey: string;
    limit: number;
  }) {
    const used =
      input.kind === "mealPlanGeneration"
        ? this.mealPlanGenerationsUsed
        : this.mealReplacementsUsed;
    return {
      periodKey: input.periodKey,
      limit: input.limit,
      used,
      remaining: Math.max(input.limit - used, 0),
    };
  }
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
