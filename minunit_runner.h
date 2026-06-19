#ifndef MINUNIT_RUNNER_H
#define MINUNIT_RUNNER_H

#ifdef __cplusplus
extern "C" {
#endif

#include <stddef.h>

#define MU_TEST_ENTRY(fn) { #fn, fn }

/*
 * Test function type
 */
typedef void (*mu_test_fn)(void);

/*
 * A single test entry
 */
typedef struct {
    const char *name;
    mu_test_fn fn;
} mu_test_entry;

/*
 * Run modes (optional but useful for clarity/extensibility)
 */
typedef enum {
    MU_RUN_ALL,
    MU_RUN_LIST,
    MU_RUN_SINGLE
} mu_run_mode;

/*
 * Core runner APIs
 *
 * These functions operate on a static array of mu_test_entry.
 */

/* Run all tests */
void mu_run_all(mu_test_entry *tests, size_t count);

/* Print all test names */
void mu_run_list(mu_test_entry *tests, size_t count);

/* Run a single test by name.
 * Returns 1 if found and executed, 0 otherwise.
 */
int mu_run_named(mu_test_entry *tests, size_t count, const char *name);

/*
 * CLI entry helper:
 *
 * - argc/argv parsing
 * - supports:
 *      --list / -l
 *      <test_name>
 *      (no args => run all)
 */
int mu_run_from_argv(mu_test_entry *tests, size_t count,
                     int argc, char **argv);

/*
 * Convenience macro for defining the program entry point
 */
#define MU_TEST_MAIN(TEST_ARRAY) \
    int main(int argc, char **argv) { \
        return mu_run_from_argv( \
            (TEST_ARRAY), \
            sizeof(TEST_ARRAY) / sizeof((TEST_ARRAY)[0]), \
            argc, argv \
        ); \
    }

#ifdef __cplusplus
}
#endif

#endif /* MINUNIT_RUNNER_H */