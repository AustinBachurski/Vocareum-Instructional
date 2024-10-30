#!/bin/bash

# This script will allow you to run the tests associated with this exercise
# without having to wait for Vocareum to automatically grade it.
#
# The script will copy your code to the `TestResults` directory, attempt to
# build, and if successful, run the tests against your code.
#
# PLEASE NOTE!  The script clears the contents of the `TestResults` directory
# each time it is ran - DO NOT put anything in there that you don't want to lose!
#
# Usage:
#   chmod +x run_tests.sh
#   ./run_tests.sh


# Clear old test results.
rm -rf ./TestResults

# Copy student code to TestResults directory.
cp -r CheckingForEndOfFile ./TestResults

# Compile student code.
cd TestResults
gcc -o cut checking_end_of_file.c  # cut -> Code Under Test
status=$?

# Student code compilation successful?
if [ "$status" == "0" ]; then
    echo "Student code compiled successfully"
    echo
else
    exit 1
fi

# Generate example.txt file to be read by student code.
echo "Ten Hippopotomus..." > example.txt
echo "Nine Hippopotomus..." >> example.txt
echo "Eight Hippopotomus..." >> example.txt
echo "Seven Hippopotomus..." >> example.txt
echo "Six Hippopotomus..." >> example.txt
echo "Five Hippopotomus..." >> example.txt
echo "Four Hippopotomus..." >> example.txt
echo "THREE TWO ONE!" >> example.txt

# Compile test binary.
cd ../CheckingForEndOfFileTests
gcc -O3 -o ../TestResults/test main.c testdata.c testrunner.c testparser.c
status=$?

# Test code compilation successful?
if [ "$status" == "0" ]; then
cd ../TestResults
else
echo "Test Build Error - The test binary failed to build."
exit 1
fi

# Run Tests
./test

