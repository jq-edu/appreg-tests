### retrouver les utilisateur en utilisant le graph via une requete rest
# nécessite d'avoir les permissions suivantes :
# - pour device code flow - Bookings.Read.All (Delegated)
# - pour client credentials flow - Bookings.Read.All (Application)

$uri = "$graphBaseUrl/solutions/bookingBusinesses"
$headers = @{
    Authorization = "Bearer $accessToken"
}
$bookings = Invoke-RestMethod -Uri $uri -Headers $headers -Method Get

# afficher les détails des booking incluant staff
$bookings.value | ForEach-Object {
    Write-Output ("Booking id: " + $_.id)
    Write-Output ("Booking name: " + $_.displayName)
    # afficher les détails du booking incluant staff
    $bookingUri = "https://graph.microsoft.com/v1.0/solutions/bookingBusinesses/" + $_.id
    $booking = Invoke-RestMethod -Uri $bookingUri -Headers $headers -Method Get
    Write-Output ("Booking created: " + $booking.createdDateTime)
    Write-Output ("Booking lastUpdated: " + $booking.lastUpdatedDateTime)
    Write-Output ("Booking isPublished: " + $booking.isPublished)
    Write-Output ("Booking email: " + $booking.email)

    $staffUri = "https://graph.microsoft.com/v1.0/solutions/bookingBusinesses/" + $_.id + "/staffMembers"
    $staff = Invoke-RestMethod -Uri $staffUri -Headers $headers -Method Get
    $staff.value | ForEach-Object {
        Write-Output ("Staff: " + $_.id)
        Write-Output ("Staff: " + $_.displayName)
    }
}

    
