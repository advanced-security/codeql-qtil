import qtil.list.Ordered
import qtil.testing.Qnit
import fib

class OrderedFib extends Ordered<Fib>::Type {
  override int getOrder() { result = this }
}

class OrderedGroupedFib extends Ordered<Fib>::GroupBy<TEvenOrOdd>::Type {
  override int getOrder() { result = this }

  override TEvenOrOdd getGroup() { if this % 2 = 0 then result = TEven() else result = TOdd() }
}

class TestFib2 extends Test, Case {
  override predicate run(Qnit test) {
    if
      exists(OrderedFib x |
        x = 2 and
        x.getDenseIndex() = 1 and
        not exists(x.getPrevious()) and
        x.getNext() = 3
      )
    then test.pass("Correct handling of fib 2")
    else test.fail("Incorrect handling of fib 2)")
  }
}

class TestFib3 extends Test, Case {
  override predicate run(Qnit test) {
    if
      exists(OrderedFib x |
        x = 3 and
        x.getDenseIndex() = 2 and
        x.getPrevious() = 2 and
        x.getNext() = 5
      )
    then test.pass("Correct handling of fib 3")
    else test.fail("Incorrect handling of fib 3")
  }
}

class TestFib55 extends Test, Case {
  override predicate run(Qnit test) {
    if
      exists(OrderedFib x |
        x = 55 and
        x.getDenseIndex() = 8 and
        x.getPrevious() = 34 and
        not exists(x.getNext())
      )
    then test.pass("Correct handling of fib 55")
    else test.fail("Incorrect handling of fib 55")
  }
}

class TestFibGrouped2 extends Test, Case {
  override predicate run(Qnit test) {
    if
      exists(OrderedGroupedFib x |
        x = 2 and
        x.getDenseIndex() = 1 and
        not exists(x.getPrevious()) and
        x.getNext() = 8 and
        x.getGroup() = TEven()
      )
    then test.pass("Correct handling of grouped fib 2")
    else test.fail("Incorrect handling of grouped fib 2)")
  }
}

class TestFibGrouped3 extends Test, Case {
  override predicate run(Qnit test) {
    if
      exists(OrderedGroupedFib x |
        x = 3 and
        x.getDenseIndex() = 1 and
        not exists(x.getPrevious()) and
        x.getNext() = 5 and
        x.getGroup() = TOdd()
      )
    then test.pass("Correct handling of grouped fib 3")
    else test.fail("Incorrect handling of grouped fib 3")
  }
}

class TestFibGrouped5 extends Test, Case {
  override predicate run(Qnit test) {
    if
      exists(OrderedGroupedFib x |
        x = 5 and
        x.getDenseIndex() = 2 and
        x.getPrevious() = 3 and
        x.getNext() = 13 and
        x.getGroup() = TOdd()
      )
    then test.pass("Correct handling of grouped fib 5")
    else test.fail("Incorrect handling of grouped fib 5")
  }
}

class TestFibGrouped8 extends Test, Case {
  override predicate run(Qnit test) {
    if
      exists(OrderedGroupedFib x |
        x = 8 and
        x.getDenseIndex() = 2 and
        x.getPrevious() = 2 and
        x.getNext() = 34 and
        x.getGroup() = TEven()
      )
    then test.pass("Correct handling of grouped fib 8")
    else test.fail("Incorrect handling of grouped fib 8")
  }
}

class TestFibGrouped34 extends Test, Case {
  override predicate run(Qnit test) {
    if
      exists(OrderedGroupedFib x |
        x = 34 and
        x.getDenseIndex() = 3 and
        x.getPrevious() = 8 and
        not exists(x.getNext()) and
        x.getGroup() = TEven()
      )
    then test.pass("Correct handling of grouped fib 34")
    else test.fail("Incorrect handling of grouped fib 34")
  }
}

class TestFibGrouped55 extends Test, Case {
  override predicate run(Qnit test) {
    if
      exists(OrderedGroupedFib x |
        x = 55 and
        x.getDenseIndex() = 5 and
        x.getPrevious() = 21 and
        not exists(x.getNext()) and
        x.getGroup() = TOdd()
      )
    then test.pass("Correct handling of grouped fib 55")
    else test.fail("Incorrect handling of grouped fib 55")
  }
}
