CREATE TABLE weather_logs (
    id BIGSERIAL PRIMARY KEY,
    run_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    city TEXT NOT NULL,
    temperature FLOAT,
    temperature_unit TEXT DEFAULT 'Celsius',
    condition TEXT,
    humidity INT,
    wind_speed FLOAT,
    alert_type TEXT,
    raw_response JSONB
);

-- Enable public access for n8n (or use Service Role Key)
ALTER TABLE weather_logs ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow n8n to insert" ON weather_logs FOR INSERT WITH CHECK (true);