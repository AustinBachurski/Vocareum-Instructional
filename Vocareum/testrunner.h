#ifndef PP1_TESTS_TESTRUNNER
#define PP1_TESTS_TESTRUNNER

// This code is valid only where the dup, and dup2 syscalls are available.
// These calls are not available on Microsoft Windows.

#include "unittest.h"

#include <stdbool.h>
#include <stdlib.h>
#include <unistd.h>


bool initializeSuccess(void);
bool loadTestData(size_t test);
TestResult runTest(size_t test);
void runTests(TestSuiteResults*);
void displayResults(TestSuiteResults* results);
void cleanup(void);

#endif

