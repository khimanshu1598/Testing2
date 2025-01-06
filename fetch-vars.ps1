param (
    [string]$environment
)

# Ensure PowerShell-YAML is installed and imported
if (-not (Get-Module -ListAvailable -Name powershell-yaml)) {
    Install-Module -Name powershell-yaml -Force -Scope CurrentUser
}
Import-Module powershell-yaml

# Path to the consolidated YAML file
$yamlPath = ".\library-variables.yml"  # Make sure this path is correct

# Load the YAML file
$yamlContent = Get-Content -Raw -Path $yamlPath
$librarySets = $yamlContent | ConvertFrom-Yaml

# Print the content of the loaded YAML for debugging
Write-Output "Loaded YAML Content:"
Write-Output $librarySets

# Access the variables dictionary
$variables = $librarySets

# Debugging: Print the fetched variables
Write-Output "Fetched Variables:"
Write-Output $variables

# Ensure the variables are not null before accessing them
if ($null -eq $variables) {
    Write-Output "Variables object is null. Exiting."
    exit 1
}

# Access the environment-specific values
if ($variables.ContainsKey("CellName") -and $variables["CellName"].environments.ContainsKey($environment)) {
    $variableName = $variables["CellName"].environments[$environment].value
} else {
    Write-Output "CellName not found for the environment $environment"
    exit 1
}

if ($variables.ContainsKey("DefaultVar")) {
    $defaultValue = $variables["DefaultVar"].value
} else {
    Write-Output "DefaultVar not found in variables"
    exit 1
}

# Display the message
Write-Output "Hi $variableName, This workflow is running for $environment and has the default value as $defaultValue"
