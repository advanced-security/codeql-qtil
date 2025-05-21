import qtil.fn.Fn
import qtil.testing.Qnit
import qtil.fn.testlib

class TestNullaryMapToString extends Test, Case {
  override predicate run(Qnit test) {
    if Fn0<int, getOne/0>::Compose<string, stringifyInt/1>::fn() = "1"
    then test.pass("map<getOne, toString> is '1'")
    else test.fail("map<getOne, toString> is not '1'")
  }
}

class TestUnaryMapToString extends Test, Case {
  override predicate run(Qnit test) {
    if Fn1<int, int, addOne/1>::Compose<string, stringifyInt/1>::fn(0) = "1"
    then test.pass("map<addOne, toString>(0) is '1'")
    else test.fail("map<addOne, toString>(0) is not '1'")
  }
}

class TestBinaryMapToString extends Test, Case {
  override predicate run(Qnit test) {
    if Fn2<int, int, int, add/2>::Compose<string, stringifyInt/1>::fn(3, 6) = "9"
    then test.pass("map<add, toString>(3, 6) is '9'")
    else test.fail("map<add, toString>(3, 6) is not '9'")
  }
}

class TestBasicNullaryFilter extends Test, Case {
  override predicate run(Qnit test) {
    if
      count(Fn0<int, getOneToThree/0>::Filter<isEven/1>::fn()) = 1 and
      Fn0<int, getOneToThree/0>::Filter<isEven/1>::fn() = 2
    then test.pass("filter<isEven>(getOneToThree) is 2")
    else test.fail("filter<isEven>(getOneToThree) is not 2")
  }
}

class TestBinaryFilter extends Test, Case {
  override predicate run(Qnit test) {
    if
      not exists(Fn2<int, int, int, add/2>::Filter<isEven/1>::fn(1, 2)) and
      count(Fn2<int, int, int, add/2>::Filter<isEven/1>::fn(4, 6)) = 1 and
      Fn2<int, int, int, add/2>::Filter<isEven/1>::fn(4, 6) = 10
    then test.pass("filter<isEven>(add(4, 6)) is 10")
    else test.fail("filter<isEven>(add(4, 6)) is not 10")
  }
}

class TestNullaryToLookup extends Test, Case {
  override predicate run(Qnit test) {
    if
      Fn2<int, int, int, add/2>::ToLookup<oneToThree/1>::fn(1, 2) = 3 and
      Fn2<int, int, int, add/2>::ToLookup<oneToThree/1>::fn(1, 0) = 1 and
      not exists(Fn2<int, int, int, add/2>::ToLookup<oneToThree/1>::fn(2, 3))
    then test.pass("toLookup working correctly")
    else test.fail("toLookup not working correctly")
  }
}

class TestIf extends Test, Case {
  override predicate run(Qnit test) {
    if
      Fn1<int, int, addOne/1>::If<isEven/1>::fn(2) = 3 and
      not exists(Fn1<int, int, addOne/1>::If<isEven/1>::fn(3))
    then test.pass("If<addOne, isEven> is working correctly")
    else test.fail("If<addOne, isEven> is not working correctly")
  }
}

class TestApply extends Test, Case {
  override predicate run(Qnit test) {
    if
      count(Fn1<int, int, double/1>::Apply<one/1>::fn()) = 1 and
      Fn1<int, int, double/1>::Apply<one/1>::fn() = 2 and
      count(Fn1<int, int, double/1>::Apply<oneToThree/1>::fn()) = 3 and
      Fn1<int, int, double/1>::Apply<oneToThree/1>::fn() = 2 and
      Fn1<int, int, double/1>::Apply<oneToThree/1>::fn() = 4 and
      Fn1<int, int, double/1>::Apply<oneToThree/1>::fn() = 6
    then test.pass("Apply<addOne, isEven> is working correctly")
    else test.fail("Apply<addOne, isEven> is not working correctly")
  }
}

class TestToRelation extends Test, Case {
  override predicate run(Qnit test) {
    if
      Fn1<int, int, double/1>::ToRelation<one/1>::rel(1) = 2 and
      count(int x, int r | Fn1<int, int, double/1>::ToRelation<one/1>::rel(x) = r) = 1 and
      count(int x, int r | Fn1<int, int, double/1>::ToRelation<oneToThree/1>::rel(x) = r) = 3 and
      Fn1<int, int, double/1>::ToRelation<oneToThree/1>::rel(1) = 2 and
      Fn1<int, int, double/1>::ToRelation<oneToThree/1>::rel(2) = 4 and
      Fn1<int, int, double/1>::ToRelation<oneToThree/1>::rel(3) = 6
    then test.pass("ToRelation working correctly")
    else test.fail("ToRelation not working correctly")
  }
}