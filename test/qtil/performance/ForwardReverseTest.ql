import qtil.testing.Qnit
import qtil.performance.ForwardReverse
import Family

signature class FiniteType;

module BartToGrandpaConfig implements ForwardReverseSig<Person> {
  predicate start(Person p) { p.getName() = "Bart" }

  predicate end(Person p) { p.getName() = "Grandpa" }

  predicate edge(Person p1, Person p2) { p2 = p1.getAParent() }
}

module GrandpaToBartConfig implements ForwardReverseSig<Person> {
  predicate start(Person p) { p.getName() = "Grandpa" }

  predicate end(Person p) { p.getName() = "Bart" }

  predicate edge(Person p1, Person p2) { p2 = p1.getAChild() }
}

class TestBartForwardNodesContain extends Test, Case {
  override predicate run(Qnit test) {
    if
      forall(Person p |
        p.getName() = ["Bart", "Homer", "Marge", "Clancy", "Jacquelin", "Mona", "Grandpa"]
      |
        p instanceof ForwardReverse<Person, BartToGrandpaConfig>::ForwardNode
      )
    then test.pass("All forward nodes from Bart exist")
    else test.fail("Some forward nodes from Bart are missing")
  }
}

class TestBartForwardNodesDoNotContain extends Test, Case {
  override predicate run(Qnit test) {
    if
      exists(ForwardReverse<Person, BartToGrandpaConfig>::ForwardNode person |
        not person.getName() = ["Bart", "Homer", "Marge", "Clancy", "Jacquelin", "Mona", "Grandpa"]
      )
    then test.fail("Some unexpected forward nodes from Bart exist")
    else test.pass("No forward nodes from Bart exist that shouldn't")
  }
}

class TestBartReverseNodesContain extends Test, Case {
  override predicate run(Qnit test) {
    if
      forall(Person p | p.getName() = ["Bart", "Homer", "Grandpa"] |
        p instanceof ForwardReverse<Person, BartToGrandpaConfig>::ReverseNode
      )
    then test.pass("All reverse nodes from Bart exist")
    else test.fail("Some reverse nodes from Bart are missing")
  }
}

class TestBartReverseNodesDoNotContain extends Test, Case {
  override predicate run(Qnit test) {
    if
      exists(ForwardReverse<Person, BartToGrandpaConfig>::ReverseNode person |
        not person.getName() = ["Bart", "Homer", "Grandpa"]
      )
    then test.fail("Some unexpected reverse nodes from Bart exist")
    else test.pass("No reverse nodes from Bart exist that shouldn't")
  }
}

class TestGrandpaToBartForwardNodesContain extends Test, Case {
  override predicate run(Qnit test) {
    if
      forall(Person p | p.getName() = ["Grandpa", "Homer", "Bart", "Maggie", "Lisa"] |
        p instanceof ForwardReverse<Person, GrandpaToBartConfig>::ForwardNode
      )
    then test.pass("All forward nodes from Grandpa exist")
    else test.fail("Some forward nodes from Grandpa are missing")
  }
}

class TestGrandpaToBartForwardNodesDoNotContain extends Test, Case {
  override predicate run(Qnit test) {
    if
      exists(ForwardReverse<Person, GrandpaToBartConfig>::ForwardNode person |
        not person.getName() = ["Grandpa", "Homer", "Bart", "Maggie", "Lisa"]
      )
    then test.fail("Some unexpected forward nodes from Grandpa exist")
    else test.pass("No forward nodes from Grandpa exist that shouldn't")
  }
}

class TestGrandpaToBartReverseNodesContain extends Test, Case {
  override predicate run(Qnit test) {
    if
      forall(Person p | p.getName() = ["Grandpa", "Homer", "Bart"] |
        p instanceof ForwardReverse<Person, GrandpaToBartConfig>::ReverseNode
      )
    then test.pass("All reverse nodes from Grandpa exist")
    else test.fail("Some reverse nodes from Grandpa are missing")
  }
}

class TestGrandpaToBartReverseNodesDoNotContain extends Test, Case {
  override predicate run(Qnit test) {
    if
      exists(ForwardReverse<Person, GrandpaToBartConfig>::ReverseNode person |
        not person.getName() = ["Grandpa", "Homer", "Bart"]
      )
    then test.fail("Some unexpected reverse nodes from Grandpa exist")
    else test.pass("No reverse nodes from Grandpa exist that shouldn't")
  }
}