# Setting up an Assignment in Vocareum

### Assignment Creation and Configuration

1. From the `Assignments` page, create a new assignment by clicking `New Assignment` at the top right of the page.
1. Title the assignment, select `Visual Studio Code` from the center dropdown, and assign the assignment to a group. Then click `Save and continue`.
1. Configure the assignment setting by clicking `Part 1`.
1. In the `Lab Definition` section, set the `Container Image` dropdown to `fundies-core-v1.0` (at time of writing).
1. In the `Rubrics` section, click `+ Grading Criterion`. Set the name of the criterion, at time of writing this is `Automated Testing`.
1. Set the `Max Score` value to the `Points` value defined in the weeks `README.md` file.  
>The grading criterion name can be anything, but it **MUST** match the `grading_criterion_name` value in the `grade.sh` file for automated grading to work properly.

>The value of `Max Score` **MUST** be the same as the `total_points` value in the `grade.sh` file for automated grading to work properly.

##### With these values set, click `Save Part` on the left side of the screen.  You should see a `Success` popup in the bottom right.

### Configure Workspace

Select the assignment you want to configure and click the `Configure Workspace` button.  Load times can be excessive...

#### With Setup Script

1. Drag and drop the setup script to the `private` directory.
1. Open a terminal from the hamburger menu on the left, navigate to `/voc/private`, and follow the usage instructions in the script comments.
1. Replace the generated `grade.sh` file with the one from the exercise repository.

#### Without Setup Script

Create directories under `startercode`.

| Directory Name     | Purpose                                                                                       |
|--------------------|-----------------------------------------------------------------------------------------------|
| .vscode*           | Contains VS Code configuration files.                                                         |
| ExerciseName       | A directory by the name of the exercise is used for student code.                             |
| ExerciseNameTests* | Used by some environments to hold the data for the test runner.                               |
| AutomatedTesting*  | Used by some environments to hold the data for the test runner.                               |
| TestResults*       | Used by some environments to allow students to get rapid test feedback on their current code. |
>Note* not all environments use the same directory structure.

Copy the relevant files from the `Vocareum` directory of the repository to the `startercode` directory in Vocareum.

| File Name      | Destination Directory | Explanation                                                                   | 
|----------------|-----------------------|-------------------------------------------------------------------------------|
| `grade.sh`     | /voc/scripts          | Vocareum grade script - ALL exercises.                                        |
| `*.cs`         | ExerciseNameTests     | C# test runner file - Object Oriented Programming & Back End Web Development. |
| `*.c`          | ExerciseNameTests     | C test runner file - Procedural Programming.                                  |
| `run_tests.sh` | /voc/startercode      | Test runner script providing rapid feedback for student code.                 |
| `*.spec.ts`    | AutomatedTesting      | Playwright test runner file - Front End Web Development.                      |

Reference the exercise instructions and create/copy any relevant starter files into the `ExerciseName` directory.

>If applicable, place a copy of the solution code in the `/voc/private` directory.

### Testing

1. Click `Student View` in the top right.
1. Create or copy relevant solution files in the `ExerciseName` directory per the exercise instructions.
1. Once satisfied, click `Submit` in the top right. Automated grading can take some time in certain environments.
1. When auto grading is complete, you will see the score displayed under `Grades` and a test report displayed under `Grading Output`.

If testing with the included solution code, expect the `Automated Testing` value to be `n/n` where `n` is the `Max Score` you set when configuring the environment.  If values differ, check the `total_points` value in the `grade.sh` file and the `Max Score` value in the assignment configuration.

>WINDOWS USERS! You must remove the carriage return (`\r`) character from any script (`.sh`) files that you have downloaded or cloned to your machine. You can do this from the Vocareum terminal with `sed -i 's/\r$//' FILENAME` Failure to remove the carriage return will result in a `/voc/scripts/grade.sh: line 5: $'\r': command not found` error in the `Grading Output` window.

