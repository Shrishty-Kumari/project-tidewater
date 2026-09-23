-- Safe expand phase. Old and new releases can coexist.
CREATE TABLE IF NOT EXISTS bank_payments(id BIGSERIAL PRIMARY KEY,idempotency_key TEXT NOT NULL UNIQUE,settlement_id UUID NOT NULL REFERENCES settlements(settlement_id),amount_cents BIGINT NOT NULL,created_at TIMESTAMPTZ NOT NULL DEFAULT now());
CREATE INDEX IF NOT EXISTS idx_bank_payments_settlement_id ON bank_payments(settlement_id);
