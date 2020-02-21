function Get-MPSAStaff {
    [CmdletBinding()]
    param (
        # filter
        [Parameter(Mandatory)]
        [scriptblock]
        $filter,
        # inactive
        [Parameter()]
        [switch]
        $inactive,
        # Datablob
        [Parameter(Mandatory)]
        [System.Object]
        $Datablob
    )
    
    begin {
        $staffTable = Import-Csv -Path $($datablob.rootpath + $datablob.filenames.staff) -Header $datablob.headers.staff
    }
    
    process {
        # Filter the staff based on cmdlet filter
        $staff = $staffTable | Where-Object $filter

        # Filter out innactive users, unless requested
        if ($innactive) {
            $staff = $staff | Where-Object {$_.status -eq 2}
        } else {
            $staff = $staff | Where-Object {$_.status -eq 1} 
        }

        Write-Output $staff
    }
    
    end {
        
    }
}