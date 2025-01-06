param (
    [string]$environment
)

# Ensure PowerShell-YAML is installed and imported
if (-not (Get-Module -ListAvailable -Name powershell-yaml)) {
    Install-Module -Name powershell-yaml -Force -Scope CurrentUser
}
Import-Module powershell-yaml

# Path to the consolidated YAML file
$yamlPath = ".\consolidated-variables.yml"

# Check if the YAML file exists
if (-not (Test-Path $yamlPath)) {
    Write-Error "YAML file '$yamlPath' not found. Exiting."
    exit 1
}

# Load the YAML file
$yamlContent = Get-Content -Raw -Path $yamlPath
$librarySets = $yamlContent | ConvertFrom-Yaml

# Print the content of the loaded YAML for debugging
Write-Output "Loaded YAML Content:"
Write-Output $librarySets

# Directly access the variables dictionary
$variables = $librarySets

# Ensure the variables are not null before accessing them
if ($null -eq $variables) {
    Write-Error "Variables object is null. Exiting."
    exit 1
}

# Fetch environment-specific values
if ($variables.ContainsKey("CellName") -and $variables["CellName"].environments.ContainsKey($environment)) {
    $variableName = $variables["CellName"].environments[$environment].value
} else {
    Write-Error "CellName or environment '$environment' not found in variables. Exiting."
    exit 1
}

if ($variables.ContainsKey("DefaultVar") -and $variables["DefaultVar"].environments.ContainsKey($environment)) {
    $defaultValue = $variables["DefaultVar"].environments[$environment].value
} else {
    Write-Error "DefaultVar or environment '$environment' not found in variables. Exiting."
    exit 1
}

# Display the message
Write-Output "Hi $variableName, This workflow is running for $environment and has the default value as $defaultValue"
