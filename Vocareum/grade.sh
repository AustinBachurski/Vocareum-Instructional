# `total_points` is the value inserted for this Grading Criterion in the rubric for this part.
# `grading_criterion_name` must match the Grading Criterion for the exercise for grading to work.
total_points=100
grading_criterion_name="Automated Testing"


echo VOC_NO_REPORT_OUTPUT > $vocareumReportFile
echo ================================================== >> $vocareumReportFile
echo "Check Name: Build" >> $vocareumReportFile
echo "Check Description: Compile and link the project and check for errors/warnings" >> $vocareumReportFile
echo "Check Command: gcc -o cut ./CheckingForEndOfFile/checking_end_of_file.c" >> $vocareumReportFile
echo "PWD: $(pwd)" >> $vocareumReportFile
echo >> $vocareumReportFile

# Generate example.txt file to be read by student code.
echo "Ten Hippopotomus..." > example.txt
echo "Nine Hippopotomus..." >> example.txt
echo "Eight Hippopotomus..." >> example.txt
echo "Seven Hippopotomus..." >> example.txt
echo "Six Hippopotomus..." >> example.txt
echo "Five Hippopotomus..." >> example.txt
echo "Four Hippopotomus..." >> example.txt
echo "THREE TWO ONE!" >> example.txt

# Attempt to build student binary.
gcc -o cut ./CheckingForEndOfFile/checking_end_of_file.c &>> $vocareumReportFile
status=$?

if [ "$status" == "0" ]; then
    echo "Check Status: Passed" >> $vocareumReportFile
else
    echo "Check Status: Failed" >> $vocareumReportFile
    echo "$grading_criterion_name,0" >> $vocareumGradeFile
    exit 1
fi

echo ================================================== >> $vocareumReportFile
echo >> $vocareumReportFile
echo ================================================== >> $vocareumReportFile
echo "Check Name: Test" >> $vocareumReportFile
echo "Check Description: Run the unit tests" >> $vocareumReportFile
echo "Check Command: ./test" >> $vocareumReportFile
echo >> $vocareumReportFile

# Delete the current CheckingForEndOfFileTests folder and replace it with the one in /voc/startercode (students don't have write permission in that folder).
# This will ensure that students have not edited the tests they will be graded on.
# NOTE: If you wanted to read something in the /voc/private folder, which students cannot even SEE, you can use the $ASNLIB environment variable.
rm -rf ./CheckingForEndOfFileTests
cp -r /voc/startercode/CheckingForEndOfFileTests ./CheckingForEndOfFileTests

# Change test binary to direct all output to "program.out" for testing.
# This is a workaround for Vocareum, see comment in unittest.h for additonal details.
sed -i "s/VOCAREUM_GRADING 0/VOCAREUM_GRADING 1/" ./CheckingForEndOfFileTests/unittest.h

# Build the test binary.
cd /voc/work/CheckingForEndOfFileTests
gcc -O3 -o /voc/work/test main.c testdata.c testparser.c testrunner.c
status=$?

# Return test code to printing to terminal.
sed -i "s/VOCAREUM_GRADING 1/VOCAREUM_GRADING 0/" ./CheckingForEndOfFileTests/unittest.h

if [ "$status" == "0" ]; then
    cd /voc/work
else
    # Test binary failed to build, this should never happen.
    echo "Test Build Error - The test binary failed to build." >> $vocareumReportFile
    echo "$grading_criterion_name,0" >> $vocareumGradeFile
    exit 1
fi

# Run the tests.
./test
status=$?

# Make sure test completed successfully.
if [ "$status" != "0" ]; then
    echo "Testing Failed to Run" >> $vocareumReportFile
fi

cat program.out >> $vocareumReportFile

echo >> $vocareumReportFile

# Get the the total tests and passed tests values out of the output file.
total_tests=$(grep -oP "Found\s*(\d+)\s*Tests" program.out | grep -oP "\d+")
passed_tests=$(grep -oP "Passed:\s*(\d+)," program.out | grep -oP "\d+")

# Calculate the percentage of tests passed to two decimal places.
passed_tests_percentage=$(python -c "print(f\"{$passed_tests / $total_tests:.2f}\")")
percent_string=$(python -c "print(f\"{$passed_tests_percentage * 100:.2f}\")")
echo "Percent Of Tests Passed: $percent_string%" >> $vocareumReportFile

# Calculate the number of points to award based on the percentage of tests passed.
points_earned=$(python -c "print(f\"{$total_points * $passed_tests_percentage:.2f}\")")
echo "Points Earned: $points_earned / $total_points" >> $vocareumReportFile

# Set the grade for the rubric item.
echo "$grading_criterion_name,$points_earned" >> $vocareumGradeFile
