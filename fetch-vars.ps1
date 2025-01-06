param (
    [string]$environment
)

# Ensure PowerShell-YAML is installed and imported
if (-not (Get-Module -ListAvailable -Name powershell-yaml)) {
    Install-Module -Name powershell-yaml -Force -Scope CurrentUser
}
Import-Module powershell-yaml

# Path to the YAML file
$yamlPath = "library-variables.yml"

Write-Output "Processing environment: $environment"

try {
    # Load and parse the YAML file
    $yamlContent = Get-Content -Raw -Path $yamlPath
    $librarySets = $yamlContent | ConvertFrom-Yaml

    # Initialize variables
    $variables = @{}

    # Process each variable set
    foreach ($set in $librarySets.library_sets.GetEnumerator()) {
        $varName = $set.Key
        
        # Check for environment-specific variables
        if ($set.Value.environments -ne $null -and 
            $set.Value.environments.ContainsKey($environment)) {
            $variables[$varName] = @{ 
                value = $set.Value.environments[$environment].value 
            }
        }
        # Use default value if available and no environment override exists
        elseif ($set.Value.ContainsKey("value") -and 
                -not $variables.ContainsKey($varName)) {
            $variables[$varName] = @{ 
                value = $set.Value.value 
            }
        }
    }

    # Get required variables with error handling
    $variableName = if ($variables.ContainsKey("CellName")) {
        $variables["CellName"].value
    } else {
        Write-Error "CellName not found in variables for environment: $environment"
        exit 1
    }

    $defaultValue = if ($variables.ContainsKey("DefaultVar")) {
        $variables["DefaultVar"].value
    } else {
        Write-Error "DefaultVar not found in variables for environment: $environment"
        exit 1
    }

    # Display the message
    Write-Output "Hi $variableName, This workflow is running for $environment and is having default value as $defaultValue"
}
catch {
    Write-Error "Error processing variables: $_"
    exit 1
}
