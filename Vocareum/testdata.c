#include "testdata.h"


const char* testSuite = "Checking for End of File Tests";

const UnitTestData testData[] = {
    { .name = "End of File Test",
      .input = "",
      .method = string,
      .expected = 
        "Ten Hippopotomus...\n"
        "Nine Hippopotomus...\n"
        "Eight Hippopotomus...\n"
        "Seven Hippopotomus...\n"
        "Six Hippopotomus...\n"
        "Five Hippopotomus...\n"
        "Four Hippopotomus...\n"
        "THREE TWO ONE!\n" },
};

const size_t testCount = sizeof(testData) / sizeof(UnitTestData);

