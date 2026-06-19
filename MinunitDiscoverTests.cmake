function(minunit_discover_tests target)

    message(STATUS "=== MINUNIT DISCOVERY (FUNC) RUNNING ===")

    set(script "${MINUNIT_DISCOVER_TESTS_DIR}/minunit_discover_tests.cmake")
    set(out "${CMAKE_CURRENT_BINARY_DIR}/${target}_tests.cmake")
    set(test_exec "${CMAKE_CURRENT_BINARY_DIR}/${target}")

    file(WRITE "${out}" "# generated\n")

    execute_process(
        COMMAND ${test_exec} --list
        OUTPUT_VARIABLE TEST_LIST
        RESULT_VARIABLE TEST_RESULT
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )

    message(STATUS "${TEST_LIST}")

    if(NOT TEST_RESULT EQUAL 0)
        message(FATAL_ERROR
            "Failed to enumerate tests from ${target}")
    endif()

    file(WRITE "${out}" "")

    string(REPLACE "\n" ";" TEST_NAMES "${TEST_LIST}")

    foreach(TEST_NAME IN LISTS TEST_NAMES)

        file(APPEND "${out}"
    "add_test(
        \"${TEST_NAME}\"
        \"${test_exec}\" \"${TEST_NAME}\"
    )
    ")

    endforeach()

    add_custom_target(${target}_discover_tests
        COMMAND ${CMAKE_COMMAND}
            -DTEST_EXECUTABLE=$<TARGET_FILE:${target}>
            -DOUTPUT_FILE=${out}
            -P ${script}
    )

    add_dependencies(${target}_discover_tests ${target})

    set_property(DIRECTORY APPEND PROPERTY TEST_INCLUDE_FILES ${out})

endfunction()