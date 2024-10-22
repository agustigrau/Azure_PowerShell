# Variables
$beacon = "your_pat"
$organization = "your_organization"
$subject = "Agusti Grau provides this code"
$emailTo = "target address"
$emailFrom = "original address"
$smtpServer = "smtp server"

$url = "https://dev.azure.com/$organization/_apis/projects?api-version=6.0"
$projects = Invoke-RestMethod -Uri $url -Method Get -Headers @{Authorization = "Basic $([Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$beacon")))"}
$renamedProjects = @()
foreach ($project in $projects) {
        $lastUpdateTime = $project.lastUpdateTime
        if ((Get-Date) - $lastUpdateTime -lt (New-TimeSpan -Days 1)) {
            $renamedProjects += $project
            Write-Host $project.name + "has been updated"
        }
    }
if ($renamedProjects.Count -gt 0) {
        $body = "The following projects have been renamed:`n`n"
    foreach ($project in $renamedProjects) {
        $body += "Project ID: $($project.id), Name: $($project.name), Last Updated: $($project.lastUpdateTime)`n"
    }
    $send = Send-MailMessage -To $emailTo -SmtpServer $smtpServer -From $emailFrom -Subject $Subject -Body $body
    Write-Host "The email has been sent: $send"
}
Write-Output "The script has checked for renamed Azure DevOps projects and sent an email if any were found."
