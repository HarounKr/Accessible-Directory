﻿# Lister les utilisateurs connectes entre deux heures specifiques

param(
    [Parameter(Mandatory=$true)]
    [string]$StartTime,  # Format: "yyyy-MM-dd HH:mm:ss"
    [Parameter(Mandatory=$true)]
    [string]$EndTime     # Format: "yyyy-MM-dd HH:mm:ss"
)

try {
    $startTime = Get-Date $StartTime -ErrorAction Stop
    $startTime
    $endTime = Get-Date $EndTime -ErrorAction Stop
} catch {
    Write-Host "Les dates fournies ne sont pas valides. Utilisez le format 'yyyy-MM-dd HH:mm:ss'."
    exit 1
}

# Récupérer les événements
$events = Get-WinEvent -FilterHashtable @{
    LogName = 'Security';
    StartTime = $startTime;
    EndTime = $endTime;
    ID = 4624
} | Select-Object TimeCreated, @{
    Name = "Utilisateur";
    Expression = {
        $_.Properties[5].Value
    }
}

# Chemin du fichier Excel de sortie
$outputFile = "$PWD\Rapport_Connexions_Utilisateurs.xlsx"

# Exporter vers un fichier Excel

$events | Export-Excel -Path $outputFile -WorksheetName 'Connexions utilisateurs' -AutoSize

Write-Host "Les événements ont été exportés dans le fichier $outputFile"


# .\Get-ConnectedUsersBeetweenTimes.ps1 -StartTime "2024-12-11 08:00:00" -EndTime "2024-12-11 18:00:00"