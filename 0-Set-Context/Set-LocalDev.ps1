<#
.SYNOPSIS
    Importation intentionnelle des modules PowerShell et configuration de l'environnement.

.DESCRIPTION
    Ce script est utilisé uniquement lorsque on est en mode développement.

    Comme les modules peuvent varier selon les déploiements et les environnements, 
    je préfère les importer et charger de manière manuelle, similaire à l'utilisation 
    des packages NuGet en C#. Cela permet de s'assurer que les modules nécessaires sont 
    explicitement déclarés et importés, réduisant ainsi les risques de conflits ou de 
    dépendances manquantes.

    ** Les modules doivent être sauvergardé localement au préalable en utilisant Save-Module.

.NOTES
    Auteur: Joël Quimper
    Date: 2025-06-17
#>
# definition des variables pour le graph
$tenantId = "your-tenant-id"
$clientId = "your-client-id"
$clientSecret = "your-client-secret"
$graphBaseUrl = "https://graph.microsoft.com/v1.0"
$powerBiBaseUrl = "https://api.powerbi.com/v1.0/myorg"

# Importation des modules Microsoft Graph
$graphVersion = "2.25.0"
$graphPowerShellModulePath = "C:\src\PowerShellModules\Microsoft.Graph\$graphVersion"
$graphAuthenticationPowerShellModule = "$graphPowerShellModulePath\Microsoft.Graph.Authentication\2.25.0\Microsoft.Graph.Authentication.psd1"
$graphPowerShellModule = "$graphPowerShellModulePath\Microsoft.Graph\2.25.0\Microsoft.Graph.psd1"

$allGraphModules = Get-ChildItem -Path $graphPowerShellModulePath -Recurse -Filter *.psd1
$totalModulesCount = $allGraphModules.Count
Write-Output "Importaing Microsoft.Graph, there are $totalModulesCount modules to import."

# Ce module doit être chargé en premier pour éviter les erreurs de dépendances.
Write-Output "Importing module (1 / $totalModulesCount): $graphAuthenticationPowerShellModule"
Import-Module $graphAuthenticationPowerShellModule

$filteredGraphModules = $allGraphModules | Where-Object { $_.FullName -notlike "*Microsoft.Graph.Authentication.psd1*" } | Where-Object { $_.FullName -notlike "*Microsoft.Graph.psd1*" }
for ($i = 0; $i -lt $filteredGraphModules.Count; $i++) {
    $module = $filteredGraphModules[$i]
    Write-Output "Importing module ($($i+2) / $totalModulesCount): $($module.FullName)"
    Import-Module $module.FullName
}

# Ce module doit être chargé en dernier.
Write-Output "Importing module ($totalModulesCount / $totalModulesCount): $graphPowerShellModule"
Import-Module $graphPowerShellModule