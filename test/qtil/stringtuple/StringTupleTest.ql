import qtil.testing.Qnit
import qtil.tuple.StringTuple

class TestMakeStringTupleComma2 extends Test, Case {
  override predicate run(Qnit test) {
    if StringTuple<Separator::comma/0>::of2("foo", "bar") = "foo,bar"
    then test.pass("Correct comma tuple of 2")
    else test.fail("Incorrect comma tuple of 2")
  }
}

class TestStringTupleComma2Values extends Test, Case {
  override predicate run(Qnit test) {
    if
      exists(StringTuple<Separator::comma/0>::Tuple tuple |
        tuple = StringTuple<Separator::comma/0>::of2("foo", "bar") and
        tuple.get(0) = "foo" and
        tuple.get(1) = "bar"
      )
    then test.pass("Correct values in comma tuple2")
    else test.fail("Incorrect values comma tuple2")
  }
}

class TestMakeStringTupleComma3 extends Test, Case {
  override predicate run(Qnit test) {
    if StringTuple<Separator::comma/0>::of3("foo", "bar", "baz") = "foo,bar,baz"
    then test.pass("Correct comma tuple of 3")
    else test.fail("Incorrect comma tuple of 3")
  }
}

class TestStringTupleComma3Values extends Test, Case {
  override predicate run(Qnit test) {
    if
      exists(StringTuple<Separator::comma/0>::Tuple tuple |
        tuple = StringTuple<Separator::comma/0>::of3("foo", "bar", "baz") and
        tuple.get(0) = "foo" and
        tuple.get(1) = "bar" and
        tuple.get(2) = "baz"
      )
    then test.pass("Correct values in comma tuple3")
    else test.fail("Incorrect values comma tuple3")
  }
}

class TestMakeStringTupleColon2 extends Test, Case {
  override predicate run(Qnit test) {
    if StringTuple<Separator::colon/0>::of2("foo", "bar") = "foo:bar"
    then test.pass("Correct colon tuple of 2")
    else test.fail("Incorrect colon tuple of 2")
  }
}

class TestStringTupleColon2Values extends Test, Case {
  override predicate run(Qnit test) {
    if
      exists(StringTuple<Separator::colon/0>::Tuple tuple |
        tuple = StringTuple<Separator::colon/0>::of2("foo", "bar") and
        tuple.get(0) = "foo" and
        tuple.get(1) = "bar"
      )
    then test.pass("Correct values in colon tuple2")
    else test.fail("Incorrect values colon tuple2")
  }
}

class TestMakeStringTupleOtherSeparators extends Test, Case {
  override predicate run(Qnit test) {
    if
      StringTuple<Separator::amp/0>::of2("foo", "bar") = "foo&bar" and
      StringTuple<Separator::dollar/0>::of2("foo", "bar") = "foo$bar" and
      StringTuple<Separator::excl/0>::of2("foo", "bar") = "foo!bar" and
      StringTuple<Separator::hash/0>::of2("foo", "bar") = "foo#bar" and
      StringTuple<Separator::at/0>::of2("foo", "bar") = "foo@bar" and
      StringTuple<Separator::caret/0>::of2("foo", "bar") = "foo^bar" and
      StringTuple<Separator::pipe/0>::of2("foo", "bar") = "foo|bar" and
      StringTuple<Separator::semicolon/0>::of2("foo", "bar") = "foo;bar" and
      StringTuple<Separator::plus/0>::of2("foo", "bar") = "foo+bar" and
      StringTuple<Separator::minus/0>::of2("foo", "bar") = "foo-bar" and
      StringTuple<Separator::slash/0>::of2("foo", "bar") = "foo/bar" and
      StringTuple<Separator::backslash/0>::of2("foo", "bar") = "foo\\bar" and
      StringTuple<Separator::dot/0>::of2("foo", "bar") = "foo.bar" and
      StringTuple<Separator::question/0>::of2("foo", "bar") = "foo?bar" and
      StringTuple<Separator::percent/0>::of2("foo", "bar") = "foo%bar" and
      StringTuple<Separator::tilde/0>::of2("foo", "bar") = "foo~bar" and
      StringTuple<Separator::space/0>::of2("foo", "bar") = "foo bar" and
      StringTuple<Separator::tab/0>::of2("foo", "bar") = "foo\tbar" and
      StringTuple<Separator::newline/0>::of2("foo", "bar") = "foo\nbar" and
      StringTuple<Separator::backtick/0>::of2("foo", "bar") = "foo`bar"
    then test.pass("Correct tuple of 2 with other separators")
    else test.fail("Incorrect tuple with at least one other separator")
  }
}

class TestStringTuple4 extends Test, Case {
  override predicate run(Qnit test) {
    if
      exists(StringTuple<Separator::comma/0>::Tuple tuple |
        tuple = StringTuple<Separator::comma/0>::of4("foo", "bar", "baz", "qux") and
        tuple.get(0) = "foo" and
        tuple.get(1) = "bar" and
        tuple.get(2) = "baz" and
        tuple.get(3) = "qux"
      )
    then test.pass("Correct values in comma tuple4")
    else test.fail("Incorrect values comma tuple4")
  }
}

class TestStringTuple5 extends Test, Case {
  override predicate run(Qnit test) {
    if
      exists(StringTuple<Separator::comma/0>::Tuple tuple |
        tuple = StringTuple<Separator::comma/0>::of5("foo", "bar", "baz", "qux", "quux") and
        tuple.get(0) = "foo" and
        tuple.get(1) = "bar" and
        tuple.get(2) = "baz" and
        tuple.get(3) = "qux" and
        tuple.get(4) = "quux"
      )
    then test.pass("Correct values in comma tuple5")
    else test.fail("Incorrect values comma tuple5")
  }
}

class TestStringTuple6 extends Test, Case {
  override predicate run(Qnit test) {
    if
      exists(StringTuple<Separator::comma/0>::Tuple tuple |
        tuple = StringTuple<Separator::comma/0>::of6("foo", "bar", "baz", "qux", "quux", "corge") and
        tuple.get(0) = "foo" and
        tuple.get(1) = "bar" and
        tuple.get(2) = "baz" and
        tuple.get(3) = "qux" and
        tuple.get(4) = "quux" and
        tuple.get(5) = "corge"
      )
    then test.pass("Correct values in comma tuple6")
    else test.fail("Incorrect values comma tuple6")
  }
}

class TestStringTuple7 extends Test, Case {
  override predicate run(Qnit test) {
    if
      exists(StringTuple<Separator::comma/0>::Tuple tuple |
        tuple =
          StringTuple<Separator::comma/0>::of7("foo", "bar", "baz", "qux", "quux", "corge", "grault") and
        tuple.get(0) = "foo" and
        tuple.get(1) = "bar" and
        tuple.get(2) = "baz" and
        tuple.get(3) = "qux" and
        tuple.get(4) = "quux" and
        tuple.get(5) = "corge" and
        tuple.get(6) = "grault"
      )
    then test.pass("Correct values in comma tuple7")
    else test.fail("Incorrect values comma tuple7")
  }
}

class TestStringTuple8 extends Test, Case {
  override predicate run(Qnit test) {
    if
      exists(StringTuple<Separator::comma/0>::Tuple tuple |
        tuple =
          StringTuple<Separator::comma/0>::of8("foo", "bar", "baz", "qux", "quux", "corge",
            "grault", "garply") and
        tuple.get(0) = "foo" and
        tuple.get(1) = "bar" and
        tuple.get(2) = "baz" and
        tuple.get(3) = "qux" and
        tuple.get(4) = "quux" and
        tuple.get(5) = "corge" and
        tuple.get(6) = "grault" and
        tuple.get(7) = "garply"
      )
    then test.pass("Correct values in comma tuple8")
    else test.fail("Incorrect values comma tuple8")
  }
}
