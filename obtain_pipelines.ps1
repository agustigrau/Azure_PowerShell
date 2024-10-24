# Define variables
$organization = "your_organization_name"
$project = "your_project_name"
$pat = "your_personal_access_token"

# Base64 encode the PAT
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($pat)"))

# Define the API URL
$apiUrl = "https://dev.azure.com/$organization/$project/_apis/pipelines?api-version=6.0"

# Make the API request to get all pipelines
$pipelines = Invoke-RestMethod -Uri $apiUrl -Method Get -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)}

# Loop through each pipeline to get its runs
foreach ($pipeline in $pipelines.value) {
    $pipelineId = $pipeline.id
    $runsUrl = "https://dev.azure.com/$organization/$project/_apis/pipelines/$pipelineId/runs?api-version=6.0"
    $runs = Invoke-RestMethod -Uri $runsUrl -Method Get -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)}

    # Output the pipeline runs
    foreach ($run in $runs.value) {
        [PSCustomObject]@{
            PipelineName = $pipeline.name
            RunId = $run.id
            Status = $run.status
            Result = $run.result
            CreatedDate = $run.createdDate
        }
    }
}

Write-Output "Pipeline runs retrieved successfully."
