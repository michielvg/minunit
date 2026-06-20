function(minunit_discover_tests target prefix)

    message(STATUS "=== MinUnit discovery for: ${target} ===")

    # 🔥 Get the directory where THIS file lives
    get_filename_component(MINUNIT_MODULE_DIR
        ${CMAKE_CURRENT_FUNCTION_LIST_FILE}
        DIRECTORY
    )

    set(script "${MINUNIT_MODULE_DIR}/minunit_discover_tests.cmake")

    if(NOT EXISTS "${script}")
        message(FATAL_ERROR "MinUnit script not found: ${script}")
    endif()

    set(out "${CMAKE_CURRENT_BINARY_DIR}/${target}_tests.cmake")

    # Normalize labels (ensure it's always a CMake list)
    message(STATUS "MinUnit target: ${target}")
    message(STATUS "MinUnit labels: ${MINUNIT_LABELS}")

    add_custom_command(
        OUTPUT ${out}
        COMMAND ${CMAKE_COMMAND}
            -DTEST_EXECUTABLE=$<TARGET_FILE:${target}>
            -DOUTPUT_FILE=${out}
            -DPREFIX=${prefix} 
            -P "${script}"
        DEPENDS ${target}
        VERBATIM
        COMMENT "Discovering MinUnit tests for ${target}"
    )

    add_custom_target(${target}_discover_tests ALL
        DEPENDS ${out}
    )

    add_dependencies(${target}_discover_tests ${target})

    set_property(DIRECTORY APPEND PROPERTY
        TEST_INCLUDE_FILES ${out}
    )

endfunction()