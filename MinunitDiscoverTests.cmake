function(minunit_discover_tests target)

    set(options)
    set(oneValueArgs WORKING_DIRECTORY)
    set(multiValueArgs)
    cmake_parse_arguments(MU "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    if(NOT MU_WORKING_DIRECTORY)
        set(MU_WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})
    endif()

    set(ctest_include_file
        "${CMAKE_CURRENT_BINARY_DIR}/${target}_tests.cmake")

    add_custom_command(
        TARGET ${target}
        POST_BUILD

        COMMAND
            ${CMAKE_COMMAND}
            -DTEST_EXECUTABLE=$<TARGET_FILE:${target}>
            -DOUTPUT_FILE=${ctest_include_file}
            -P ${CMAKE_CURRENT_LIST_DIR}/minunit_discover_tests.cmake

        BYPRODUCTS ${ctest_include_file}
        VERBATIM
    )

    set_property(
        DIRECTORY
        APPEND
        PROPERTY TEST_INCLUDE_FILES
        ${ctest_include_file}
    )

endfunction()