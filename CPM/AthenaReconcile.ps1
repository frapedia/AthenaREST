Write-Host "Address:"
$url = [Console]::ReadLine()
Write-Host "TargetUser:"
$TargetUser = [Console]::ReadLine()
Write-Host "NewPassword:"
$NewPass = [Console]::ReadLine()
Write-Host "RecUser:"
$RecUser = [Console]::ReadLine()
Write-Host "RecPassword:"
$RecPassword = [Console]::ReadLine()


# Convert the reconcilie username and password to Base64 for Basic Authentication
$credentials = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes("${RecUser}:${RecPassword}"))


$headers = @{
    "Authorization" = "Basic $credentials"
    "Content-Type"  = "application/json"
}


$getUserEndpoint = "$url/wp-json/wp/v2/users?search=$TargetUser"

# Retrieve the user details
try {
    $userResponse = Invoke-RestMethod -Uri $getUserEndpoint -Headers $headers -Method Get
    if ($userResponse -and $userResponse.Count -eq 1) {
        $targetUserId = $userResponse[0].id
        Write-Host "User ID for $TargetUser is $targetUserId"
    } else {
        Write-Host "User not found or multiple users matched the username."
        exit
    }
} catch {
    Write-Host "Failed to retrieve user information."
    exit
}

# Define the API endpoint to update the user's password
$updateUserEndpoint = "$url/wp-json/wp/v2/users/$targetUserId"

# Create the payload with the new password
$body = @{
    "password" = $NewPass
} | ConvertTo-Json

# Make the request to update the user's password
try {
    $response = Invoke-RestMethod -Uri $updateUserEndpoint -Headers $headers -Method Post -Body $body 
    Write-Host "Reconcile Successful"
} catch {
    Write-Host "Reconcile Failed"
}
