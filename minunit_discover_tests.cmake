execute_process(
    COMMAND ${TEST_EXECUTABLE} --list
    OUTPUT_VARIABLE TEST_LIST
    RESULT_VARIABLE TEST_RESULT
    OUTPUT_STRIP_TRAILING_WHITESPACE
)

if(NOT TEST_RESULT EQUAL 0)
    message(FATAL_ERROR
        "Failed to enumerate tests from ${TEST_EXECUTABLE}")
endif()

file(WRITE "${OUTPUT_FILE}" "")

string(REPLACE "\n" ";" TEST_NAMES "${TEST_LIST}")

foreach(TEST_NAME IN LISTS TEST_NAMES)

    file(APPEND "${OUTPUT_FILE}"
"add_test(
    NAME \"${TEST_NAME}\"
    COMMAND \"${TEST_EXECUTABLE}\" \"${TEST_NAME}\"
)
")

endforeach()