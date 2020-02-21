function Get-MPSASectionRoster {
    [CmdletBinding()]
    param (
        # Section
        [Parameter(Mandatory)]
        [System.Object]
        $Section,
        # Datablob
        [Parameter(Mandatory)]
        [System.Object]
        $Datablob        
    )
    
    begin {
        
    }
    
    process {
        foreach ($obj in $Section) {
            
            $schoolid = $obj.schoolid
            $tables = @{
                schedules = Import-Csv -Path $($datablob.rootpath + $schoolid + $datablob.filenames.schedules) -Header $datablob.headers.schedules
                sections = Import-Csv -Path $($datablob.rootpath + $schoolid + $datablob.filenames.sections) -Header $datablob.headers.sections
                courses = Import-Csv -Path $($datablob.rootpath + $schoolid + $datablob.filenames.courses) -Header $datablob.headers.courses
                teachers = Import-Csv -Path $($datablob.rootpath + $datablob.filenames.staff) -Header $datablob.headers.staff
            }
            
            $Students = $tables.schedules | Where-Object {$_.Course_Number -eq $obj.Course_Number -and $_.Section_Number -eq $obj.Section_Number}
            $RosterIDs = $Students.StudentID
            $Roster = foreach ($StudentID in $RosterIDs) {
                $Student = Get-Student -Filter {$_.ID -eq $StudentID} -Datablob $data
                $Student
            }
            
            $Roster
        }



    }
    
    end {
        
    }
}