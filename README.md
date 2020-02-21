# MPSAutomation

This is an automation tool set for working with Power School Autosend Data. There are some assumptions under the hood about the kind of data you are exporting, and the kind of fields you are exporting. I have provided an example config file that you can modify to suite your enviroment. 

# Setup

This process assumes you have set up an Autosend in your Power School instance before. Here is a rundown of the kind of data this module expects to be exported.

* District Level
    * Students Table
        * id
        * student_number
        * studentpers_guid
        * SCHED_YEAROFGRADUATION
        * First_Name
        * Last_Name
        * Middle_Name
        * DOB
        * grade_level
        * enroll_status
        * ExitCode
        * ExitDate
        * schoolid
        * home_room
    * Staff Table
        * ID
        * TeacherNumber
        * GUID
        * Schoolid
        * Last_Name
        * First_Name
        * status
        * email_addr

* School Level (for each building you have in your system)
    * Sections 
        * ID
        * Course_Number
        * Section_Number
        * SchoolID
        * TermID
        * Teacher
    * Courses 
        * SchoolID
        * Course_Number
        * Course_Name
    * Schedules 
        * ID
        * TermID
        * StudentID
        * Section_Number
        * SchoolID
        * Course_Number

When configuring your exports, you want to have them share this convention `[School Number]_Section.csv`. You should have a _Section, _Courses, and _Schedules CSV file for each of your buildings, leading with the building number as configured in Power School. This is importent, because if you look through the list of fields exported, you'll see that every group of fields contains `SchoolID`. This makes it very simple to refrence the correct data set when using the cmdlets. So, once configured your directory should look like this:
```
students.csv
staff.csv
1_Sections.csv
1_Courses.csv
1_Schedules.csv
2_Sections.csv
2_Courses.csv
2_Schedules.csv
3_Sections.csv
3_Courses.csv
3_Schedules.csv
```

# Using this module
This Module assumes you have created a psd1 file based on the example provided in the `\Examples\` directory. You will need to import and refrence this file at the top of any script you may be using with this module. There is a longer list usecases in the `\Examples\Usecases.md`file.

### Importing your Data Blob
```Powershell
$data = Import-LocalizedData -BaseDirectory .\ -FileName datablob.psd1
```

### Get Staff by First and Last Name
```Powershell
$Staff = Get-MPSAStaff -filter {$_.First_Name -eq "John" -and $_.Last_Name -eq "Doe"} -Datablob $data
Write-Output $Staff

ID            : 1234
TeacherNumber : 09876543
GUID          : 115b6b68a1f14f4baaed2a15435796a4
Schoolid      : 0
Last_Name     : Doe
First_Name    : John
status        : 1
email_addr    : doej@schooldomain.edu
```