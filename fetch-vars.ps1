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

# Load the YAML file
$yamlContent = Get-Content -Raw -Path $yamlPath
$librarySets = $yamlContent | ConvertFrom-Yaml

# Print the content of the loaded YAML for debugging
Write-Output "Loaded YAML Content:"
Write-Output $librarySets

# Directly access the variables dictionary
$variables = $librarySets

# Debugging: Print the fetched variables
Write-Output "Fetched Variables:"
Write-Output $variables

# Ensure the variables are not null before accessing them
if ($null -eq $variables) {
    Write-Output "Variables object is null. Exiting."
    exit 1
}

if ($variables.ContainsKey("CellName")) {
    $variableName = $variables["CellName"].value
} else {
    Write-Output "CellName not found in variables"
    exit 1
}

if ($variables.ContainsKey("DefaultVar")) {
    $defaultValue = $variables["DefaultVar"].value
} else {
    Write-Output "DefaultVar not found in variables"
    exit 1
}

# Display the message
Write-Output "Hi $variableName, This workflow is running for $environment and is having default value as $defaultValue"
