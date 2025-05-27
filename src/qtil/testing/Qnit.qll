/**
 * Qnit - A simple testing framework for language-agnostic QL libraries.
 *
 * Qnit is intended to be used when testing QL libraries that do not depend on analyzed test code,
 * and provides a simple way to define and run test cases.
 *
 * To use Qnit, import this library and create a set of classes that extends `Test, Case` and
 * implement the predicate `run(Qnit test)` like so:
 *
 * ```ql
 * import qtil.testing.Qnit
 *
 * class MyTest extends Test, Case {
 *   override predicate run(Qnit test) {
 *     if (someCondition)
 *     then test.pass("some condition passed")
 *     else test.fail("some condition failed")
 *   }
 * }
 * ```
 *
 * You can define multiple test classes. Due to the way QL works, you can only have one
 * `run(Qnit test)` predicate per class, and for best results, each `pass()` and `fail()` call
 * should have a unique string. Differing `pass()` strings will properly count the number of tests
 * that passed, and differing `fail()` strings are required to identify which specific tests failed.
 *
 * Be careful in deviating from this pattern, but do so at your own risk, so long as `pass()` and
 * `fail()` hold as in the example above.
 */
import qtil.testing.impl.Qnit
import qtil.testing.impl.Test
import qtil.testing.impl.Runner
