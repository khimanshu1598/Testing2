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

# Validate the structure
if ($null -eq $librarySets.library_sets) {
    Write-Output "Error: library_sets section is missing. Exiting."
    exit 1
}

# Initialize result objects
$environmentVariables = @{}
$defaultVariables = @{}

# Process all variables in the library_sets section
foreach ($variable in $librarySets.library_sets.GetEnumerator()) {
    $variableName = $variable.Key
    $variableData = $variable.Value

    # Check for environment-specific data
    if ($variableData.ContainsKey("environments")) {
        if ($variableData.environments.ContainsKey($environment)) {
            $environmentVariables[$variableName] = $variableData.environments[$environment].value
        }
    }

    # Check for global/default data
    if ($variableData.ContainsKey("value")) {
        $defaultVariables[$variableName] = $variableData.value
    }
}

# Output the results
Write-Output "Environment-Specific Variables for '$environment':"
$environmentVariables | ForEach-Object { Write-Output "$($_.Key): $($_.Value)" }

Write-Output "Global/Default Variables:"
$defaultVariables | ForEach-Object { Write-Output "$($_.Key): $($_.Value)" }
