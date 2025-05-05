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

import SeparatedEscape<Chars::comma/0, defaultEscapeMap/2> as Csv
import SeparatedEscape<Chars::dollar/0, defaultEscapeMap/2> as DollarSV
import SeparatedEscape<Chars::tab/0, defaultEscapeMap/2> as TabSV

class TestCsvOfX extends Test, Case {
  override predicate run(Qnit test) {
    if
      Csv::Backslashed::of2("foo", "bar") = "foo,bar" and
      Csv::Backslashed::of3("foo", "bar", "baz") = "foo,bar,baz" and
      Csv::Backslashed::of4("foo", "bar", "baz", "qux") = "foo,bar,baz,qux" and
      Csv::EscapedWith<Chars::dollar/0>::of2("foo", "bar") = "foo,bar" and
      Csv::EscapedWith<Chars::dollar/0>::of3("foo", "bar", "baz") = "foo,bar,baz" and
      Csv::EscapedWith<Chars::dollar/0>::of4("foo", "bar", "baz", "qux") = "foo,bar,baz,qux"
    then test.pass("Basic CSV ofx() works")
    else test.fail("Basic CSV ofx() doesn't work")
  }
}

class TestCsvOfXWithEscape extends Test, Case {
  override predicate run(Qnit test) {
    if
      Csv::Backslashed::of2("foo,bar", "baz\\qux") = "foo\\,bar,baz\\\\qux" and
      Csv::EscapedWith<Chars::dollar/0>::of2("foo,bar", "baz$qux") = "foo$,bar,baz$$qux" and
      Csv::Backslashed::of3("foo,bar", "baz\\qux", "quux") = "foo\\,bar,baz\\\\qux,quux" and
      Csv::EscapedWith<Chars::dollar/0>::of3("foo,bar", "baz$qux", "quux") =
        "foo$,bar,baz$$qux,quux"
    then test.pass("Basic CSV ofx() with escape works")
    else test.fail("Basic CSV ofx() with escape doesn't work")
  }
}

class TestDollarSVOfX extends Test, Case {
  override predicate run(Qnit test) {
    if
      DollarSV::Backslashed::of2("foo", "bar") = "foo$bar" and
      DollarSV::Backslashed::of3("foo", "bar", "baz") = "foo$bar$baz" and
      DollarSV::Backslashed::of4("foo", "bar", "baz", "qux") = "foo$bar$baz$qux" and
      DollarSV::EscapedWith<Chars::at/0>::of2("foo", "bar") = "foo$bar" and
      DollarSV::EscapedWith<Chars::at/0>::of3("foo", "bar", "baz") = "foo$bar$baz" and
      DollarSV::EscapedWith<Chars::at/0>::of4("foo", "bar", "baz", "qux") = "foo$bar$baz$qux"
    then test.pass("Basic dollarSV ofx() works")
    else test.fail("Basic dollarSV ofx() doesn't work")
  }
}

class TestDollarSVOfXWithEscape extends Test, Case {
  override predicate run(Qnit test) {
    if
      DollarSV::Backslashed::of2("foo$bar", "baz\\qux") = "foo\\$bar$baz\\\\qux" and
      DollarSV::EscapedWith<Chars::at/0>::of2("foo$bar", "baz@qux") = "foo@$bar$baz@@qux" and
      DollarSV::Backslashed::of3("foo$bar", "baz\\qux", "quux") = "foo\\$bar$baz\\\\qux$quux" and
      DollarSV::EscapedWith<Chars::at/0>::of3("foo$bar", "baz@qux", "quux") =
        "foo@$bar$baz@@qux$quux"
    then test.pass("Basic dollarSV ofx() with escape works")
    else test.fail("Basic dollarSV ofx() with escape doesn't work")
  }
}

class TestTabSeparatedValuesProperlyEscapeTabs extends Test, Case {
  override predicate run(Qnit test) {
    if
      TabSV::Backslashed::of2("foo\tbar", "baz\tqux") = "foo\\tbar\tbaz\\tqux" and
      TabSV::EscapedWith<Chars::at/0>::of2("foo\tbar", "baz\tqux") = "foo@tbar\tbaz@tqux"
    then test.pass("Basic tab separated values ofx() works")
    else test.fail("Basic tab separated values ofx() doesn't work")
  }
}

class TestSplitCsv extends Test, Case {
  override predicate run(Qnit test) {
    if
      Csv::split("foo,bar,baz", 0) = "foo" and
      Csv::split("foo,bar,baz", 1) = "bar" and
      Csv::split("foo,bar,baz", 2) = "baz" and
      not exists(Csv::split("foo,bar,baz", 4)) and
      Csv::split("foo\\,bar,baz", 0) = "foo,bar" and
      Csv::split("foo\\,bar,baz", 1) = "baz" and
      Csv::split("foo\\\\,bar,baz") = ["foo\\", "bar", "baz"] and
      Csv::split("foo\\\\\\,bar,baz") = ["foo\\,bar", "baz"] and
      Csv::split("foo\\\\\\\\,bar,baz") = ["foo\\\\", "bar", "baz"]
    then test.pass("Basic CSV split works")
    else test.fail("Basic CSV split doesn't work " + Csv::split("foo\\,bar,baz", _))
  }
}

class TestSplitTabSV extends Test, Case {
  override predicate run(Qnit test) {
    if
      TabSV::split("foo\tbar\tbaz", 0) = "foo" and
      TabSV::split("foo\tbar\tbaz", 1) = "bar" and
      TabSV::split("foo\tbar\tbaz", 2) = "baz" and
      not exists(TabSV::split("foo\tbar\tbaz", 3)) and
      TabSV::split("foo\\tbar\tbaz", 0) = "foo\tbar" and
      TabSV::split("foo\\tbar\tbaz", 1) = "baz" and
      TabSV::split("foo\\\\tbar\tbaz") = ["foo\\tbar", "baz"] and
      TabSV::split("foo\\\\\\tbar\tbaz") = ["foo\\\tbar", "baz"] and
      TabSV::split("foo\\\\\\\\tbar\tbaz") = ["foo\\\\tbar", "baz"]
    then test.pass("Basic tab separated values split works")
    else test.fail("Basic tab separated values split doesn't work")
  }
}

class TestSplitCsvWithEmptyColumns extends Test, Case {
  override predicate run(Qnit test) {
    if
      Csv::split("", 0) = "" and
      not exists(Csv::split("", 1)) and
      Csv::split("foo", 0) = "foo" and
      not exists(Csv::split("foo", 1)) and
      Csv::split("foo,", 0) = "foo" and
      Csv::split("foo,", 1) = "" and
      not exists(Csv::split("foo,", 2)) and
      Csv::split(",foo", 0) = "" and
      Csv::split(",foo", 1) = "foo" and
      Csv::split(",foo,", 0) = "" and
      Csv::split(",foo,", 1) = "foo" and
      Csv::split(",foo,", 2) = "" and
      not exists(Csv::split(",foo,", 3)) and
      Csv::split("foo,,bar", 0) = "foo" and
      Csv::split("foo,,bar", 1) = "" and
      Csv::split("foo,,bar", 2) = "bar" and
      not exists(Csv::split("foo,,bar", 3)) and
      Csv::split("foo,,,bar", 0) = "foo" and
      Csv::split("foo,,,bar", 1) = "" and
      Csv::split("foo,,,bar", 2) = "" and
      Csv::split("foo,,,bar", 3) = "bar" and
      not exists(Csv::split("foo,,,bar", 4)) and
      Csv::split(",,foo", 0) = "" and
      Csv::split(",,foo", 1) = "" and
      Csv::split(",,foo", 2) = "foo" and
      not exists(Csv::split(",,foo", 3)) and
      Csv::split("foo,,", 0) = "foo" and
      Csv::split("foo,,", 1) = "" and
      Csv::split("foo,,", 2) = "" and
      not exists(Csv::split("foo,,", 3))
    then test.pass("Basic CSV split with empty columns works")
    else test.fail("Basic CSV split with empty columns doesn't work")
  }
}

string empty() { none() }

string emptyIdx(int idx) { none() }

string emptyString() { result = "" }

string emptyStringIdx(int idx) { idx = 0 and result = "" }

string fooBarBaz() { result in ["foo", "bar", "baz"] }

string justFoo() { result = "foo" }

string justFooIdx(int idx) { idx = 0 and result = "foo" }

string fooBarBazIdx(int idx) {
  idx = 0 and result = "foo"
  or
  idx = 1 and result = "bar"
  or
  idx = 2 and result = "baz"
}

class TestConcatCsv extends Test, Case {
  override predicate run(Qnit test) {
    if
      Csv::Concat<emptyIdx/1>::join() = "" and
      Csv::ConcatUnordered<empty/0>::join() = "" and
      Csv::Concat<emptyStringIdx/1>::join() = "" and
      Csv::ConcatUnordered<emptyString/0>::join() = "" and
      Csv::Concat<justFooIdx/1>::join() = "foo" and
      Csv::ConcatUnordered<justFoo/0>::join() = "foo" and
      Csv::Concat<fooBarBazIdx/1>::join() = "foo,bar,baz" and
      Csv::ConcatUnordered<fooBarBaz/0>::join() in [
          "foo,bar,baz", "foo,baz,bar", "bar,foo,baz", "bar,baz,foo", "baz,foo,bar", "baz,bar,foo"
        ]
    then test.pass("Basic CSV concat works")
    else test.fail("Basic CSV concat doesn't work")
  }
}
