Function Get-PuppetRole
{
<#
    .SYNOPSIS

    .DESCRIPTION

    .EXAMPLE

#>
    [CmdletBinding()]
    Param
    (
        [ValidateScript( {Test-Path($_) } )]
        [Parameter(Mandatory = $false)]
        [string]$PuppetRolePath = 'C:\ProgramData\PuppetLabs\facter\facts.d\role.txt'
    )

    #set custom propertie 1 to puppet role else set it to '$false'
    if(Test-Path $PuppetRolePath){
        $puppetrole = Select-String -Path $PuppetRolePath -SimpleMatch "configured_role="
        $puppetrole = $puppetrole.Line.substring(16)
    } else {
        $puppetrole = $false
    }

    $puppetrole

}
