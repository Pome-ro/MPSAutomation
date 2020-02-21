function Get-MPSAStaffSections {
    [CmdletBinding()]
    param (
        # Teacher
        [Parameter(Mandatory)]
        [System.Object]
        $Teacher,
        # Datablob
        [Parameter(Mandatory)]
        [System.Object]
        $Datablob
    )
    
    begin {

    }
    
    process {
        foreach ($obj in $Teacher) {

            $schoolid = $obj.schoolid

            $tables = @{
                schedules = Import-Csv -Path $($datablob.rootpath + $schoolid + $datablob.filenames.schedules) -Header $datablob.headers.schedules
                sections = Import-Csv -Path $($datablob.rootpath + $schoolid + $datablob.filenames.sections) -Header $datablob.headers.sections
                courses = Import-Csv -Path $($datablob.rootpath + $schoolid + $datablob.filenames.courses) -Header $datablob.headers.courses
                teachers = Import-Csv -Path $($datablob.rootpath + $datablob.filenames.staff) -Header $datablob.headers.staff
            }
            $TeacherSchedule = $tables.sections | Where-Object {$_.Teacher -eq $obj.id}
            
            $ScheduleList = foreach ($item in $TeacherSchedule) {
                $Section = $tables.sections | Where-Object {$_.Section_Number -eq $item.Section_Number -and $_.Course_Number -eq $item.Course_Number}
                $Course = $tables.courses | Where-Object {$_.Course_Number -eq $item.Course_Number}
                $teacher = $tables.teachers | Where-Object {$_.id -eq $Section.Teacher}    

                $item | Add-Member -MemberType NoteProperty -Name Course_Name -Value $Course.Course_Name
                $item
            }
            Write-Output $ScheduleList
            #Write-Output $tables.schedules
        }
    }
    
    end {
        
    }
}