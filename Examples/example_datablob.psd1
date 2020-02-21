<#
    This Datablob contains the headers and the file paths to each of the CSV files required for this module.
    The paths are genaric. Each file should be named following the convention [schoolid]_sections.csv. 
    the rootPath is the path to the directory in which your CSV files are stored. 
#>

@{  # These headers match the fields that are exported from PowerSchool. These headers should be in the same order as your Autosend field lists. 
    headers = @{  
        sections = @("ID","Course_Number","Section_Number","SchoolID","TermID","Teacher")
        courses = @("SchoolID","Course_Number","Course_Name")
        schedules = @("ID","TermID","StudentID","Section_Number","SchoolID","Course_Number")
        # The GUID in these two headers is the studentpers_guid and staffpers_guid respectively. 
        # These GUIDs can be used to uniquely identify both Staff and Students. 
        # Personally I use it to stich PowerSchool and Active Directory data together.
        students = @("id","student_number","GUID","SCHED_YEAROFGRADUATION","First_Name","Last_Name","Middle_Name","DOB","grade_level","enroll_status","ExitCode","ExitDate","schoolid","home_room")
        staff = @("ID","TeacherNumber","GUID","Schoolid","Last_Name","First_Name","status","email_addr")
    }
    # this is the location where all the PowerSchool Autosend CSV files are stored.
    rootPath = "\\YourServer\SomeShareFolder\"  
    
    # These are the recomended filenames. The system assumes that each CSV file is prepended with the school number, so 99_sections.csv as an example.
    fileNames = @{ 
        sections = "_sections.csv"
        courses = "_courses.csv"
        schedules = "_schedules.csv"
        students = "students.csv"
        staff = "staff.csv"
    }

}