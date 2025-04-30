import qtil.testing.Qnit
import qtil.strings.FluentString

class TestAppend extends Test, Case {
  override predicate run(Qnit test) {
    if fluentString("foo").append("bar") = "foobar"
    then test.pass("FluentString append works")
    else test.fail("FluentString append doesn't work")
  }
}

class TestPrepend extends Test, Case {
  override predicate run(Qnit test) {
    if fluentString("foo").prepend("bar") = "barfoo"
    then test.pass("FluentString prepend works")
    else test.fail("FluentString prepend doesn't work")
  }
}

class TestAppendPrepend extends Test, Case {
  override predicate run(Qnit test) {
    if fluentString("foo").append("bar").prepend("baz") = "bazfoobar"
    then test.pass("FluentString append and prepend work")
    else test.fail("FluentString append and prepend don't work")
  }
}
