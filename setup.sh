#!/bin/bash

# Sets up Vocareum for an exercise, pass the name of the exercise as an arg.
# Usage:
#    sed -i 's/\r$//' setup.sh && chmod +x setup.sh && ./setup.sh <NAME OF EXERCISE>

# Generate /voc/scripts/grade.sh file.
echo "# \`total_points\` is the value inserted for this Grading Criterion in the rubric for this part." > /voc/scripts/grade.sh
echo "# \`grading_criterion_name\` must match the Grading Criterion for the exercise for grading to work." >> /voc/scripts/grade.sh
echo "total_points=100" >> /voc/scripts/grade.sh
echo "grading_criterion_name=\"Automated Testing\"" >> /voc/scripts/grade.sh
echo "" >> /voc/scripts/grade.sh
echo "" >> /voc/scripts/grade.sh
echo "echo VOC_NO_REPORT_OUTPUT > \$vocareumReportFile" >> /voc/scripts/grade.sh
echo "echo ================================================== >> \$vocareumReportFile" >> /voc/scripts/grade.sh
echo "echo \"Check Name: Build\" >> \$vocareumReportFile" >> /voc/scripts/grade.sh
echo "echo \"Check Description: Compile and link the project and check for errors/warnings\" >> \$vocareumReportFile" >> /voc/scripts/grade.sh
echo "echo \"Check Command: gcc -o cut ./$1/main.c\" >> \$vocareumReportFile" >> /voc/scripts/grade.sh
echo "echo \"PWD: \$(pwd)\" >> \$vocareumReportFile" >> /voc/scripts/grade.sh
echo "echo >> \$vocareumReportFile" >> /voc/scripts/grade.sh
echo "" >> /voc/scripts/grade.sh
echo "# Attempt to build student binary." >> /voc/scripts/grade.sh
echo "gcc -o cut ./$1/main.c &>> \$vocareumReportFile" >> /voc/scripts/grade.sh
echo "status=\$?" >> /voc/scripts/grade.sh
echo "" >> /voc/scripts/grade.sh
echo "if [ \"\$status\" == \"0\" ]; then" >> /voc/scripts/grade.sh
echo "    echo \"Check Status: Passed\" >> \$vocareumReportFile" >> /voc/scripts/grade.sh
echo "else" >> /voc/scripts/grade.sh
echo "    echo \"Check Status: Failed\" >> \$vocareumReportFile" >> /voc/scripts/grade.sh
echo "    echo \"\$grading_criterion_name,0\" >> \$vocareumGradeFile" >> /voc/scripts/grade.sh
echo "    exit 1" >> /voc/scripts/grade.sh
echo "fi" >> /voc/scripts/grade.sh
echo "" >> /voc/scripts/grade.sh
echo "echo ================================================== >> \$vocareumReportFile" >> /voc/scripts/grade.sh
echo "echo >> \$vocareumReportFile" >> /voc/scripts/grade.sh
echo "echo ================================================== >> \$vocareumReportFile" >> /voc/scripts/grade.sh
echo "echo \"Check Name: Test\" >> \$vocareumReportFile" >> /voc/scripts/grade.sh
echo "echo \"Check Description: Run the unit tests\" >> \$vocareumReportFile" >> /voc/scripts/grade.sh
echo "echo \"Check Command: ./test\" >> \$vocareumReportFile" >> /voc/scripts/grade.sh
echo "echo >> \$vocareumReportFile" >> /voc/scripts/grade.sh
echo "" >> /voc/scripts/grade.sh
echo "# Delete the current $1Tests folder and replace it with the one in /voc/startercode (students don't have write permission in that folder)." >> /voc/scripts/grade.sh
echo "# This will ensure that students have not edited the tests they will be graded on." >> /voc/scripts/grade.sh
echo "# NOTE: If you wanted to read something in the /voc/private folder, which students cannot even SEE, you can use the \$ASNLIB environment variable." >> /voc/scripts/grade.sh
echo "rm -rf ./$1Tests" >> /voc/scripts/grade.sh
echo "cp -r /voc/startercode/$1Tests ./$1Tests" >> /voc/scripts/grade.sh
echo "" >> /voc/scripts/grade.sh
echo "# Change test binary to direct all output to \"program.out\" for testing." >> /voc/scripts/grade.sh
echo "# This is a workaround for Vocareum, see comment in unittest.h for additonal details." >> /voc/scripts/grade.sh
echo "sed -i \"s/VOCAREUM_GRADING 0/VOCAREUM_GRADING 1/\" ./$1Tests/unittest.h" >> /voc/scripts/grade.sh
echo "" >> /voc/scripts/grade.sh
echo "# Build the test binary." >> /voc/scripts/grade.sh
echo "cd /voc/work/$1Tests" >> /voc/scripts/grade.sh
echo "gcc -O3 -o /voc/work/test main.c testdata.c testparser.c testrunner.c" >> /voc/scripts/grade.sh
echo "status=\$?" >> /voc/scripts/grade.sh
echo "" >> /voc/scripts/grade.sh
echo "# Return test code to printing to terminal." >> /voc/scripts/grade.sh
echo "sed -i \"s/VOCAREUM_GRADING 1/VOCAREUM_GRADING 0/\" ./$1Tests/unittest.h" >> /voc/scripts/grade.sh
echo "" >> /voc/scripts/grade.sh
echo "if [ \"\$status\" == \"0\" ]; then" >> /voc/scripts/grade.sh
echo "    cd /voc/work" >> /voc/scripts/grade.sh
echo "else" >> /voc/scripts/grade.sh
echo "    # Test binary failed to build, this should never happen." >> /voc/scripts/grade.sh
echo "    echo \"Test Build Error - The test binary failed to build.\" >> \$vocareumReportFile" >> /voc/scripts/grade.sh
echo "    echo \"\$grading_criterion_name,0\" >> \$vocareumGradeFile" >> /voc/scripts/grade.sh
echo "    exit 1" >> /voc/scripts/grade.sh
echo "fi" >> /voc/scripts/grade.sh
echo "" >> /voc/scripts/grade.sh
echo "# Run the tests." >> /voc/scripts/grade.sh
echo "./test" >> /voc/scripts/grade.sh
echo "status=\$?" >> /voc/scripts/grade.sh
echo "" >> /voc/scripts/grade.sh
echo "# Make sure test completed successfully." >> /voc/scripts/grade.sh
echo "if [ \"\$status\" != \"0\" ]; then" >> /voc/scripts/grade.sh
echo "    echo \"Testing Failed to Run\" >> \$vocareumReportFile" >> /voc/scripts/grade.sh
echo "fi" >> /voc/scripts/grade.sh
echo "" >> /voc/scripts/grade.sh
echo "cat program.out >> \$vocareumReportFile" >> /voc/scripts/grade.sh
echo "" >> /voc/scripts/grade.sh
echo "echo >> \$vocareumReportFile" >> /voc/scripts/grade.sh
echo "" >> /voc/scripts/grade.sh
echo "# Get the the total tests and passed tests values out of the output file." >> /voc/scripts/grade.sh
echo "total_tests=\$(grep -oP \"Found\s*(\d+)\s*Tests\" program.out | grep -oP \"\d+\")" >> /voc/scripts/grade.sh
echo "passed_tests=\$(grep -oP \"Passed:\s*(\d+),\" program.out | grep -oP \"\d+\")" >> /voc/scripts/grade.sh
echo "" >> /voc/scripts/grade.sh
echo "# Calculate the percentage of tests passed to two decimal places." >> /voc/scripts/grade.sh
echo "passed_tests_percentage=\$(python -c \"print(f\\\"{\$passed_tests / \$total_tests:.2f}\\\")\")" >> /voc/scripts/grade.sh
echo "percent_string=\$(python -c \"print(f\\\"{\$passed_tests_percentage * 100:.2f}\\\")\")" >> /voc/scripts/grade.sh
echo "echo \"Percent Of Tests Passed: \$percent_string%\" >> \$vocareumReportFile" >> /voc/scripts/grade.sh
echo "" >> /voc/scripts/grade.sh
echo "# Calculate the number of points to award based on the percentage of tests passed." >> /voc/scripts/grade.sh
echo "points_earned=\$(python -c \"print(f\\\"{\$total_points * \$passed_tests_percentage:.2f}\\\")\")" >> /voc/scripts/grade.sh
echo "echo \"Points Earned: \$points_earned / \$total_points\" >> \$vocareumReportFile" >> /voc/scripts/grade.sh
echo "" >> /voc/scripts/grade.sh
echo "# Set the grade for the rubric item." >> /voc/scripts/grade.sh
echo "echo \"\$grading_criterion_name,\$points_earned\" >> \$vocareumGradeFile" >> /voc/scripts/grade.sh

# Create directories for testing and student code.
mkdir /voc/startercode/TestResults
mkdir /voc/startercode/$1
mkdir /voc/startercode/$1Tests

# Generate /voc/startercode/run_tests.sh file.
echo "#!/bin/bash" > /voc/startercode/run_tests.sh
echo "" >> /voc/startercode/run_tests.sh
echo "# This script will allow you to run the tests associated with this exercise" >> /voc/startercode/run_tests.sh
echo "# without having to wait for Vocareum to automatically grade it." >> /voc/startercode/run_tests.sh
echo "#" >> /voc/startercode/run_tests.sh
echo "# The script will copy your code to the \`TestResults\` directory, attempt to" >> /voc/startercode/run_tests.sh
echo "# build, and if successful, run the tests against your code." >> /voc/startercode/run_tests.sh
echo "#" >> /voc/startercode/run_tests.sh
echo "# PLEASE NOTE!  The script clears the contents of the \`TestResults\` directory" >> /voc/startercode/run_tests.sh
echo "# each time it is ran - DO NOT put anything in there that you don't want to lose!" >> /voc/startercode/run_tests.sh
echo "#" >> /voc/startercode/run_tests.sh
echo "# Usage:" >> /voc/startercode/run_tests.sh
echo "#   chmod +x run_tests.sh" >> /voc/startercode/run_tests.sh
echo "#   ./run_tests.sh" >> /voc/startercode/run_tests.sh
echo "" >> /voc/startercode/run_tests.sh
echo "" >> /voc/startercode/run_tests.sh
echo "# Clear old test results." >> /voc/startercode/run_tests.sh
echo "rm -rf ./TestResults" >> /voc/startercode/run_tests.sh
echo "" >> /voc/startercode/run_tests.sh
echo "# Copy student code to TestResults directory." >> /voc/startercode/run_tests.sh
echo "cp -r $1 ./TestResults" >> /voc/startercode/run_tests.sh
echo "" >> /voc/startercode/run_tests.sh
echo "# Compile student code." >> /voc/startercode/run_tests.sh
echo "cd TestResults" >> /voc/startercode/run_tests.sh
echo "gcc -o cut main.c  # cut -> Code Under Test" >> /voc/startercode/run_tests.sh
echo "status=\$?" >> /voc/startercode/run_tests.sh
echo "" >> /voc/startercode/run_tests.sh
echo "# Student code compilation successful?" >> /voc/startercode/run_tests.sh
echo "if [ \"\$status\" == \"0\" ]; then" >> /voc/startercode/run_tests.sh
echo "    echo \"Student code compiled successfully\"" >> /voc/startercode/run_tests.sh
echo "    echo" >> /voc/startercode/run_tests.sh
echo "else" >> /voc/startercode/run_tests.sh
echo "    exit 1" >> /voc/startercode/run_tests.sh
echo "fi" >> /voc/startercode/run_tests.sh
echo "" >> /voc/startercode/run_tests.sh
echo "# Compile test binary." >> /voc/startercode/run_tests.sh
echo "cd ../$1Tests" >> /voc/startercode/run_tests.sh
echo "gcc -O3 -o ../TestResults/test main.c testdata.c testrunner.c testparser.c" >> /voc/startercode/run_tests.sh
echo "status=\$?" >> /voc/startercode/run_tests.sh
echo "" >> /voc/startercode/run_tests.sh
echo "# Test code compilation successful?" >> /voc/startercode/run_tests.sh
echo "if [ \"\$status\" == \"0\" ]; then" >> /voc/startercode/run_tests.sh
echo "cd ../TestResults" >> /voc/startercode/run_tests.sh
echo "else" >> /voc/startercode/run_tests.sh
echo "echo \"Test Build Error - The test binary failed to build.\"" >> /voc/startercode/run_tests.sh
echo "exit 1" >> /voc/startercode/run_tests.sh
echo "fi" >> /voc/startercode/run_tests.sh
echo "" >> /voc/startercode/run_tests.sh
echo "# Run Tests" >> /voc/startercode/run_tests.sh
echo "./test" >> /voc/startercode/run_tests.sh

# Make /voc/startercode/run_tests.sh executable.
chmod +x /voc/startercode/run_tests.sh

# Generate /voc/startercode/.vscode directory.
mkdir /voc/startercode/.vscode

# Generate /voc/startercode/.vscode/launch.json file.
echo "{" > /voc/startercode/.vscode/launch.json
echo "    \"version\": \"0.2.0\"," >> /voc/startercode/.vscode/launch.json
echo "    \"configurations\": [" >> /voc/startercode/.vscode/launch.json
echo "        {" >> /voc/startercode/.vscode/launch.json
echo "            \"type\": \"gdb\"," >> /voc/startercode/.vscode/launch.json
echo "            \"request\": \"launch\"," >> /voc/startercode/.vscode/launch.json
echo "            \"name\": \"Launch Program\"," >> /voc/startercode/.vscode/launch.json
echo "            \"target\": \"\${fileDirname}/\${fileBasenameNoExtension}\"," >> /voc/startercode/.vscode/launch.json
echo "            \"cwd\": \"\${workspaceRoot}\"," >> /voc/startercode/.vscode/launch.json
echo "            \"valuesFormatting\": \"parseText\"," >> /voc/startercode/.vscode/launch.json
echo "            \"preLaunchTask\": \"build\"," >> /voc/startercode/.vscode/launch.json
echo "            \"internalConsoleOptions\": \"openOnSessionStart\"" >> /voc/startercode/.vscode/launch.json
echo "        }" >> /voc/startercode/.vscode/launch.json
echo "    ]" >> /voc/startercode/.vscode/launch.json
echo "}" >> /voc/startercode/.vscode/launch.json

# Generate /voc/startercode/.vscode/tasks.json file.
echo "{" > /voc/startercode/.vscode/tasks.json
echo "    \"version\": \"2.0.0\"," >> /voc/startercode/.vscode/tasks.json
echo "    \"tasks\": [" >> /voc/startercode/.vscode/tasks.json
echo "        {" >> /voc/startercode/.vscode/tasks.json
echo "            \"label\": \"build\"," >> /voc/startercode/.vscode/tasks.json
echo "            \"type\": \"shell\"," >> /voc/startercode/.vscode/tasks.json
echo "            \"command\": \"gcc\"," >> /voc/startercode/.vscode/tasks.json
echo "            \"args\": [" >> /voc/startercode/.vscode/tasks.json
echo "                \"-g\"," >> /voc/startercode/.vscode/tasks.json
echo "                \"-o\"," >> /voc/startercode/.vscode/tasks.json
echo "                \"\${fileDirname}/\${fileBasenameNoExtension}\"," >> /voc/startercode/.vscode/tasks.json
echo "                \"\${file}\"" >> /voc/startercode/.vscode/tasks.json
echo "            ]," >> /voc/startercode/.vscode/tasks.json
echo "            \"group\": {" >> /voc/startercode/.vscode/tasks.json
echo "                \"kind\": \"build\"," >> /voc/startercode/.vscode/tasks.json
echo "                \"isDefault\": true" >> /voc/startercode/.vscode/tasks.json
echo "            }," >> /voc/startercode/.vscode/tasks.json
echo "            \"detail\": \"Generated task by VS Code\"" >> /voc/startercode/.vscode/tasks.json
echo "        }" >> /voc/startercode/.vscode/tasks.json
echo "    ]" >> /voc/startercode/.vscode/tasks.json
echo "}" >> /voc/startercode/.vscode/tasks.json

# Cleanup
rm /voc/private/setup.sh

