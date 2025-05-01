import qtil.list.CondensedList
import qtil.testing.Qnit
import fib

import CondenseList<Fib, identity/1>::Global
import CondenseList<Fib, identity/1>::GroupBy<TEvenOrOdd, evenOrOdd/1> as Grouped

class TestFib2 extends Test, Case {
  override predicate run(Qnit test) {
    if
      exists(ListEntry x |
        x.getItem() = 2 and
        x.getDenseIndex() = 1 and
        not exists(x.getPrev()) and
        x.getNext().getItem() = 3
      )
    then test.pass("Correct handling of fib 2")
    else test.fail("Incorrect handling of fib 2)")
  }
}

class TestFib3 extends Test, Case {
  override predicate run(Qnit test) {
    if
      exists(ListEntry x |
        x.getItem() = 3 and
        x.getDenseIndex() = 2 and
        x.getPrev().getItem() = 2 and
        x.getNext().getItem() = 5
      )
    then test.pass("Correct handling of fib 3")
    else test.fail("Incorrect handling of fib 3")
  }
}

class TestFib5 extends Test, Case {
  override predicate run(Qnit test) {
    if
      exists(ListEntry x |
        x.getItem() = 5 and
        x.getDenseIndex() = 3 and
        x.getPrev().getItem() = 3 and
        x.getNext().getItem() = 8
      )
    then test.pass("Correct handling of fib 5")
    else test.fail("Incorrect handling of fib 5")
  }
}

class TestFib55 extends Test, Case {
  override predicate run(Qnit test) {
    if
      exists(ListEntry x |
        x.getItem() = 55 and
        x.getDenseIndex() = 8 and
        x.getPrev().getItem() = 34 and
        not exists(x.getNext())
      )
    then test.pass("Correct handling of fib 55")
    else test.fail("Incorrect handling of fib 55")
  }
}

class TestDenseIndex extends Test, Case {
  override predicate run(Qnit test) {
    // Add 1 to the dense index to account for the fact that our fib class start at 2.
    if forall(ListEntry x | fib(x.getDenseIndex() + 2) = x.getItem())
    then test.pass("Correct dense indexes for all fibs")
    else test.fail("Incorrect dense index for some fibs")
  }
}

class TestGroupedFib2 extends Test, Case {
  override predicate run(Qnit test) {
    if
      exists(Grouped::ListEntry x |
        x.getItem() = 2 and
        x.getDivision() = TEven() and
        x.getDenseIndex() = 1 and
        not exists(x.getPrev()) and
        x.getNext().getItem() = 8
      )
    then test.pass("Correct handling of grouped fib 2")
    else test.fail("Incorrect handling of grouped fib 2")
  }
}

class TestGroupedFib3 extends Test, Case {
  override predicate run(Qnit test) {
    if
      exists(Grouped::ListEntry x |
        x.getItem() = 3 and
        x.getDivision() = TOdd() and
        x.getDenseIndex() = 1 and
        not exists(x.getPrev()) and
        x.getNext().getItem() = 5
      )
    then test.pass("Correct handling of grouped fib 3")
    else test.fail("Incorrect handling of grouped fib 3")
  }
}

class TestGroupedFib5 extends Test, Case {
  override predicate run(Qnit test) {
    if
      exists(Grouped::ListEntry x |
        x.getItem() = 5 and
        x.getDivision() = TOdd() and
        x.getDenseIndex() = 2 and
        x.getPrev().getItem() = 3 and
        x.getNext().getItem() = 13
      )
    then test.pass("Correct handling of grouped fib 5")
    else test.fail("Incorrect handling of grouped fib 5")
  }
}

class TestGroupedFib8 extends Test, Case {
  override predicate run(Qnit test) {
    if
      exists(Grouped::ListEntry x |
        x.getItem() = 8 and
        x.getDivision() = TEven() and
        x.getDenseIndex() = 2 and
        x.getPrev().getItem() = 2 and
        x.getNext().getItem() = 34
      )
    then test.pass("Correct handling of grouped fib 8")
    else test.fail("Incorrect handling of grouped fib 8")
  }
}

class TestGroupedFib55 extends Test, Case {
  override predicate run(Qnit test) {
    if
      exists(Grouped::ListEntry x |
        x.getItem() = 55 and
        x.getDivision() = TOdd() and
        x.getDenseIndex() = 5 and
        x.getPrev().getItem() = 21 and
        not exists(x.getNext())
      )
    then test.pass("Correct handling of grouped fib 55")
    else test.fail("Incorrect handling of grouped fib 55")
  }
}

class TestGroupedFib34 extends Test, Case {
  override predicate run(Qnit test) {
    if
      exists(Grouped::ListEntry x |
        x.getItem() = 34 and
        x.getDivision() = TEven() and
        x.getDenseIndex() = 3 and
        x.getPrev().getItem() = 8 and
        not exists(x.getNext())
      )
    then test.pass("Correct handling of grouped fib 34")
    else test.fail("Incorrect handling of grouped fib 34")
  }
}
