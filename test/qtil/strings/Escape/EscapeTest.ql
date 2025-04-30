import qtil.strings.Escape
import qtil.testing.Qnit

class TestEscapeNothingToDo extends Test, Case {
  override predicate run(Qnit test) {
    if escape("foo", "$", "%") = "foo"
    then test.pass("Basic escape nothing to do works")
    else test.fail("Basic escape nothing to do doesn't work")
  }
}

class TestEscapeBasic extends Test, Case {
  override predicate run(Qnit test) {
    if escape("foo$bar", "$", "%") = "foo%$bar"
    then test.pass("Basic escape works")
    else test.fail("Basic escape doesn't work")
  }
}

class TestEscapeWillEscapeTheEscaper extends Test, Case {
  override predicate run(Qnit test) {
    if escape("foo$bar$baz", "$", "%") = "foo%$bar%$baz"
    then test.pass("Escape will escape the escaper")
    else test.fail("Escape not properly escaping the escaper")
  }
}

class TestEscapeWithBackslashDefault extends Test, Case {
  override predicate run(Qnit test) {
    if escape("foo$bar", "$") = "foo\\$bar"
    then test.pass("Escape with backslash default works")
    else test.fail("Escape with backslash default doesn't work")
  }
}

class TestEscapeWithBackslashWillEscapeTheEscaper extends Test, Case {
  override predicate run(Qnit test) {
    if escape("foo$bar\\baz", "$") = "foo\\$bar\\\\baz"
    then test.pass("Escape with backslash will escape the escaper")
    else test.fail("Escape with backslash not properly escaping the escaper")
  }
}

class TestWrapEscapingNothingToDo extends Test, Case {
  override predicate run(Qnit test) {
    if wrapEscaping("foo", "$", "%") = "$foo$"
    then test.pass("Basic wrap escaping nothing to do works")
    else test.fail("Basic wrap escaping nothing to do doesn't work")
  }
}

class TestWrapEscapingBasic extends Test, Case {
  override predicate run(Qnit test) {
    if wrapEscaping("foo$bar", "$", "%") = "$foo%$bar$"
    then test.pass("Basic wrap escaping works")
    else test.fail("Basic wrap escaping doesn't work")
  }
}

class TestWrapEscapingWillEscapeTheEscaper extends Test, Case {
  override predicate run(Qnit test) {
    if wrapEscaping("foo$bar$baz", "$", "%") = "$foo%$bar%$baz$"
    then test.pass("Wrap escaping will escape the escaper")
    else test.fail("Wrap escaping not properly escaping the escaper")
  }
}

class TestWrapEscapingWithBackslashDefault extends Test, Case {
  override predicate run(Qnit test) {
    if wrapEscaping("foo$bar", "$") = "$foo\\$bar$"
    then test.pass("Wrap escaping with backslash default works")
    else test.fail("Wrap escaping with backslash default doesn't work")
  }
}

class TestDoubleQuoteEscapingNothingToDo extends Test, Case {
  override predicate run(Qnit test) {
    if doubleQuoteEscaping("foo") = "\"foo\""
    then test.pass("Basic double quote escaping nothing to do works")
    else test.fail("Basic double quote escaping nothing to do doesn't work")
  }
}

class TestDoubleQuoteEscapingBasic extends Test, Case {
  override predicate run(Qnit test) {
    if doubleQuoteEscaping("foo\"bar") = "\"foo\\\"bar\""
    then test.pass("Basic double quote escaping works")
    else test.fail("Basic double quote escaping doesn't work")
  }
}

class TestDoubleQuoteEscapingWillEscapeTheEscaper extends Test, Case {
  override predicate run(Qnit test) {
    if doubleQuoteEscaping("foo\"bar\"baz") = "\"foo\\\"bar\\\"baz\""
    then test.pass("Double quote escaping will escape the escaper")
    else test.fail("Double quote escaping not properly escaping the escaper")
  }
}

class TestSingleQuoteEscapingNothingToDo extends Test, Case {
  override predicate run(Qnit test) {
    if singleQuoteEscaping("foo") = "'foo'"
    then test.pass("Basic single quote escaping nothing to do works")
    else test.fail("Basic single quote escaping nothing to do doesn't work")
  }
}

class TestUnescapeNothingToDo extends Test, Case {
  override predicate run(Qnit test) {
    if unescape("foo", "$") = "foo"
    then test.pass("Basic unescape nothing to do works")
    else test.fail("Basic unescape nothing to do doesn't work")
  }
}

class TestUnescapeBasic extends Test, Case {
  override predicate run(Qnit test) {
    if unescape("foo$bar", "$") = "foobar"
    then test.pass("Basic unescape works")
    else test.fail("Basic unescape doesn't work")
  }
}

class TestUnescapeWillUnescapeTheEscaper extends Test, Case {
  override predicate run(Qnit test) {
    if unescape("foo$$bar", "$") = "foo$bar"
    then test.pass("Unescape will unescape the escaper")
    else test.fail("Unescape not properly unescaping the escaper")
  }
}

class TestUnescapeWithManyEscapeCharacters extends Test, Case {
  override predicate run(Qnit test) {
    if unescape("$$$$$five $$$$four $$$three $$two $one", "$") = "$$five $$four $three $two one"
    then test.pass("Unescape with many escape characters works")
    else test.fail("Unescape with many escape characters doesn't work")
  }
}