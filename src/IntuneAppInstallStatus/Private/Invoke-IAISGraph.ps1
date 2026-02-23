function Invoke-IAISGraph {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)][ValidateSet('GET','POST','PATCH','DELETE')][string]$Method,
    [Parameter(Mandatory)][string]$Uri,
    [Parameter()]$Body,
    [Parameter()] [int] $MaxRetries = 6,
    [Parameter()] [int] $BaseDelaySeconds = 2,
    [Parameter()] [int] $MaxDelaySeconds = 30
  )

  $attempt = 0
  do {
    $attempt++
    try {
      $params = @{
        Method      = $Method
        Uri         = $Uri
        ContentType = 'application/json'
      }
      if ($null -ne $Body) {
        $params.Body = ($Body | ConvertTo-Json -Depth 15)
      }
      return Invoke-MgGraphRequest @params
    }
    catch {
      $msg = $_.Exception.Message
      $isThrottle  = ($msg -match '429|Too Many Requests|throttl')
      $isTransient = $isThrottle -or ($msg -match 'timeout|temporar|503|502|504')

      if (-not $isTransient -or $attempt -ge $MaxRetries) { throw }

      $delay = [Math]::Min($MaxDelaySeconds, [int]($BaseDelaySeconds * [Math]::Pow(2, ($attempt - 1))))
      Start-Sleep -Seconds $delay
    }
  } while ($true)
}
