
function Test-Wmic {
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage='Reference the computer(s) to query.')]
    [string[]]
    $ComputerName
  )
  
  begin {}
  
  process {

    $wmic = 'wmic.exe'
    [array]$param = @()

    # WMIC requirement: If the hostname has a "-" or a "/" then wrap the hostname in double quotes    
    if ($null -like $ComputerName) {
      $ComputerName = HOSTNAME.EXE
    }    

    foreach ($Computer in $ComputerName) {

      # WMIC requirement: If the hostname has a "-" or a "/" then wrap the hostname in double quotes
      $param = "/node:`"$($Computer)`"",'computersystem','get','name','/format:list'
      
      try {
        $Results = & $wmic $param
      }
      catch {
        Write-Output "Ran into an issue: $($PSItem.ToString())`n`nThis was the exception thrown: $($PSItem.Exception)"
      }
      $Filtered = $Results | Where-Object {$_}
      $ComputerName_Value = (($Filtered -split "=",2).trim())[1]
      
      $prop = @{
        ComputerName = $Computer
        WmicReturnedValue = $ComputerName_Value
      }

      $obj = New-Object -TypeName psobject -Property $prop
      Write-Output $obj       
      
    }

  }
  
  end {}
}

    <#
    try {
      Get-WmiObject -Class win32_computersystem -ComputerName $ComputerName -AsJob | Receive-Job -Wait  -ErrorAction Ignore
    }
    # By using the final catch below and writing " $($PSItem.Exception) " to the screen, I was able to derive the correct Error class to catch - which was in this case: [System.Runtime.InteropServices.COMException]
    catch [System.Runtime.InteropServices.COMException] {
      # This is here in order to prevent this particular Error class from being displayed to the screen
    }
    catch {
      Write-Output "Ran into an issue: $($PSItem.ToString())`n`nThis was the exception thrown: $($PSItem.Exception)"
    }
    #>