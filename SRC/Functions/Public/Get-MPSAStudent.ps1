function Get-MPSAStudent {
    [CmdletBinding()]
    param (
        # filter
        [Parameter(Mandatory)]
        [scriptblock]
        $filter,
        # Datablob
        [Parameter(Mandatory)]
        [System.Object]
        $Datablob
    )
    
    begin {
        $StudentTable = Import-Csv -Path $($datablob.rootpath + $datablob.filenames.students) -Header $datablob.headers.students
    }
    
    process {
        $Student = $StudentTable | Where-Object $filter
        Write-Output $Student
    }
    
    end {
        
    }
}