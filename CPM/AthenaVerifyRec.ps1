#Read-Host is not compatible with TPC
Write-Host "Address:"
$url = [Console]::ReadLine()
Write-Host "TargetUser:"
$TargetUser = [Console]::ReadLine()
Write-Host "CurrentPassword:"
$CurPass = [Console]::ReadLine()

$uri = "$url/wp-json/wp/v2/users/me"

# Convert the username and password to Base64
$credentials = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes("${TargetUser}:${CurPass}"))

$headers = @{
    "Content-Type" = "application/json"
	"Authorization" = "Basic $credentials"
}


try {
    $response = Invoke-RestMethod -Uri $uri -Method "GET" -Headers $headers 

    # Check if the response contains the expected data
    if ($response -and $response.id) {
        Write-Host "Login Successful"
    } else {
        Write-Host "Login Failed"
    }
} catch {
    Write-Host "Login Failed"
}
