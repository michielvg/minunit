# ------------------------------------------------------------
# MinUnit test discovery script (runs at build time)
# ------------------------------------------------------------

if(NOT DEFINED TEST_EXECUTABLE)
    message(FATAL_ERROR "TEST_EXECUTABLE not defined")
endif()

if(NOT DEFINED OUTPUT_FILE)
    message(FATAL_ERROR "OUTPUT_FILE not defined")
endif()

if(NOT DEFINED PREFIX)
    message(FATAL_ERROR "PREFIX not defined")
endif()

message(STATUS "Running MinUnit discovery:")
message(STATUS "  Executable: ${TEST_EXECUTABLE}")

# ------------------------------------------------------------------
# Run test binary to list tests
# ------------------------------------------------------------------
execute_process(
    COMMAND "${TEST_EXECUTABLE}" --list
    OUTPUT_VARIABLE TEST_LIST
    RESULT_VARIABLE TEST_RESULT
    OUTPUT_STRIP_TRAILING_WHITESPACE
)

if(NOT TEST_RESULT EQUAL 0)
    message(FATAL_ERROR "Failed to enumerate tests from ${TEST_EXECUTABLE}")
endif()

# Convert newline-separated list into CMake list
string(REPLACE "\n" ";" TEST_NAMES "${TEST_LIST}")

# ------------------------------------------------------------------
# Write CTest include file
# ------------------------------------------------------------------
file(WRITE "${OUTPUT_FILE}" "# Auto-generated MinUnit test list\n\n")

foreach(TEST_NAME IN LISTS TEST_NAMES)

    if(TEST_NAME STREQUAL "")
        continue()
    endif()

    set(FULL_NAME "${PREFIX}.${TEST_NAME}")

    file(APPEND "${OUTPUT_FILE}"
        "add_test(${FULL_NAME} ${TEST_EXECUTABLE} ${TEST_NAME})\n"
        "set_tests_properties(${FULL_NAME} PROPERTIES LABELS \"${LABELS}\")\n\n"
    )


endforeach()

message(STATUS "Generated ${OUTPUT_FILE} with ${TEST_NAMES_LENGTH} tests")