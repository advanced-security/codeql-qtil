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

class TestEscapeWrapWithMappedCharacter extends Test, Case {
  override predicate run(Qnit test) {
    if
      WrapEscape<Chars::colon/0, colonEscapeMap/2>::wrapEscaping("foo:bar", charOf("$")) =
        ":foo$:bar:"
    then test.pass("Basic escape wrap with mapped character works")
    else test.fail("Basic escape wrap with mapped character doesn't work")
  }
}

class TestEscapeWrapWithMappedChangeCharacter extends Test, Case {
  override predicate run(Qnit test) {
    if
      WrapEscape<Chars::colon/0, colonToAtEscapeMap/2>::wrapEscaping("foo:bar", charOf("$")) =
        ":foo$@bar:"
    then test.pass("Basic escape wrap with mapped change character works")
    else
      test.fail("Basic escape wrap with mapped change character doesn't work" +
          WrapEscape<Chars::colon/0, colonToAtEscapeMap/2>::wrapEscaping("foo:bar", charOf("$")))
  }
}

class TestEscapeWithRegexCharacters extends Test, Case {
  override predicate run(Qnit test) {
    exists(Char c |
      c in [
          charOf("$"), charOf("^"), charOf("*"), charOf("+"), charOf("?"), charOf("("), charOf(")"),
          charOf("{"), charOf("}"), charOf("["), charOf("]"), charOf("|"), charOf("\\")
        ]
    |
      if
        Escape<emptyEscapeMap/2>::escape("foo" + c + "bar", c) = "foo" + c.repeat(2) + "bar" and
        Escape<emptyEscapeMap/2>::unescape(Escape<emptyEscapeMap/2>::escape("foo" + c + "bar", c), c) =
          "foo" + c + "bar"
      then test.pass("Basic escape with regex characters works")
      else test.fail("Basic escape with regex characters doesn't work for char " + c)
    )
  }
}

class TestEscapeWithRegexMetarcharacterClasses extends Test, Case {
  override predicate run(Qnit test) {
    // Handle cases where we should not add backslashes to regex behavior, such as `\a`, `\A`, `\b`,
    // `\B`, `\c`, `\d`, `\D`, `\e`, `\E`, `\G`, `\h`, `\H`, `\k`, `p`, `\Q`, `\R`, `\s`, `\S`,
    // `\u`, `\v`, `\V`, `\w`, `\W`, `\x`, `\Z`, `\0`.
    //
    // Cases like `\n`, `\r`, `\t`, `\f` are checked in the next test.
    if
      forall(Char base, Char c |
        base in [
            charOf("a"), charOf("b"), charOf("c"), charOf("d"), charOf("e"), charOf("f"),
            charOf("g"), charOf("h"), charOf("i"), charOf("j"), charOf("k"), charOf("l"),
            charOf("m"), charOf("n"), charOf("o"), charOf("p"), charOf("q"), charOf("r"),
            charOf("s"), charOf("t"), charOf("u"), charOf("v"), charOf("w"), charOf("x"),
            charOf("y"), charOf("z"), charOf("0")
          ] and
        c = [base, base.toUppercase()] and
        not exists(c.indexIn("foobar"))
      |
        Escape<emptyEscapeMap/2>::escape("foo" + c + "bar", c) = "foo" + c.repeat(2) + "bar" and
        Escape<emptyEscapeMap/2>::unescape(Escape<emptyEscapeMap/2>::escape("foo" + c + "bar", c), c) =
          "foo" + c + "bar"
      ) and
      forall(Char c | c in [charOf("f"), charOf("o"), charOf("b"), charOf("a"), charOf("r")] |
        Escape<emptyEscapeMap/2>::escape("qux" + c + "quip", c) = "qux" + c.repeat(2) + "quip" and
        Escape<emptyEscapeMap/2>::unescape(Escape<emptyEscapeMap/2>::escape("qux" + c + "quip", c),
          c) = "qux" + c + "quip"
      )
    then test.pass("Basic escape with regex backslash codes works")
    else test.fail("Basic escape with regex backslash codes doesn't work")
  }
}

class TestEscapeWithRegexEscapeMappedMetaCharacters extends Test, Case {
  Char bell() { result = 7 }

  Char backspace() { result = 8 }

  Char escape() { result = 27 }

  Char formFeed() { result = 12 }

  override predicate run(Qnit test) {
    // Test tab, newline, carriage return, form feed, and backspace
    exists(Char c |
      c in [charOf("\n"), charOf("\t"), charOf("\r"), bell(), formFeed(), escape(), backspace()]
    |
      if
        Escape<emptyEscapeMap/2>::escape("foo" + c + "bar", c) = "foo" + c.repeat(2) + "bar" and
        Escape<emptyEscapeMap/2>::unescape(Escape<emptyEscapeMap/2>::escape("foo" + c + "bar", c), c) =
          "foo" + c + "bar"
      then test.pass("Basic escape with regex escape mapped characters works")
      else
        test.fail("Basic escape with regex escape mapped characters doesn't work for char '" + c +
            "'.")
    )
  }
}

class TestAllAsciiCharacters extends Test, Case {
  override predicate run(Qnit test) {
    // Check all ASCII characters
    exists(Char c | c in [1 .. 127] |
      if
        Escape<emptyEscapeMap/2>::escape("foo" + c + "bar", c) =
          ("foo" + c + "bar").replaceAll(c.toString(), c.repeat(2)) and
        Escape<emptyEscapeMap/2>::unescape(Escape<emptyEscapeMap/2>::escape("foo" + c + "bar", c), c) =
          "foo" + c + "bar"
      then test.pass("Basic escape with all ASCII characters works")
      else test.fail("Basic escape with all ASCII characters doesn't work far char '" + c + "'.")
    )
  }
}
