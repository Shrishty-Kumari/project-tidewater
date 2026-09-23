CREATE TABLE IF NOT EXISTS settlements(settlement_id UUID PRIMARY KEY,merchant_id BIGINT NOT NULL,amount_cents BIGINT NOT NULL CHECK(amount_cents>0),request_id TEXT NOT NULL,status TEXT NOT NULL DEFAULT 'queued',created_at TIMESTAMPTZ NOT NULL DEFAULT now(),paid_at TIMESTAMPTZ);
CREATE INDEX IF NOT EXISTS idx_settlements_status ON settlements(status);
