<#
.SYNOPSIS
  The "Get-WmicLocalUser" function is a wrapper for wmic.exe which returns information about local user accounts.

.EXAMPLE
  PS C:\> Get-WmicLocalUser        

  Disabled Name               SID
  -------- ----               ---
  FALSE    Administrator      S-1-5-21-1393670239-3599583528-2359510175-500
  TRUE     DefaultAccount     S-1-5-21-1393670239-3599583528-2359510175-503
  FALSE    MYusehr            S-1-5-21-1393670239-3599583528-2359510175-1004
  FALSE    JeaUser            S-1-5-21-1393670239-3599583528-2359510175-1026
  TRUE     WDAGUtilityAccount S-1-5-21-1393670239-3599583528-2359510175-504
  TRUE     WhoIsThisUser      S-1-5-21-1393670239-3599583528-2359510175-501 



  Here we run the function and get a list of local users, the corresponding SID, and whether the account is enabled/disabled.

.NOTES
  Name:  Get-WmicLocalUser.ps1
  Author:  Travis Logue
  Version History:  1.2 | 2021-12-29 | Added "-Domain" switch
  Dependencies:  
  Notes:
  - This was helpful:  https://stackoverflow.com/questions/53755993/wmic-useraccount-list-full-and-nothing-happen
  
  - It is highly recommended to only use "wmic.exe" for enumerating Local User accounts... "wmic.exe useraccount" will query all users in the Active Directory domain by default (without the use of ' where "localaccount=true" ') but it takes an enormously long time.  If you want all users in the domain just use "Get-ADUser -Filter *", which is exponentially faster than using wmic.exe

  .
#>


function Get-WmicLocalUser {
  [CmdletBinding()]
  param ()
  
  begin {}
  
  process {
    $wmic = wmic useraccount where "localaccount=true" get name,sid,disabled
    
    # We Trim the trailing spaces.  We replace the multiple Spaces with a Single Tab.  We Delimit on Tab.  The cmdlet automatically interprets the top line as the header.
    $wmic.trim() -replace '\s+',"`t" | ConvertFrom-Csv -Delimiter "`t"
  }
  
  end {}
}