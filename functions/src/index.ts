import { initializeApp } from "firebase-admin/app";
import { defineSecret } from "firebase-functions/params";
import { onCall, type CallableOptions } from "firebase-functions/v2/https";

import { buildOpenAiDependencies } from "./openai";
import {
  buildGenerateMealPlanHandler,
  buildReplaceMealHandler,
} from "./proxy";
import { buildFirestoreAiQuotaStore } from "./quotas";

initializeApp();

const openAiApiKey = defineSecret("OPENAI_API_KEY");

export const aiCallableOptions: CallableOptions = {
  region: "europe-west1",
  secrets: [openAiApiKey],
  timeoutSeconds: 120,
  memory: "512MiB",
  enforceAppCheck: true,
};

function openAiDependencies() {
  return buildOpenAiDependencies({
    apiKey: () => openAiApiKey.value(),
  });
}

function quotaDependencies() {
  return {
    quotaStore: buildFirestoreAiQuotaStore(),
    now: () => new Date(),
  };
}

export const generateMealPlan = onCall(aiCallableOptions, (request) => {
  return buildGenerateMealPlanHandler(
    openAiDependencies(),
    quotaDependencies(),
  )(request);
});

export const replaceMeal = onCall(aiCallableOptions, (request) => {
  return buildReplaceMealHandler(openAiDependencies(), quotaDependencies())(
    request,
  );
});
