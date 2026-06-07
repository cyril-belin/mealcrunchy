import { initializeApp } from "firebase-admin/app";
import { defineSecret } from "firebase-functions/params";
import { onCall } from "firebase-functions/v2/https";

import { buildOpenAiDependencies } from "./openai";
import {
  buildGenerateMealPlanHandler,
  buildReplaceMealHandler,
} from "./proxy";

initializeApp();

const openAiApiKey = defineSecret("OPENAI_API_KEY");

const callableOptions = {
  region: "europe-west1",
  secrets: [openAiApiKey],
};

function openAiDependencies() {
  return buildOpenAiDependencies({
    apiKey: () => openAiApiKey.value(),
  });
}

export const generateMealPlan = onCall(callableOptions, (request) => {
  return buildGenerateMealPlanHandler(openAiDependencies())(request);
});

export const replaceMeal = onCall(callableOptions, (request) => {
  return buildReplaceMealHandler(openAiDependencies())(request);
});
