#include "minunit_runner.h"

#include <stdio.h>
#include <string.h>

/* ------------------------------------------------------------
 * Run all tests
 * ------------------------------------------------------------ */
void mu_run_all(mu_test_entry *tests, size_t count) {
    for (size_t i = 0; i < count; i++) {
        tests[i].fn();
    }
}

/* ------------------------------------------------------------
 * List all test names
 * ------------------------------------------------------------ */
void mu_run_list(mu_test_entry *tests, size_t count) {
    for (size_t i = 0; i < count; i++) {
        if (tests[i].name) {
            printf("%s\n", tests[i].name);
        }
    }
}

/* ------------------------------------------------------------
 * Run a single test by name
 * ------------------------------------------------------------ */
int mu_run_named(mu_test_entry *tests, size_t count, const char *name) {
    if (!name) return 0;

    for (size_t i = 0; i < count; i++) {
        if (tests[i].name && strcmp(tests[i].name, name) == 0) {
            tests[i].fn();
            return 1;
        }
    }

    fprintf(stderr, "minunit_runner: test not found: %s\n", name);
    return 0;
}

/* ------------------------------------------------------------
 * CLI dispatcher
 * ------------------------------------------------------------ */
int mu_run_from_argv(mu_test_entry *tests, size_t count,
                     int argc, char **argv) {

    /* No args → run all tests */
    if (argc <= 1) {
        mu_run_all(tests, count);
        return 0;
    }

    /* --list / -l → print test names */
    if (argc == 2 &&
        (strcmp(argv[1], "--list") == 0 || strcmp(argv[1], "-l") == 0)) {
        mu_run_list(tests, count);
        return 0;
    }

    /* Otherwise treat first arg as test name */
    if (argc == 2) {
        return mu_run_named(tests, count, argv[1]) ? 0 : 1;
    }

    /* Too many args → simple usage error */
    fprintf(stderr,
        "Usage:\n"
        "  %s            Run all tests\n"
        "  %s --list     List tests\n"
        "  %s <test>     Run single test\n",
        argv[0], argv[0], argv[0]);

    return 2;
}