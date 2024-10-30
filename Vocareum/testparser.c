#include "testparser.h"
#include "unittest.h"

#include <regex.h>


TestResult parseUsingRegex(TestResult outcome, TestSuiteResults* results)
{
    FILE* expectedFile = fopen(EXPECTED, "r");
    FILE* actualFile = fopen(ACTUAL, "r");

    if (!expectedFile)
    {
        PRINT"Failed to open expected file\n");
        return fileError;
    }
    if (!actualFile)
    {
        PRINT"Failed to open actual file\n");
        return fileError;
    }

    char* actual = NULL;
    size_t actualSize = 0;
    char* expected = NULL;
    size_t expectedSize = 0;
    ssize_t actualLen = getline(&actual, &actualSize, actualFile);
    ssize_t expectedLen = getline(&expected, &expectedSize, expectedFile);

    size_t line = 1;
    regex_t regex;
    int result;

    while (actualLen != -1 && expectedLen != -1)
    {
        result = regcomp(&regex, expected, REG_EXTENDED | REG_NOSUB);
        if (result)
        {
            PRINT"Regular expression error\n");
            return regexError;
        }

        result = regexec(&regex, actual, 0, NULL, 0);

        if (!result) // Regex Matches
        {
            ++line;
            actualLen = getline(&actual, &actualSize, actualFile);
            expectedLen = getline(&expected, &expectedSize, expectedFile);
            regfree(&regex);
            continue;
        }
        else if (result == REG_NOMATCH)
        {
            PRINT"\n  **Match Failure**: Line %zu\n\n", line);
            PRINT"\tRegex Pattern: %s\n", expected);
            PRINT"\tActual:        %s\n", actual);

            regfree(&regex);
            fclose(expectedFile);
            fclose(actualFile);
            free(expected);
            free(actual);

            ++results->testsFailed;
            return fail;
        }
        else
        {
            char msgbuf[255];
            regerror(result, &regex, msgbuf, sizeof(msgbuf));
            PRINT"Error encountered when matching regex: %s\n", msgbuf);

            regfree(&regex);
            fclose(expectedFile);
            fclose(actualFile);
            free(expected);
            free(actual);

            return regexError;
        }
    }

    regfree(&regex);
    fclose(expectedFile);
    fclose(actualFile);
    free(expected);
    free(actual);

    if (outcome == notConsumed)
    {
        PRINT"\n  **Assert Failure**: Input remains in input buffer\n\n"
               "\tProgram output matches expected; however,\n"
               "\tconsole input was not consumed by the program.\n"
               "\tYour program must read input from the user for tests to pass.\n"
               "\tSee the '.input' line(s) of the 'testdata.c' file in the\n"
               "\ttesting directory for the inputs provided to the program.\n");

        ++results->testsFailed;
        return fail;
    }

    ++results->testsPassed;
    return pass;
}

TestResult parseUsingString(TestResult outcome, TestSuiteResults* results)
{
    FILE* expectedFile = fopen(EXPECTED, "r");
    FILE* actualFile = fopen(ACTUAL, "r");

    if (!expectedFile)
    {
        PRINT"Failed to open expected file\n");
        return fileError;
    }
    if (!actualFile)
    {
        PRINT"Failed to open actual file\n");
        return fileError;
    }

    char* actual = NULL;
    size_t actualSize = 0;
    char* expected = NULL;
    size_t expectedSize = 0;
    ssize_t actualLen = getline(&actual, &actualSize, actualFile);
    ssize_t expectedLen = getline(&expected, &expectedSize, expectedFile);

    size_t line = 1;
    while (actualLen != -1 || expectedLen != -1)
    {
        int notEqual = strcmp(expected, actual);

        if (notEqual)
        {
            if (expectedLen == -1)
            {
                expected[0] = 0;
                expectedLen = 0;
            }

            if (actualLen == -1)
            {
                actual[0] = 0;
                actualLen = 0;
            }

            size_t i = 0;
            size_t end = (size_t)(expectedLen <= actualLen ? expectedLen : actualLen);

            for (; i < end; ++i)
            {
                if (expected[i] != actual[i])
                {
                    break;
                }
            }
            prettyPrint(expected, actual, i, line);

            fclose(expectedFile);
            fclose(actualFile);
            free(expected);
            free(actual);

            ++results->testsFailed;
            return fail;
        }

        ++line;
        actualLen = getline(&actual, &actualSize, actualFile);
        expectedLen = getline(&expected, &expectedSize, expectedFile);
    }

    fclose(expectedFile);
    fclose(actualFile);
    free(expected);
    free(actual);

    if (outcome == notConsumed)
    {
        PRINT"\n  **Assert Failure**: Input remains in input buffer\n\n"
               "\tProgram output matches expected; however,\n"
               "\tconsole input was not consumed by the program.\n"
               "\tYour program must read input from the user for tests to pass.\n"
               "\tSee the '.input' line(s) of the 'testdata.c' file in the\n"
               "\ttesting directory for the inputs provided to the program.\n");

        ++results->testsFailed;
        return fail;
    }

    ++results->testsPassed;
    return pass;
}

void prettyPrint(char* expected, char* actual, size_t position, size_t line)
{
    PRINT"\n  **Assert Failure**: Strings differ - Line %zu\n\n", line);
    stripNewLine(expected);
    stripNewLine(actual);

    PRINT"\t          %*s| (pos %zu)\n", (int)position, "", position);
    PRINT"\tExpected: %s\n", expected);
    PRINT"\tActual:   %s\n", actual);
    PRINT"\t          %*s| (pos %zu)\n", (int)position, "", position);
    
    if (position  == strlen(expected))
    {
        PRINT"\tExpected a newline character.\n");
    }
}

void stripNewLine(char* string)
{
    char* pos = strstr(string, "\n");
    if (pos)
    {
        *pos = '\0';
    }
}

