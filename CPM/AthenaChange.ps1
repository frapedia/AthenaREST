Write-Host "Address:"
$url = [Console]::ReadLine()
Write-Host "TargetUser:"
$TargetUser = [Console]::ReadLine()
Write-Host "CurrentPassword:"
$CurPass = [Console]::ReadLine()
Write-Host "NewPassword:"
$NewPass = [Console]::ReadLine()

$uri = "$url/wp-json/wp/v2/users/me"

# Convert the username and current password to Base64 for Basic Authentication
$credentials = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes("${TargetUser}:${CurPass}"))

$headers = @{
    "Authorization" = "Basic $credentials"
    "Content-Type"  = "application/json"
}
$body = @{    
    "password" = $NewPass
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -uri $uri -Method "POST" -Headers $headers -Body $body

    # Check if the response contains the expected data
    if ($response -and $response.id) {
        Write-Host "Change Successful"
    } else {
        Write-Host "Change Failed"
    }
} catch {
    Write-Host "Change Failed"
}
