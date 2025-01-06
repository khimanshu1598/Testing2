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

# Access the library_sets dictionary
$librarySets = $librarySets.library_sets

# Ensure the variables are not null before accessing them
if ($null -eq $librarySets) {
    Write-Output "library_sets object is null. Exiting."
    exit 1
}

# Fetch variables for the provided environment
if ($librarySets.ContainsKey("CellName") -and $librarySets.CellName.environments.ContainsKey($environment)) {
    $variableName = $librarySets.CellName.environments[$environment].value
} else {
    Write-Output "CellName for $environment not found in variables"
    exit 1
}

if ($librarySets.ContainsKey("DefaultVar")) {
    $defaultValue = $librarySets.DefaultVar.value
} else {
    Write-Output "DefaultVar not found in variables"
    exit 1
}

# Display the message
Write-Output "Hi $variableName, This workflow is running for $environment and the default value is $defaultValue"
