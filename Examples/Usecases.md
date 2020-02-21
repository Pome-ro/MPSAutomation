# Importing your Data Blob
```Powershell
$data = Import-LocalizedData -BaseDirectory .\ -FileName datablob.psd1
```

# Get Staff by First and Last Name
```Powershell
$Staff = Get-MPSAStaff -filter {$_.First_Name -eq "John" -and $_.Last_Name -eq "Doe"} -Datablob $data
Write-Output $Staff
```

# Use that Data to find their AD Account
```Powershell
$GUID = $Staff.GUID
$ADAccount = Get-ADUser -Filter {EmployeeNumber -eq $GUID} -Properties EmployeeNumber
Write-Output $ADAccount
```
# Get Staff by TeacherNumber
```Powershell
$Staff = Get-MPSAStaff -filter {$_.TeacherNumber -eq "334572347"} -Datablob $data
Write-Output $Staff
```
# Get List of Students by Grade
```Powershell
$GradeFour = Get-MPSAStudent -filter {$_.Grade_Level -eq 4} -Datablob $data
Write-Output $GradeFour.count
```
# Filter Previous List by School
```Powershell
$SoutheastGradeFour = $GradeFour | Where-Object {$_.SchoolID -eq 22}
Write-Output $($SoutheastGradeFour.count)
```
# Get Student Schedule
```Powershell
$Student = Get-MPSAStudent -filter {$_.Student_Number -eq "23456"} -Datablob $data
$Schedule = Get-MPSAStudentSchedule -Student $Student -Datablob $data
$Schedule.Class_Name
```

# Get Teachers Homeroom Roster
```Powershell
$Teachers = Get-MPSAStaff -Filter {$_.SchoolID -eq 22} -Datablob $data


foreach ($Teacher in $Teachers) {
    $Schedule = Get-MPSAStaffSections -Teacher $Teacher -Datablob $data
    $Homeroom = $Schedule | Where-Object {$_.Course_Name -like "Homeroom*"}
    
    if ($homeroom -ne $null) {
        $Roster = Get-MPSASectionRoster -Section $Homeroom -Datablob $data
        
        ForEach ($Student in $Roster){
            Write-Host "$($student.Last_Name), $($student.First_Name)"
        }
    }
    
}
```