#ifndef PP1_TESTS_UNIT_TEST_DATA
#define PP1_TESTS_UNIT_TEST_DATA

#include <stdio.h>


extern FILE* programOutput;

/*
 * Redirect of stdin/stdout required for testing printf() in student code
 * works in the terminal but not when called by the grade script.  When running
 * in the grade script VOCAREUM_GRADING is set to 1 by the grade script to
 * direct program output to a file that can be evaluated by the grading system.
 * When testing program in the terminal VOCAREUM_GRADING is set to 0 (default)
 * and program output is printed to stdout as expected.
 *
 * Use PRINT in place of printf( when modifying existing code.
 */

#define VOCAREUM_GRADING 0
#if VOCAREUM_GRADING
    #define PRINT fprintf(programOutput,
#else
    #define PRINT printf(
#endif

#define PROGRAM_OUTPUT "program.out"
#define PASSED "[PASSED]"
#define FAILED "[FAILED]"

typedef enum
{
    null,
    pass,
    fail,
    inputConsumed,
    notConsumed,
    fileError,
    redirectionError,
    regexError,
} TestResult;

typedef enum
{
    string,
    regex,
} TestMethod;

typedef struct{
     unsigned int testsRan;
     unsigned int testsPassed;
     unsigned int testsFailed;
} TestSuiteResults;

typedef struct
{
    const char* name;
    const char* input;
    const TestMethod method;
    const char* expected;
} UnitTestData;

#endif

