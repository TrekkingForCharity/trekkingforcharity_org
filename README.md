# TrekkingForCharity

A modern .NET application for managing and promoting charity trekking initiatives. This project combines a [Blazor WebAssembly](https://docs.microsoft.com/aspnet/core/blazor/?view=aspnetcore-6.0#blazor-webassembly) client application with a .NET 8 C# [Azure Functions](https://docs.microsoft.com/azure/azure-functions/functions-overview) API backend and shared utilities.

## Getting Started

1. Create a repository from the [GitHub template](https://docs.github.com/en/enterprise/2.22/user/github/creating-cloning-and-archiving-repositories/creating-a-repository-from-a-template) and then clone it locally to your machine.

1. In the **Api** folder, copy `local.settings.example.json` to `local.settings.json`

1. Continue using either Visual Studio or Visual Studio Code.

### Visual Studio 2022

Once you clone the project, open the solution in the latest release of [Visual Studio 2022](https://visualstudio.microsoft.com/vs/) with the Azure workload installed, and follow these steps:

1. Right-click on the solution and select **Configure Startup Projects...**.

1. Select **Multiple startup projects** and set the following actions for each project:
    - *TrekkingForCharity.Api* - **Start**
    - *TrekkingForCharity.Client* - **Start**
    - *TrekkingForCharity.Shared* - None

1. Press **F5** to launch both the client application and the Functions API app.

### Visual Studio Code with Azure Static Web Apps CLI for a better development experience (Optional)

1. Install (or update) the [Azure Static Web Apps CLI](https://www.npmjs.com/package/@azure/static-web-apps-cli) and [Azure Functions Core Tools CLI](https://www.npmjs.com/package/azure-functions-core-tools).

1. Open the folder in Visual Studio Code.

1. Delete file `Client/wwwroot/appsettings.Development.json`

1. In the VS Code terminal, run the following command to start the Static Web Apps CLI, along with the Blazor WebAssembly client application and the Functions API app:

    In the Client folder, run:
    ```bash
    dotnet run
    ```

    In the API folder, run:
    ```bash
    func start
    ```

    In another terminal, run:
    ```bash
    swa start http://localhost:5000 --api-location http://localhost:7071
    ```

    The Static Web Apps CLI (`swa`) starts a proxy on port 4280 that will forward static site requests to the Blazor server on port 5000 and requests to the `/api` endpoint to the Functions server. 

1. Open a browser and navigate to the Static Web Apps CLI's address at `http://localhost:4280`. You'll be able to access both the client application and the Functions API app in this single address. When you navigate to the "Fetch Data" page, you'll see the data returned by the Functions API app.

1. Enter Ctrl-C to stop the Static Web Apps CLI.

## Project Structure

```
trekkingforcharity_org/
├── src/
│   ├── TrekkingForCharity.Client/      # Blazor WebAssembly UI
│  Code Quality & Analysis

### EditorConfig

The project uses [EditorConfig](https://editorconfig.org) for consistent code formatting across all files. Configuration is defined in `.editorconfig` which includes:

- Code style conventions for C#
- Naming conventions for variables and members
- Formatting rules for indentation and spacing

### Coding Conventions

**Blazor Components**

- **Use code-behind files**: All Blazor components (`.razor` files) should use separate code-behind files (`.razor.cs`) instead of inline `@code` blocks
- **Benefits**:
  - Better separation of concerns (markup vs. logic)
  - Improved testability
  - Full IDE support and IntelliSense
  - Easier code navigation and maintenance

**Example Structure:**
```
Counter.razor       # Contains only markup and directives
Counter.razor.cs    # Contains ComponentBase class with logic
```

### SonarQube Integration

This project is integrated with [SonarQube](https://www.sonarqube.org) for continuous code quality analysis:

- **Local Analysis**: Run `.\build\SonarQube.ps1 -SonarToken "your-token" -Analysis`
- **CI/CD Pipeline**: Automated analysis on push and pull requests
- **Security Scanning**: Vulnerability and security hotspot detection

For detailed setup instructions, see [.sonarqube/README.md](.sonarqube/README.md)

## Running Tests

```bash
# Run all tests
dotnet test

# Run API tests only
dotnet test tests/TrekkingForCharity.Api.Tests/TrekkingForCharity.Api.Tests.csproj

# Run Client tests only
dotnet test tests/TrekkingForCharity.Client.Tests/TrekkingForCharity.Client.Tests.csproj
```

### Snapshot Testing with Verify

This project uses snapshot testing for robust assertions. When tests fail due to output changes, review and approve the new snapshots using Verify:

```bash
# Install the Verify tool (first time only)
dotnet tool install -g verify.tool

# Or install via repo scripts
./build/install-verify-tool.sh      # Linux/macOS
.\build/install-verify-tool.ps1     # Windows

# Manage snapshots interactively
dotnet-verify review
```

See [build/VERIFY.md](build/VERIFY.md) for detailed snapshot testing guidance.

## Build Tasks

Available build tasks in VS Code:

- **build (functions)**: Build the API project
- **clean (functions)**: Clean the API project build
- **publish (functions)**: Publish for Azure Functions
- **test**: Run all test suites

## SonarQube Analysis Scripts

The project includes cross-platform scripts for running SonarQube analysis:

**Windows (PowerShell):**
```powershell
.\build\SonarQube.ps1 -SonarToken "your-token" -Analysis
```

**Linux/macOS (Bash):**
```bash
./build/SonarQube.sh --token "your-token" --analysis
```

For detailed setup instructions, see [.sonarqube/README.md](.sonarqube/README.md)

## Git Hooks

This project includes git hooks that automatically build and test code before commits. To install:

**Linux/macOS:**
```bash
./build/install-hooks.sh
```

**Windows (PowerShell):**
```powershell
.\build\install-hooks.ps1
```

See [build/HOOKS.md](build/HOOKS.md) for more details.

##  ├── TrekkingForCharity.Api/         # Azure Functions backend
│   └── TrekkingForCharity.Shared/      # Shared models and utilities
├── tests/
│   ├── TrekkingForCharity.Api.Tests/   # API unit tests
│   └── TrekkingForCharity.Client.Tests/ # Client unit tests
├── build/                               # Build scripts
├── .sonarqube/                          # SonarQube configuration
└── TrekkingForCharity.sln              # Solution file
```

## Key Features

- **Modern C# Development**: Uses .NET 8 and .NET 10 with latest language features
- **Code Quality**: EditorConfig for consistent code style across all projects
- **Code Analysis**: SonarQube integration for security and code quality scanning
- **Testing**: Comprehensive unit test projects for both API and Client
- **Azure Integration**: Azure Functions backend with Application Insights monitoring

## Deploy to Azure Static Web Apps

This application can be deployed to [Azure Static Web Apps](https://docs.microsoft.com/azure/static-web-apps), to learn how, check out [our quickstart guide](https://aka.ms/blazor-swa/quickstart).
