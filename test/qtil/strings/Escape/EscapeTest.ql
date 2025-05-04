import qtil.strings.Escape
import qtil.testing.Qnit
import qtil.strings.Char
import qtil.strings.Chars
import qtil.list.ListBuilder

predicate colonEscapeMap(Char s, Char t) { s.isStr(":") and t.isStr(":") }

predicate colonToAtEscapeMap(Char s, Char t) { s.isStr(":") and t.isStr("@") }

class TestEscapeNothingToDo extends Test, Case {
  override predicate run(Qnit test) {
    if Escape<emptyEscapeMap/2>::escape("foo", charOf("%")) = "foo"
    then test.pass("Basic escape nothing to do works")
    else test.fail("Basic escape nothing to do doesn't work")
  }
}

class TestEscapeEscapesItself extends Test, Case {
  override predicate run(Qnit test) {
    if Escape<emptyEscapeMap/2>::escape("foo%bar", charOf("%")) = "foo%%bar"
    then test.pass("Basic escape itself works")
    else test.fail("Basic escape itself doesn't work")
  }
}

class TestEscapeWithEscapeMapUnchanged extends Test, Case {
  override predicate run(Qnit test) {
    if Escape<colonEscapeMap/2>::escape("foo:bar", charOf("%")) = "foo%:bar"
    then test.pass("Basic escape map works")
    else test.fail("Basic escape map doesn't work")
  }
}

class TestEscapeWithEscapeMapChanged extends Test, Case {
  override predicate run(Qnit test) {
    if Escape<colonToAtEscapeMap/2>::escape("foo:bar", charOf("%")) = "foo%@bar"
    then test.pass("Basic escape map changed works")
    else test.fail("Basic escape map changed doesn't work")
  }
}

class TestEscapeWithBackslashDefaultNothingToDo extends Test, Case {
  override predicate run(Qnit test) {
    if Escape<emptyEscapeMap/2>::escape("foobar") = "foobar"
    then test.pass("Escape with backslash nothing to do works")
    else test.fail("Escape with backslash nothing to do doesn't work")
  }
}

class TestEscapeWithBackslashWillEscapeTheEscaper extends Test, Case {
  override predicate run(Qnit test) {
    if Escape<emptyEscapeMap/2>::escape("foo\\bar") = "foo\\\\bar"
    then test.pass("Escape with backslash will escape the escaper")
    else test.fail("Escape with backslash not properly escaping the escaper")
  }
}

class TestWrapEscapingNothingToDo extends Test, Case {
  override predicate run(Qnit test) {
    if WrapEscape<Chars::dollar/0, emptyEscapeMap/2>::wrapEscaping("foo", charOf("%")) = "$foo$"
    then test.pass("Basic wrap escaping nothing to do works")
    else test.fail("Basic wrap escaping nothing to do doesn't work")
  }
}

class TestWrapEscapingBasic extends Test, Case {
  override predicate run(Qnit test) {
    if
      WrapEscape<Chars::dollar/0, emptyEscapeMap/2>::wrapEscaping("foo$bar", charOf(".")) =
        "$foo.$bar$"
    then test.pass("Basic wrap escaping works")
    else test.fail("Basic wrap escaping doesn't work")
  }
}

class TestWrapEscapingWillEscapeTheEscaper extends Test, Case {
  override predicate run(Qnit test) {
    if
      WrapEscape<Chars::dollar/0, emptyEscapeMap/2>::wrapEscaping("foo.bar", charOf(".")) =
        "$foo..bar$"
    then test.pass("Wrap escaping will escape the escaper")
    else test.fail("Wrap escaping not properly escaping the escaper")
  }
}

class TestWrapEscapingWithBackslashDefault extends Test, Case {
  override predicate run(Qnit test) {
    if
      WrapEscape<Chars::dollar/0, emptyEscapeMap/2>::wrapEscaping("foo$bar", charOf("\\")) =
        "$foo\\$bar$"
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
    if Escape<emptyEscapeMap/2>::unescape("foo", charOf("$")) = "foo"
    then test.pass("Basic unescape nothing to do works")
    else test.fail("Basic unescape nothing to do doesn't work")
  }
}

class TestUnescapeBasic extends Test, Case {
  override predicate run(Qnit test) {
    if Escape<colonEscapeMap/2>::unescape("foo$:bar", charOf("$")) = "foo:bar"
    then test.pass("Basic unescape works")
    else test.fail("Basic unescape doesn't work")
  }
}

class TestUnescapeReverseChange extends Test, Case {
  override predicate run(Qnit test) {
    if Escape<colonToAtEscapeMap/2>::unescape("foo$@bar", charOf("$")) = "foo:bar"
    then test.pass("Basic unescape change works")
    else test.fail("Basic unescape change doesn't work")
  }
}

class TestUnescapeWillUnescapeTheEscaper extends Test, Case {
  override predicate run(Qnit test) {
    if Escape<emptyEscapeMap/2>::unescape("foo$$bar", charOf("$")) = "foo$bar"
    then test.pass("Unescape will unescape the escaper")
    else test.fail("Unescape not properly unescaping the escaper")
  }
}

class TestUnescapeWithManyEscapeCharacters extends Test, Case {
  override predicate run(Qnit test) {
    if
      Escape<colonEscapeMap/2>::unescape("$$$$$:five $$$$:four $$$:three $$:two $:one", charOf("$")) =
        "$$:five $$:four $:three $:two :one"
    then test.pass("Unescape with many escape characters works")
    else test.fail("Unescape with many escape characters doesn't work")
  }
}

class TestEscapeWithDefaultMap extends Test, Case {
  override predicate run(Qnit test) {
    if Escape<defaultEscapeMap/2>::escape("foo\nbar\tbaz") = "foo\\nbar\\tbaz"
    then test.pass("Basic escape with default map works")
    else test.fail("Basic escape with default map doesn't work")
  }
}

class TestUnescapeWithDefaultMap extends Test, Case {
  override predicate run(Qnit test) {
    if Escape<defaultEscapeMap/2>::unescape("foo\\nbar\\tbaz") = "foo\nbar\tbaz"
    then test.pass("Basic unescape with default map works")
    else test.fail("Basic unescape with default map doesn't work")
  }
}

class TestDoubleQuoteEscapeWithDefaultMap extends Test, Case {
  override predicate run(Qnit test) {
    if doubleQuoteEscaping("foo\nbar\tbaz") = "\"foo\\nbar\\tbaz\""
    then test.pass("Basic double quote escape with default map works")
    else test.fail("Basic double quote escape with default map doesn't work")
  }
}

class TestSingleQuoteEscapeWithDefaultMap extends Test, Case {
  override predicate run(Qnit test) {
    if singleQuoteEscaping("foo\nbar\tbaz") = "'foo\\nbar\\tbaz'"
    then test.pass("Basic single quote escape with default map works")
    else test.fail("Basic single quote escape with default map doesn't work")
  }
}

class TestDoubleQuoteUnescapeWithDefaultMap extends Test, Case {
  override predicate run(Qnit test) {
    if unescapeDoubleQuote("\"foo\\nbar\\tbaz\"") = "foo\nbar\tbaz"
    then test.pass("Basic double quote unescape with default map works")
    else test.fail("Basic double quote unescape with default map doesn't work")
  }
}

class TestSingleQuoteUnescapeWithDefaultMap extends Test, Case {
  override predicate run(Qnit test) {
    if unescapeSingleQuote("'foo\\nbar\\tbaz'") = "foo\nbar\tbaz"
    then test.pass("Basic single quote unescape with default map works")
    else test.fail("Basic single quote unescape with default map doesn't work")
  }
}
