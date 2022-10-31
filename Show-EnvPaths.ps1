<#
https://stackoverflow.com/questions/24771455/getting-the-users-documents-folder-in-powershell
show all special folders and paths
#>
[enum]::GetNames( [System.Environment+SpecialFolder] ) | 
    Select @{ n="Name"; e={$_}},
        @{ n="Path"; e={ [environment]::getfolderpath( $_ ) }}
