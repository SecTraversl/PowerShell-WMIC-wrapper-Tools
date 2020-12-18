
function Get-WmicProcessFindRdpClip {
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
      $param = "/node:`"$($Computer)`"",'computersystem','get','username','/format:list'


      ########################
            # this worked
            $rdpclip = "'rdpclip.exe'"
            wmic process where "name like $rdpclip"  call GetOwner
      
            # combine with this, this worked too
            wmic /node:`"zogtheexpert`" process list brief
      
      
            # FINAL !!!! this works
            $rdpclip = "'rdpclip.exe'"
            wmic /node:`"zogtheexpert`" process where "name like $rdpclip"  call GetOwner




            $explorer = "'explorer.exe'"

            $FindExplorer = wmic /node:`"zogtheexpert`" process where "name like $explorer" get name,processid,parentprocessid,commandline /format:list
            $FindExplorer | ? {$_} 

            if ($FindExplorer) {
              
            }
            wmic /node:`"zogtheexpert`" process where "name like $explorer"  call GetOwner
      ########################


      
      try {
        $Results = & $wmic $param
      }
      catch {
        Write-Output "Ran into an issue: $($PSItem.ToString())`n`nThis was the exception thrown: $($PSItem.Exception)"
      }
      $Filtered = $Results | Where-Object {$_}
      $UserName_Value = (($Filtered -split "=",2).trim())[1]
      
      $prop = @{
        ComputerName = $Computer
        WmicReturnedValue = $UserName_Value
      }

      $obj = New-Object -TypeName psobject -Property $prop
      Write-Output $obj       
      
    }

  }
  
  end {}
}
