param (
    [string]$environment
)

# Ensure PowerShell-YAML is installed and imported
if (-not (Get-Module -ListAvailable -Name powershell-yaml)) {
    Install-Module -Name powershell-yaml -Force -Scope CurrentUser
}
Import-Module powershell-yaml

# Create the consolidated YAML content based on environment
$yamlContent = @"
# Variables for $environment
CellName:
  value: "$environment"
DefaultVar:
  value: "default-value-for-$environment"
"@

# Write the YAML content to a file
$yamlContent | Out-File -FilePath ".\consolidated-variables.yml"

# Load and parse the YAML
$variables = $yamlContent | ConvertFrom-Yaml

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
