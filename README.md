
# InfraPilot AI for AWS

<p align="center">
  <img src="deployment_diagram.png" alt="InfraPilot AI Architecture Diagram" width="800"/>
</p>

<p align="center">
    <em>An autonomous AI Agent for managing and operating AWS infrastructure using natural language.</em>
</p>

<p align="center">
    <a href="#-key-features">Features</a> •
    <a href="#-architecture">Architecture</a> •
    <a href="#-getting-started">Getting Started</a> •
    <a href="#-usage">Usage</a> •
    <a href="#-configuration">Configuration</a> •
    <a href="#-contributing">Contributing</a>
</p>

---

**InfraPilot AI** is a groundbreaking system that allows you to interact with and manage your Amazon Web Services (AWS) resources using natural language commands. Instead of writing complex scripts or manually navigating the AWS Console, you simply instruct the AI Agent, and it will autonomously analyze, plan, and execute the required tasks.

This project aims to simplify cloud infrastructure management, reduce human error, and accelerate deployment workflows for DevOps professionals, system engineers, and developers.

## ✨ Key Features

- **Natural Language Interface**: Create virtual machines, configure networks, or check security settings with simple, conversational commands.
- **Intelligent Planning**: The AI autonomously analyzes user requests, compares them against the current infrastructure state, and generates an optimal multi-step execution plan.
- **Extensible Tool System**: Easily extendable with new "tools" to interact with a wide range of AWS services (EC2, VPC, S3, RDS, IAM, etc.).
- **Persistent State Management**: Maintains a record of the infrastructure's state in a database, enabling the AI to make more accurate, context-aware decisions and prevent conflicts.
- **API-First Architecture**: The backend is built on FastAPI, ready for integration with custom user interfaces or other automation systems via REST API and WebSockets.
- **Multi-LLM Support**: Capable of connecting to various leading LLM providers, including OpenAI, Google Gemini, AWS Bedrock, and Anthropic.

## 🏗️ Architecture

InfraPilot AI is designed with a modular, scalable architecture:

1.  **Backend Server (Python/FastAPI)**:
    *   **API Layer**: Exposes REST and WebSocket endpoints for user interaction.
    *   **AI Agent Core**: The brain of the system. It uses an LLM to interpret requests, create plans, and select the appropriate tools.
    *   **Tool Factory & Adapters**: Provides a suite of tools for interacting with AWS APIs. Adapters abstract the underlying `boto3` calls for each service.
    *   **State Manager**: Tracks the state of provisioned AWS resources by interacting with the database.

2.  **PostgreSQL Database**:
    *   Serves as the persistent storage layer for the application.
    *   Stores user accounts and credentials (`users` table).
    *   Maintains a real-time state of discovered AWS resources (`discovered_resources` table).
    *   Logs all actions and infrastructure changes initiated by the agent (`infrastructure` table).

3.  **AI Providers**: An integration layer for communicating with external Large Language Models (LLMs) to provide reasoning and planning capabilities.

4.  **Amazon Web Services (AWS)**: The target cloud environment where resources (EC2, VPC, Security Groups, etc.) are provisioned and managed.

The diagram illustrates the workflow: A user sends a request to the backend. The AI Agent analyzes it, creates a plan, and executes it by invoking the corresponding AWS SDK (Boto3) functions. The results and state changes are persisted in the PostgreSQL database.

## 🚀 Getting Started

Follow these steps to deploy and run the project locally.

### Prerequisites

- Python 3.9+
- [Poetry](https://python-poetry.org/docs/#installation) for dependency and environment management.
- A running **PostgreSQL** server.
- [AWS CLI](https://aws.amazon.com/cli/) installed and configured with your credentials (via `aws configure` or environment variables).

### Installation

1.  **Clone the repository:**
    ```bash
    git clone https://your-repository-url/infrapilot-ai-aws.git
    cd infrapilot-ai-aws
    ```

2.  **Install dependencies:**
    Use Poetry to create a virtual environment and install all required packages.
    ```bash
    poetry install
    ```

3.  **Configure the environment:**
    Copy the example `.env.example` file to a new `.env` file.
    ```bash
    cp .env.example .env
    ```
    Open the `.env` file and provide the necessary values:
    - `DATABASE_URL`: Your PostgreSQL connection string (e.g., `postgresql://user:password@host:port/database`).
    - `AWS_REGION`: Your default AWS region (e.g., `us-east-1`).
    - `AWS_ACCESS_KEY_ID` & `AWS_SECRET_ACCESS_KEY`: Your AWS credentials. It's recommended to leave these blank if you have configured the AWS CLI or are using an IAM Role.
    - `OPENAI_API_KEY` (or another LLM provider's key): The API key for the AI Agent.

### Running the Application

Use Poetry to launch the FastAPI server with Uvicorn.
```bash
poetry run uvicorn ai_infra_agent.main:app --reload --host 0.0.0.0 --port 8080
```
The server will start and become available at `http://localhost:8080`.

## 💡 Usage

InfraPilot AI offers two primary ways to interact with the agent: via a web-based User Interface (UI) for an intuitive experience, or directly through its REST API and WebSockets for programmatic control and integration.

### Web User Interface

Once the backend server is running and the frontend application (located in `ai_infra_agent/UI`) is also launched, you can access the UI, typically at `http://localhost:3000` (or similar, depending on your frontend setup). The UI provides a conversational interface to submit natural language requests and view real-time updates on agent progress and infrastructure changes.

### REST API

For programmatic interaction, you can send natural language commands to the agent's `/api/v1/agent/execute` endpoint.

**Endpoint**: `POST /api/v1/agent/execute`

**Body (JSON)**:
```json
{
  "request": "Your natural language request here"
}
```
The `request` field accepts natural language descriptions of the AWS infrastructure changes you wish to achieve (e.g., "create a new EC2 instance", "delete an S3 bucket", "check the status of my VPC").

**Example with `curl`:**

Send a request to create an EC2 instance:
```bash
curl -X POST "http://localhost:8080/api/v1/agent/execute" \
     -H "Content-Type: application/json" \
     -d \
'{ 
  "request": "Create a t2.micro EC2 instance using the latest Amazon Linux 2023 AMI in the default VPC. Name it `my-test-server`."
}'
```

Upon receiving a request, the system will process it. You can monitor the server console logs for immediate feedback, or for real-time progress updates, connect to the agent's WebSocket endpoint (details of which would be available in the UI or API documentation).

## ⚙️ Configuration

The system's behavior can be customized through various configuration files:

- **`config.yaml`**: The main configuration file for adjusting agent, logging, and server parameters. Environment variables in the `.env` file will override values set here.
- **`settings/`**: This directory contains advanced configurations for the AI Agent:
    - `templates/decision-plan-prompt-optimized.txt`: The core prompt template used to instruct the LLM on how to analyze requests and create plans. This is where you can "teach" the AI how to behave.
   

## 🤝 Contributing

Contributions are welcome to make this project even better! Please feel free to create a Pull Request or open an Issue if you have ideas for improvements, bug fixes, or new tools.

1.  Fork the repository.
2.  Create a new branch (`git checkout -b feature/your-feature-name`).
3.  Make your changes.
4.  Commit your changes (`git commit -m 'Add some feature'`).
5.  Push to the branch (`git push origin feature/your-feature-name`).
6.  Open a Pull Request.

## 📄 License

This project is licensed under the MIT License. See the `LICENSE` file for more details.
