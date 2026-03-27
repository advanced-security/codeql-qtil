import qtil.tuple.AggregableTuple
import qtil.testing.Qnit

class TestInitString extends Test, Case {
  override predicate run(Qnit test) {
    if AggregableTuple::initString("test") = "test"
    then test.pass("Correctly initialized a string")
    else test.fail("initString did not initialize correctly")
  }
}

class TestInitInt extends Test, Case {
  override predicate run(Qnit test) {
    if AggregableTuple::initInt(42) = "42"
    then test.pass("Correctly initialized an integer")
    else test.fail("initInt did not initialize correctly")
  }
}

class TestInitAppendString extends Test, Case {
  override predicate run(Qnit test) {
    if
      AggregableTuple::initString("test1").appendString("test2") = "test1,test2" and
      AggregableTuple::initString("test1").appendString("test2").appendString("test3") =
        "test1,test2,test3"
    then test.pass("Correctly appended multiple strings")
    else test.fail("appendString did not append multiple strings correctly")
  }
}

class TestInitAppendInt extends Test, Case {
  override predicate run(Qnit test) {
    if
      AggregableTuple::initInt(1).appendInt(2) = "1,2" and
      AggregableTuple::initInt(1).appendInt(2).appendInt(3) = "1,2,3"
    then test.pass("Correctly appended multiple integers")
    else test.fail("appendInt did not append multiple integers correctly")
  }
}

class TestInitAppendMixed extends Test, Case {
  override predicate run(Qnit test) {
    if
      AggregableTuple::initString("test").appendInt(42) = "test,42" and
      AggregableTuple::initInt(42).appendString("test") = "42,test"
    then test.pass("Correctly appended mixed types")
    else test.fail("appendMixed did not append mixed types correctly")
  }
}

int one() { result = 1 }

class TestConcatSingleString extends Test, Case {
  override predicate run(Qnit test) {
    if
      concat(string s | s = AggregableTuple::initString("test") | s, ",")
          .(AggregableTuple::Sum<one/0>::Sum)
          .getAsJoinedString(0, ",") = "test"
    then test.pass("Correctly concatenated single string")
    else test.fail("concat did not concatenate single string correctly")
  }
}

class TestSumSingleInt extends Test, Case {
  override predicate run(Qnit test) {
    if
      concat(string s | s = AggregableTuple::initInt(42) | s, ",")
          .(AggregableTuple::Sum<one/0>::Sum)
          .getAsSummedInt(0) = 42
    then test.pass("Correctly summed single integer")
    else test.fail("concat did not sum single integer correctly")
  }
}

class TestJoinMultipleStrings extends Test, Case {
  override predicate run(Qnit test) {
    if
      concat(string s | s = AggregableTuple::initString(["test1", "test2"]) | s, ",")
          .(AggregableTuple::Sum<one/0>::Sum)
          .getAsJoinedString(0, ",") = "test1,test2" and
      concat(string s | s = AggregableTuple::initString(["test1", "test2", "test3"]) | s, ",")
          .(AggregableTuple::Sum<one/0>::Sum)
          .getAsJoinedString(0, ",") = "test1,test2,test3"
    then test.pass("Correctly joined multiple strings")
    else test.fail("concat did not join multiple strings correctly")
  }
}

class TestSumMultipleIntegers extends Test, Case {
  override predicate run(Qnit test) {
    if
      concat(string s | s = AggregableTuple::initInt([1, 2]) | s, ",")
          .(AggregableTuple::Sum<one/0>::Sum)
          .getAsSummedInt(0) = 3 and
      concat(string s | s = AggregableTuple::initInt([1, 2, 3]) | s, ",")
          .(AggregableTuple::Sum<one/0>::Sum)
          .getAsSummedInt(0) = 6
    then test.pass("Correctly summed multiple integers")
    else test.fail("concat did not sum multiple integers correctly")
  }
}

class TestCountMultipleStrings extends Test, Case {
  override predicate run(Qnit test) {
    if
      concat(string s | s = AggregableTuple::initString(["test1", "test2"]) | s, ",")
          .(AggregableTuple::Sum<one/0>::Sum)
          .countColumn(0) = 2 and
      concat(string s | s = AggregableTuple::initString(["test1", "test2", "test3"]) | s, ",")
          .(AggregableTuple::Sum<one/0>::Sum)
          .countColumn(0) = 3
    then test.pass("Correctly counted multiple strings")
    else test.fail("concat did not count multiple strings correctly")
  }
}

class TestCountMultipleIntegers extends Test, Case {
  override predicate run(Qnit test) {
    if
      concat(string s | s = AggregableTuple::initInt([1, 2]) | s, ",")
          .(AggregableTuple::Sum<one/0>::Sum)
          .countColumn(0) = 2 and
      concat(string s | s = AggregableTuple::initInt([1, 2, 3]) | s, ",")
          .(AggregableTuple::Sum<one/0>::Sum)
          .countColumn(0) = 3
    then test.pass("Correctly counted multiple integers")
    else test.fail("concat did not count multiple integers correctly")
  }
}

int four() { result = 4 }

class TestAggregateMultiColumnPieces extends Test, Case {
  override predicate run(Qnit test) {
    if
      exists(AggregableTuple::Sum<four/0>::Sum summed |
        summed =
          concat(string s |
            s =
              AggregableTuple::initString(["test1", "test2"])
                  .appendInt([1, 2, 3])
                  .appendInt([2, 3, 4])
                  .appendString(["test3", "test4"])
          |
            s, ","
          ) and
        summed.getAsJoinedString(0, ",") = "test1,test2" and
        summed.getAsSummedInt(1) = 6 and
        summed.getAsSummedInt(2) = 9 and
        summed.getAsJoinedString(3, ",") = "test3,test4"
      )
    then test.pass("Correctly aggregated multi-column pieces")
    else test.fail("concat did not aggregate multi-column pieces correctly")
  }
}
