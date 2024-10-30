#include "testdata.h"
#include "testparser.h"
#include "testrunner.h"
#include "unittest.h"

#include <stdbool.h>


extern FILE* programOutput;

void cleanup(void)
{
    fclose(programOutput);
}

void displayResults(TestSuiteResults* results)
{
    bool passed = results->testsRan == results->testsPassed;

    PRINT"%s results:\n", testSuite);
    PRINT" %s - Tests Ran: %d, ", passed ? PASSED : FAILED, results->testsRan);
    PRINT"Tests Passed: %d, ", results->testsPassed);
    PRINT"Tests Failed: %d\n", results->testsFailed);
}

bool initializeSuccess(void)
{
    programOutput = fopen(PROGRAM_OUTPUT, "w");
    if (!programOutput)
    {
        perror("Failed to open program output file");
        return false;
    }
    return true;
}

bool loadTestData(size_t test)
{
    FILE* inputFile = fopen(INPUT, "w");
    if (!inputFile)
    {
        PRINT"Failed to open test file\n");
        return false;
    }
    fputs(testData[test].input, inputFile);
    fclose(inputFile);

    FILE* expectedFile = fopen(EXPECTED, "w");
    if (!expectedFile)
    {
        PRINT"Failed to open test file\n");
        return false;
    }
    fputs(testData[test].expected, expectedFile);
    fclose(expectedFile);

    return true;
}

TestResult runTest(size_t test)
{
    if (!loadTestData(test))
    {
        return fileError;
    }

    // Redirect stdin to a file.
    FILE* inputFile = freopen(INPUT, "r", stdin);
    if (!inputFile)
    {
        PRINT"\tFailed to open input file\n");
        return fileError;
    }

    // Store current position and descriptor of stdout.
    fflush(stdout);
    fpos_t position;
    fgetpos(stdout, &position);
    int fileDescriptor = dup(fileno(stdout));

    // Reassign stdout to a file.
    FILE* outputFile = freopen(ACTUAL, "w", stdout);
    if (!outputFile)
    {
        PRINT"\tFailed to open output file\n");
        return fileError;
    }
    
    // Call test program.
    if (system(CODE_UNDER_TEST))
    {
        PRINT"\tCode under test produced an error.");
    }

    // Check that input was consumed.
    int inputRemaining = fgetc(stdin);
    
    // Restore stdin.
    if (!freopen("/dev/tty", "r", stdin))
    {
        PRINT"\tFailed to restore stdin\n");
        return redirectionError;
    }
    
    // Restore stdout.
    fflush(stdout);
    dup2(fileDescriptor, fileno(stdout));
    close(fileDescriptor);
    if(!freopen("/dev/tty", "w", stdout))
    {
        PRINT"\tFailed to restore stdout\n");
        return redirectionError; 
    }
    clearerr(stdout);
    fsetpos(stdout, &position);
    fclose(outputFile);
    outputFile = NULL;
    if (!freopen("/dev/tty", "w", stdout))
    {
        PRINT"\tFailed to restore stdout\n");
        return redirectionError;
    }

    return inputRemaining == -1 ? inputConsumed : notConsumed;
}

void runTests(TestSuiteResults* results)
{
    PRINT"Test Suite: %s\n", testSuite);
    PRINT"  ***Found %zu Tests***\n\n", testCount);

    for (size_t test = 0; test < testCount; ++test)
    {
        PRINT"Running Test: %s...\n", testData[test].name);
        ++results->testsRan;

        TestResult outcome = runTest(test);
        
        if (outcome == fileError || outcome == redirectionError)
        {
            PRINT"**TEST ERROR**\n\n");
            return;
        }

        TestResult testResult = null;

        if (testData[test].method == string)
        {
            testResult = parseUsingString(outcome, results);
        }
        else
        {
            testResult = parseUsingRegex(outcome, results);
        }

        if (testResult == fail)
        {
            PRINT"  %s\n\n", FAILED);
        }
        else if (testResult == pass)
        {
            PRINT"  %s\n\n", PASSED);
        }
        else
        {
            PRINT"**TEST ERROR**\n\n");
        }
    }
}

