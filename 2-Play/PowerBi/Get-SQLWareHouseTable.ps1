## read from Fabric WareHouse using SQLServer Powershell module
# requires the SqlServer module to be installed
# requires the following permissions:
# - user_impersonnation  

$warehouseServerAddress = Read-Host("`nPlease provide your datawarehouse server address ")
$warehouseDatabaseName = Read-Host("`nPlease provide your datawarehouse name ")
$sqlQuery = "SELECT TOP 10 * FROM dbo.table1"

$result = Invoke-Sqlcmd -ServerInstance $warehouseServerAddress -Database $warehouseDatabaseName -AccessToken $accessToken -Query $sqlQuery