#include "testrunner.h"
#include "unittest.h"

#include <stdio.h>

 
FILE* programOutput;

int main(void)
{
    if (!initializeSuccess())
    {
        return 1;
    }

    TestSuiteResults results =
        {   .testsRan = 0,
            .testsPassed = 0,
            .testsFailed = 0 };

    runTests(&results);
    displayResults(&results);
    cleanup();

    return 0;
}

