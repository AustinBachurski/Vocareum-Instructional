#ifndef PP1_TESTS_PARSER
#define PP1_TESTS_PARSER

#include "unittest.h"

#include <stdlib.h>
#include <stdio.h>
#include <string.h>


#define ACTUAL "./console.out"
#define EXPECTED "./expected.out"
#define INPUT "./console.in"
#define CODE_UNDER_TEST "./cut"

TestResult parseUsingString(TestResult outcome, TestSuiteResults* results);
TestResult parseUsingRegex(TestResult outcome, TestSuiteResults* results);
void prettyPrint(char* expected, char* actual, size_t i, size_t line);
void stripNewLine(char* string);

#endif

