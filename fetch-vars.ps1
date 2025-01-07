param (
    [string]$environment
)

# Ensure PowerShell-YAML is installed and imported
if (-not (Get-Module -ListAvailable -Name powershell-yaml)) {
    Install-Module -Name powershell-yaml -Force -Scope CurrentUser
}
Import-Module powershell-yaml

# Path to the library YAML file
$yamlPath = ".\library-variables.yml"

# Load the YAML file
$yamlContent = Get-Content -Raw -Path $yamlPath
$librarySets = $yamlContent | ConvertFrom-Yaml

# Fetch variables for the selected environment
$variables = $librarySets.library_sets
Write-Output "Values are below: -" 
Write-Output "$variables"


if ($null -eq $variables) {
    Write-Output "Variables object is null. Exiting."
    exit 1
}

if ($variables["CellName"].environments.ContainsKey($environment)) {
    $variableName = $variables["CellName"].environments[$environment].value
} else {
    Write-Output "Environment '$environment' not found in CellName. Exiting."
    exit 1
}

if ($variables.ContainsKey("DefaultVar")) {
    $defaultValue = $variables["DefaultVar"].value
} else {
    Write-Output "DefaultVar not found in variables. Exiting."
    exit 1
}

# Display the message
Write-Output "Hi $variableName, This workflow is running for $environment and is having default value as $defaultValue"
