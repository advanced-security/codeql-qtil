# Qnit (unit testing for CodeQL)

Qnit is a unit testing library for CodeQL that is made to compliment the standard `codeql test run` command, especially for testing language agnostic CodeQL libraries.

## Quick start

The most basic Qnit test looks like so:

```ql
// MyTest.ql
import qtil.testing.Qnit

class MyTest extends Test, Case {
  override predicate run(Qnit test) {
    if somethingYouWantToTest()
    then test.pass("My thing works")
    else test.fail("Looks like my thing doesn't work.")
  }
}
```

and can either be run with `codeql query run ...`, or, if the file `MyTest.expectations` exists, can be run with `codeql test run MyTest.ql` (preferred).

In the above case, if the predicate `somethingYouWantToTest()` holds, then Qnit will output "One test passed." If that predicate does not hold, then it will output "FAILURE: Looks like my thing doesn't work." The actual test method can have perform any logic you wish.

You can define as many test classes as you want. Each test should either pass or fail with a **unique** string.

## Trap cases and considerations

Be careful of the following cases, which emerge from the way CodeQL evaluates your tests.

### A test can pass and fail.

There's nothing stopping you from writing a test like this:

```ql
class MyTest extends Test, Case {
    override predicate run(Qnit test) {
        // Test will pass AND fail.
        test.pass("pass")
        or
        test.fail("fail")
    }
}
```

This is sometimes desirable, see tips and tricks.

### A test can have no result.

```ql
class MyTest extends Test, Case {
    override predicate run(Qnit test) {
        // A test cannot pass and fail at once, so the test has no result.
        test.pass("pass")
        and
        test.fail("fail")
        or
        // This will also neither pass nor fail.
        none() and test.pass("pass")
    }
}
```

The above is almost always a bug in your test. Be careful in how you formulate your test members so that this does not happen.

Consider the scenario of computing a string in the `fail()` message in order to debug a test failure. You may accidentally cause the test to no longer fail.

```
string getName() { none() }

class MyTest extends Test, Case {
    if getName() = "Jim"
    then test.pass("Name is Jim")
    else test.fail("Name is not Jim, but " + getName())
}
```

In the above case, the `getName()` method is not holding when it should have a result of `"Jim"`. Because `getName()` does not hold, the test will not pass. Unfortunately, when `getName()` is used in the failure message like this, that can cause the failing branch to also be skipped, and then the test has no result.

### Equality in CodeQL isn't always what you want to test

In CodeQL, `a = b` and `a != b` does not behave like other imperative languages. The terms `a` and `b` may have multiple results, causing tests to pass or fail in undesirable ways.

```
string getChildName() {
    result = ["Jim", "James"]
}

class MyTest extends Test, Case {
    override predicate run(Qnit test) {
        if getChildName() = "Jim" or
        getChildName() != "Jim"
        then test.pass("...")
        else test.fail("...")
    }
}
```

Will the above test fail, or pass, or both, or neither? The correct answer is that it will pass. In CodeQL, `[0, 1] = [1, 2]` holds and `[0, 1] != [1, 2]` also holds. In a unit testing scenario, this generally isn't desirable.

Future versions of Qnit may provide an "Expects" framework to make it simpler to write tests that are resilient to this behavior.

## Tips and tricks

When testing a set of values, put the `test.pass` and `test.fail` calls inside of a `forall` loop. If the pass message is a constant, it will only be selected once. If the test
fails, the failure message can include the exact value that caused the failure.

```ql
class MyTest extends Test, Case {
    override predicate run(Qnit test) {
        // Rather than writing a test like this:
        if forall(int i | i in [1..10] | if i = 5)
        then test.pass("i is 5")
        else test.fail("i is not 5")

        // You can instead write a test like this:
        exists(int i | i in [1..10] |
            if i = 5
            then test.pass("i is 5")
            // See which value of i caused the failure.
            else test.fail("i is not 5, it is " + i)
        )
    }
}
```

As always, be careful of the traps mentioned above. If the `test.fail` message evaluates to `none()`, the test will not fail. If the `exists` evaluates to nothing, then the test will not fail either.

Additionally, since predicates can return multiple results, you can use this to write multiple tests in a single `run()` method, if you prefer. For example, if you want to test that a predicate holds for multiple values, you can write:

```ql
// Optional style of testing a unit with one class
class MyTest extends Test, Case {
    override predicate run(Qnit test) {
        if 2 = 2
        then test.pass("2 = 2")
        else test.fail("some how 2 = 2 does not hold")
        or
        if testSomethingElse()
        then test.pass("testSomethingElse() passes")
        else test.fail("testSomethingElse() failed")
        or
        ...
    }
}
```

## Design notes

The design of Qnit revolved around managing a number of CodeQL features which are useful in the context of predicate logic and queries, but make designing a unit testing framework difficult. It also intends to take advantage of useful CodeQL features.

Consider how Qnit compares to standard unit testing frameworks from other object oriented languages such as JUnit. Can such APIs be directly ported to CodeQL?

```
class MyTest {
    @Test
    void run() {
        expect(MyThing().member(), "value")
    }
}
```

In JUnit, this class can be discovered via reflection, and run inside of a catch block. Exceptions can be reported with convenient strings such as, "MyTest.run() failed: Expected value but got ..."

In CodeQL, a class must extend an existing type. Since tests don't represent data, a convenient base class is `codeql.util.Unit`.

```
abstract class TestBase extends Unit {
    abstract predicate run();

class MyTest extends TestBase {
    override predicate run() { ... }
}
```

We don't need reflection to discover this new behavior in CodeQL. Merely selecting `TestBase` and calling `.run()` is enough execute every test. Unfortunately, getting the name of the class doesn't work the way we need it to.

```
from TestBase test
select test.getAQlClass(), test.run()
```

If we have two test classes, `TestA` and `TestB`, and the `run()` members return two values, `pass` in one class and `fail` in the other, then this query in CodeQL will select the product of these values: `(TestA, pass), (TestA, fail), (TestB, pass), (TestB, fail)`, which unfortunately means we cannot use the class name as a test name.

This product behavior is because `TestA` and `TestB` are both the same object. For us to distinguish them, they need to represent a different type or a different value, which requires boilerplate.

```ql
// Option A:
newtype TTest() = TMyTest();

class MyTest extends TMyTest() {}

// Option B:
class MyTest extends string {
    MyTest() { this = "My test" }
}
```

Alternatively, the `run()` member can bind the name:

```ql
class MyTest extends TestBase {
    override predicate run(string name) {
        name = "My test"
        and ....
    }
}

from TestBase test, string name
where test.run(name)
select name, ....
```

This is less boilerplate, but the name is only accessable if the `run()` predicate holds. If we want to show the test name when it fails, and the test name when it passes, then the run predicate must always hold. This means the test result must be the result or a parameter value.

```
  override TestResult run(string name) {
    name = "my test" and
    (
      if not passes()
      then result = fail()
      or
      result = pass()
    )
  }
```

The combination of name setting, test running, and result setting is awkward. But we can wrap all of this up in a single string.

```
class MyTest extends Test, Case {
    override string test() {
        if predicateShouldHold()
        then result = "PASS: my predicate holds"
        else result = "FAIL: Uh oh, predicateShouldHold() doesn't hold!"
    }
}
```

We can make a class that extends string to make this into a readable DSL. In some ways this is more boilerplate, but in another sense it allows for descriptive tests.

```
bindingset[this]
class Qnit extends string {
    predicate pass(string name) {
        this = "PASS: " + name
    }

    predicate fail(string why) {
        this = "FAIL: " + why
    }
}

class MyTest extends TestBase {
    override predicate run(Qnit test) {
        if ...
        then test.pass("my test passes")
        else test.fail("my test fails")
    }
}
```

As an additional benefit, since `test` is an infinite type, there will be a compilation failure if it is possible for the test to have no declared result:

```ql
class MyTest extends Test, Case {
    override predicate run(Qnit test) {
        1 = 1 and test.pass("This test always passes")
        // Compilation error: `test` is not bound to a value
    }
}
```

Overall, this approach/DSL seems satisfactory. However, it unfortunately results in a warning for overriding an abstract class (Test) without a characteristic predicate. This can be worked around by adding another empty base class:

```ql

class Case extends Unit {}

class MyTest extends Test, Case {
    override predicate run(Qnit test) {
        // no longer a has a warning for overriding an abstract class without a characteristic predicate,
        // because it now extends Case.
    }
}
```

Here we have a complete DSL, for which we can easily declare a test runner:

```ql
// Runner.ql
query predicate test(string output) {
    // If all tests pass, we just select the string "All tests passed."
    if forall (Qnit outcome | any(Test t).run(outcome) | outcome.isPass()) 
    then output = "All tests passed."
    else // Otherwise, we select all the test outcomes.
    any(Test t).run(output)
}
```