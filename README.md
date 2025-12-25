# Daily Weather Intelligence & Alert System

A production-grade automation workflow built with **n8n**, **Supabase**, and **OpenWeatherMap API**. This system handles multi-city data ingestion, executes threshold-based alert logic, maintains a persistent historical log, and delivers formatted notifications with built-in error resilience.

## 🚀 Key Features
- **Multi-City Processing:** Dynamic city configuration using an iterative logic engine.
- **Alert Intelligence:** Automated detection for Precipitation (Regex-based), Heat (>32°C), and Frost (<0°C).
- **Persistence Layer:** Structured data logging to Supabase (PostgreSQL).
- **Operational Resilience:** Global Error Trigger path to notify administrators of API or system failures.
- **Containerized Deployment:** Fully reproducible environment using Docker Compose.

---

## 🛠️ Tech Stack
- **Engine:** n8n (Self-hosted via Docker)
- **Database:** Supabase (PostgreSQL)
- **APIs:** OpenWeatherMap API
- **Language:** JavaScript (for transformation and alert logic)

---

## 📖 Setup & Installation

### 1. Infrastructure (Docker)
This project is containerized for environment parity. Use the following configuration to launch your instance:

<details>
<summary>View docker-compose.yml</summary>

```yaml
services:
  n8n:
    image: n8nio/n8n:latest
    restart: always
    ports:
      - "5678:5678"
    environment:
      - N8N_BASIC_AUTH_ACTIVE=true
      - N8N_BASIC_AUTH_USER=admin
      - N8N_BASIC_AUTH_PASSWORD=your_secure_password # Change this
      - GENERIC_TIMEZONE=UTC
    volumes:
      - ./n8n_data:/home/node/.n8n
```
</details> 

### 2. Database Schema (Supabase)
Execute the following SQL in your Supabase SQL Editor to prepare the persistence layer:

<details> 
<summary>View schema.sql</summary>

``` SQL
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

```

</details>


### 3. Workflow Import
1. Download the weather_automation.json file from this repository.

2. In n8n, click Workflow > Import from File.

3. Configure the following credentials:
    - **OpenWeatherMap API:** Create an API from https://openweathermap.org/api & set units to metric in n8n OpenWeatherMap node.

    - **Supabase API:** Project URL and Service Role Key.

    - **SMTP/Gmail:** App Password (16 character password) for secure email delivery (This can be found in your google account's page > security > search for app password)

---

## 📈 Workflow Logic
The workflow is divided into three logical layers:

  1. **The Ingestion Layer:** Uses a Schedule Trigger and a configuration node to inject target cities.

  2. **The Processing Layer:** Fetches real-time telemetry and pipes it through a JavaScript node to calculate alert statuses.

  3. **The Delivery Layer:** Synchronously updates the database and dispatches user notifications.

### Error Handling
The implementation includes a global **Error Trigger**. In the event of an API timeout or database connection failure, a separate contingency path is activated to log the error and notify the system administrator, ensuring high uptime and observability.


---

## 🌟 Bonus Requirements Implemented
- [x] **Configurable City:** Managed via the Configurable city JavaScript node.

- [x] **Multi-City Loop:** Native n8n iteration over city arrays.

- [x] **Retry Logic:** Enabled on the Weather API node to handle transient network blips.

- [x] **Error Resilience:** Global exception handling path.

---

_Developed as part of a technical automation assessment._
