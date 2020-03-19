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
                $Student = Get-MPSAStudent -Filter {$_.ID -eq $StudentID} -Datablob $data
                $Student
            }
            
            $Roster
        }



    }
    
    end {
        
    }
}
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
