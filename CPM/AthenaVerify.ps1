#Read-Host is not compatible with TPC
Write-Host "Address:" #Prompts to enter the address
$url = [Console]::ReadLine() #Read the URL input from the console
Write-Host "TargetUser:"
$TargetUser = [Console]::ReadLine() #Read the target username from the console
Write-Host "CurrentPassword:"
$CurPass = [Console]::ReadLine() #Read the password input from the console

$uri = "$url/wp-json/wp/v2/users/me" #Define the API endpoint to retrieve user information

# Convert the username and password to Base64
$credentials = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes("${TargetUser}:${CurPass}"))

#Set the headers for the API request
$headers = @{
    "Content-Type" = "application/json" #Indicate that we're sending JSON data
	"Authorization" = "Basic $credentials" #Include the encoded credentials for authentication
}

#handle exceptions or errors that may occur during the execution of a block of code
try {
    $response = Invoke-RestMethod -Uri $uri -Method "GET" -Headers $headers #Make a GET request to the specified URI with the provided header

    # Check if the response contains the expected data
    if ($response -and $response.id) {
        Write-Host "Login Successful"
    } else {
        Write-Host "Login Failed" #Handles scenarios where the API call succeeds (no exceptions thrown) but the returned data does not meet your expectations (the user ID is missing)
    }
} catch {
    Write-Host "Login Failed" #Handles scenarios where the API call itself fails due to an error (e.g., network issues, invalid credentials, etc.)
}
