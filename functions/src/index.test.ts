import assert from "node:assert/strict";
import test from "node:test";

import { aiCallableOptions, generateMealPlan, replaceMeal } from "./index";

test("AI callable functions enforce runtime and App Check options", () => {
  assert.equal(aiCallableOptions.enforceAppCheck, true);
  assert.equal(aiCallableOptions.timeoutSeconds, 120);
  assert.equal(aiCallableOptions.memory, "512MiB");

  for (const fn of [generateMealPlan, replaceMeal]) {
    assert.equal(fn.__endpoint.region?.[0], "europe-west1");
    assert.equal(fn.__endpoint.timeoutSeconds, 120);
    assert.equal(fn.__endpoint.availableMemoryMb, 512);
  }
});
