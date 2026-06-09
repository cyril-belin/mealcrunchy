import {
  FieldValue,
  type Firestore,
  getFirestore,
} from "firebase-admin/firestore";

export type AiQuotaKind = "mealPlanGeneration" | "mealReplacement";

export type AiQuotaRequest = {
  uid: string;
  kind: AiQuotaKind;
  periodKey: string;
  limit: number;
};

export type AiQuotaUsage = {
  periodKey: string;
  limit: number;
  used: number;
  remaining: number;
};

export type AiQuotaStore = {
  getUsage(input: AiQuotaRequest): Promise<AiQuotaUsage>;
  reserveUsage(input: AiQuotaRequest): Promise<AiQuotaUsage>;
  releaseUsage(input: AiQuotaRequest): Promise<AiQuotaUsage>;
};

export class AiQuotaExhaustedError extends Error {
  constructor() {
    super("AI quota exhausted.");
  }
}

const quotaCollection = "aiQuotas";

const quotaFields = {
  mealPlanGeneration: "mealPlanGenerationsUsed",
  mealReplacement: "mealReplacementsUsed",
} as const satisfies Record<AiQuotaKind, string>;

export const quotaLimits = {
  mealPlanGeneration: 1,
  mealReplacement: 10,
} as const satisfies Record<AiQuotaKind, number>;

export function periodKeyFor(date: Date): string {
  const month = String(date.getUTCMonth() + 1).padStart(2, "0");
  return `${date.getUTCFullYear()}-${month}`;
}

export function buildFirestoreAiQuotaStore(
  firestore: Firestore = getFirestore(),
): AiQuotaStore {
  return new FirestoreAiQuotaStore(firestore);
}

class FirestoreAiQuotaStore implements AiQuotaStore {
  constructor(private readonly firestore: Firestore) {}

  async getUsage(input: AiQuotaRequest): Promise<AiQuotaUsage> {
    const snapshot = await this.documentFor(input).get();
    const data = snapshot.exists
      ? (snapshot.data() as Record<string, unknown> | undefined)
      : undefined;
    return usageFor(input, readUsedCount(data, quotaFields[input.kind]));
  }

  async reserveUsage(input: AiQuotaRequest): Promise<AiQuotaUsage> {
    return this.firestore.runTransaction(async (transaction) => {
      const reference = this.documentFor(input);
      const snapshot = await transaction.get(reference);
      const data = snapshot.exists
        ? (snapshot.data() as Record<string, unknown> | undefined)
        : undefined;
      const field = quotaFields[input.kind];
      const used = readUsedCount(data, field);

      if (used >= input.limit) {
        throw new AiQuotaExhaustedError();
      }

      const nextUsed = used + 1;
      transaction.set(
        reference,
        {
          uid: input.uid,
          periodKey: input.periodKey,
          [field]: nextUsed,
          updatedAt: FieldValue.serverTimestamp(),
        },
        { merge: true },
      );

      return usageFor(input, nextUsed);
    });
  }

  async releaseUsage(input: AiQuotaRequest): Promise<AiQuotaUsage> {
    return this.firestore.runTransaction(async (transaction) => {
      const reference = this.documentFor(input);
      const snapshot = await transaction.get(reference);
      const data = snapshot.exists
        ? (snapshot.data() as Record<string, unknown> | undefined)
        : undefined;
      const field = quotaFields[input.kind];
      const used = readUsedCount(data, field);
      const nextUsed = Math.max(used - 1, 0);

      transaction.set(
        reference,
        {
          uid: input.uid,
          periodKey: input.periodKey,
          [field]: nextUsed,
          updatedAt: FieldValue.serverTimestamp(),
        },
        { merge: true },
      );

      return usageFor(input, nextUsed);
    });
  }

  private documentFor(input: AiQuotaRequest) {
    return this.firestore
      .collection(quotaCollection)
      .doc(`${input.uid}_${input.periodKey}`);
  }
}

function readUsedCount(
  data: Record<string, unknown> | undefined,
  field: string,
): number {
  const value = data?.[field];
  if (typeof value !== "number" || !Number.isInteger(value) || value < 0) {
    return 0;
  }
  return value;
}

function usageFor(input: AiQuotaRequest, used: number): AiQuotaUsage {
  return {
    periodKey: input.periodKey,
    limit: input.limit,
    used,
    remaining: Math.max(input.limit - used, 0),
  };
}
