function Get-StudentSchedule {
    [CmdletBinding()]
    param (
        # student
        [Parameter(Mandatory)]
        [System.Object]
        $Student,
        # Datablob
        [Parameter(Mandatory)]
        [System.Object]
        $Datablob
    )
    
    begin {

    }
    
    process {
        foreach ($obj in $student) {

            $schoolid = $obj.schoolid
            $tables = @{
                schedules = Import-Csv -Path $($datablob.rootpath + $schoolid + $datablob.filenames.schedules) -Header $datablob.headers.schedules
                sections = Import-Csv -Path $($datablob.rootpath + $schoolid + $datablob.filenames.sections) -Header $datablob.headers.sections
                courses = Import-Csv -Path $($datablob.rootpath + $schoolid + $datablob.filenames.courses) -Header $datablob.headers.courses
                teachers = Import-Csv -Path $($datablob.rootpath + $datablob.filenames.staff) -Header $datablob.headers.staff
            }
            $StudentSchedule = $tables.schedules | Where-Object {$_.StudentID -eq $obj.id}
            
            $Schedule = foreach ($item in $StudentSchedule) {
                $Section = $tables.sections | Where-Object {$_.Section_Number -eq $item.Section_Number -and $_.Course_Number -eq $item.Course_Number}
                $Course = $tables.courses | Where-Object {$_.Course_Number -eq $item.Course_Number}
                $teacher = $tables.teachers | Where-Object {$_.id -eq $Section.Teacher}    
                

                $newSchedule = New-Object -TypeName psobject 
                $newSchedule | Add-Member -MemberType NoteProperty -Name Teacher_Number -Value $teacher.TeacherNumber
                $newSchedule | Add-Member -MemberType NoteProperty -Name Teacher_FirstName -Value $teacher.First_Name
                $newSchedule | Add-Member -MemberType NoteProperty -Name Teacher_LastName -Value $teacher.Last_Name
                $newSchedule | Add-Member -MemberType NoteProperty -Name Student_Number -Value $obj.Student_Number
                $newSchedule | Add-Member -MemberType NoteProperty -Name Student_FirstName -Value  $obj.last_name
                $newSchedule | Add-Member -MemberType NoteProperty -Name Student_LastName -Value $obj.First_Name
                $newSchedule | Add-Member -MemberType NoteProperty -Name Class_Name -Value $($Teacher.Last_Name + " - " + $Course.Course_Name)
                $newSchedule | Add-Member -MemberType NoteProperty -Name Course_Number -Value $Course.Course_Number
                $newSchedule | Add-Member -MemberType NoteProperty -Name Section_Number -Value $Section.Section_Number

                $newSchedule
            }
            Write-Output $schedule
            #Write-Output $tables.schedules
        }
    }
    
    end {
        
    }
}