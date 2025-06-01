import qtil.testing.Qnit
import qtil.graph.GraphPathStateSearch
import Family

bindingset[relation] bindingset[result]
string parentString(string relation) {
  if relation = "child" then result = "parent"
  else if relation = "parent" then result = "grandparent"
  else result = "great " + relation
}

bindingset[relation] bindingset[result]
string childString(string relation) {
  if relation = "parent" then result = "child"
  else if relation = "child" then result = "grandchild"
  else result = "great " + relation
}

module BartToGrandpaConfig implements GraphPathStateSearchSig<Person> {
  class State = string;

  predicate start(Person p, string state) { p.getName() = "Bart" and state = "child" }

  predicate end(Person p, string state) { p.getName() = "Grandpa" and state = "grandparent" }

  bindingset[s2] bindingset[s1]
  predicate edge(Person p1, string s1, Person p2, string s2) {
    p2 = p1.getAParent() and
    s2 = parentString(s1)
  }
}

module GrandpaToBartConfig implements GraphPathStateSearchSig<Person> {
  class State = string;

  predicate start(Person p, string state) { p.getName() = "Grandpa" and state = "parent" }

  predicate end(Person p, string state) { p.getName() = "Bart" and state = "grandchild" }

  bindingset[s2] bindingset[s1]
  predicate edge(Person p1, State s1, Person p2, State s2) { p2 = p1.getAChild() and 
    s2 = childString(s1) }
}

class TestBartForwardNodesContain extends Test, Case {
  override predicate run(Qnit test) {
    if
      forall(Person p |
        p.getName() = ["Bart", "Homer", "Marge", "Clancy", "Jacquelin", "Mona", "Grandpa"]
      |
        p instanceof GraphPathStateSearch<Person, BartToGrandpaConfig>::ForwardNode
      )
    then test.pass("All forward nodes from Bart exist")
    else test.fail("Some forward nodes from Bart are missing")
  }
}

class TestBartForwardNodesState extends Test, Case {
  override predicate run(Qnit test) {
    if exists(GraphPathStateSearch<Person, BartToGrandpaConfig>::ForwardNode fwd |
        fwd.getName() = "Bart" and
        fwd.getState() = "child"
    ) and exists(GraphPathStateSearch<Person, BartToGrandpaConfig>::ForwardNode fwd |
        fwd.getName() = "Marge" and
        fwd.getState() = "parent"
    ) and exists(GraphPathStateSearch<Person, BartToGrandpaConfig>::ForwardNode fwd |
        fwd.getName() = "Homer" and
        fwd.getState() = "parent"
    ) and exists(GraphPathStateSearch<Person, BartToGrandpaConfig>::ForwardNode fwd |
        fwd.getName() = "Clancy" and
        fwd.getState() = "grandparent"
    ) and exists(GraphPathStateSearch<Person, BartToGrandpaConfig>::ForwardNode fwd |
        fwd.getName() = "Jacquelin" and
        fwd.getState() = "grandparent"
    ) and exists(GraphPathStateSearch<Person, BartToGrandpaConfig>::ForwardNode fwd |
        fwd.getName() = "Mona" and
        fwd.getState() = "grandparent"
    ) and exists(GraphPathStateSearch<Person, BartToGrandpaConfig>::ForwardNode fwd |
        fwd.getName() = "Grandpa" and
        fwd.getState() = "grandparent"
    )
    then test.pass("All forward nodes from Bart have the correct state")
    else test.fail("Some forward nodes from Bart have incorrect state")
  }
}


class TestBartForwardNodesDoNotContain extends Test, Case {
  override predicate run(Qnit test) {
    if
      exists(GraphPathStateSearch<Person, BartToGrandpaConfig>::ForwardNode person |
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
        p instanceof GraphPathStateSearch<Person, BartToGrandpaConfig>::ReverseNode
      )
    then test.pass("All reverse nodes from Bart exist")
    else test.fail("Some reverse nodes from Bart are missing")
  }
}

class TestBartReverseNodesState extends Test, Case {
  override predicate run(Qnit test) {
    if
       exists(GraphPathStateSearch<Person, BartToGrandpaConfig>::ReverseNode rev |
        rev.getName() = "Bart" and
        rev.getState() = "child"
    ) and exists(GraphPathStateSearch<Person, BartToGrandpaConfig>::ReverseNode rev |
        rev.getName() = "Homer" and
        rev.getState() = "parent"
    ) and exists(GraphPathStateSearch<Person, BartToGrandpaConfig>::ReverseNode rev |
        rev.getName() = "Grandpa" and
        rev.getState() = "grandparent"
    )
    then test.pass("All reverse nodes from Bart have the correct state")
    else test.fail("Some reverse nodes from Bart have incorrect state")
  }
}

class TestBartReverseNodesDoNotContain extends Test, Case {
  override predicate run(Qnit test) {
    if
      exists(GraphPathStateSearch<Person, BartToGrandpaConfig>::ReverseNode person |
        not person.getName() = ["Bart", "Homer", "Grandpa"]
      )
    then test.fail("Some unexpected reverse nodes from Bart exist")
    else test.pass("No reverse nodes from Bart exist that shouldn't")
  }
}

class TestBartToGrandpaHasPath extends Test, Case {
  override predicate run(Qnit test) {
    if exists(Person bart, Person grandpa |
        bart.getName() = "Bart" and
        grandpa.getName() = "Grandpa" and
      GraphPathStateSearch<Person, BartToGrandpaConfig>::hasPath(bart, "child", grandpa, "grandparent")
    )
    then test.pass("Path from Bart to Grandpa exists")
    else test.fail("Path from Bart to Grandpa does not exist")
  }
}

class TestGrandpaToBartForwardNodesContain extends Test, Case {
  override predicate run(Qnit test) {
    if
      forall(Person p | p.getName() = ["Grandpa", "Homer", "Bart", "Maggie", "Lisa"] |
        p instanceof GraphPathStateSearch<Person, GrandpaToBartConfig>::ForwardNode
      )
    then test.pass("All forward nodes from Grandpa exist")
    else test.fail("Some forward nodes from Grandpa are missing")
  }
}

class TestGrandpaToBartForwardNodesState extends Test, Case {
  override predicate run(Qnit test) {
    if exists(GraphPathStateSearch<Person, GrandpaToBartConfig>::ForwardNode fwd |
        fwd.getName() = "Grandpa" and
        fwd.getState() = "parent"
    ) and exists(GraphPathStateSearch<Person, GrandpaToBartConfig>::ForwardNode fwd |
        fwd.getName() = "Homer" and
        fwd.getState() = "child"
    ) and exists(GraphPathStateSearch<Person, GrandpaToBartConfig>::ForwardNode fwd |
        fwd.getName() = "Bart" and
        fwd.getState() = "grandchild"
    ) and exists(GraphPathStateSearch<Person, GrandpaToBartConfig>::ForwardNode fwd |
        fwd.getName() = "Maggie" and
        fwd.getState() = "grandchild"
    ) and exists(GraphPathStateSearch<Person, GrandpaToBartConfig>::ForwardNode fwd |
        fwd.getName() = "Lisa" and
        fwd.getState() = "grandchild"
    )
    then test.pass("All forward nodes from Grandpa have the correct state")
    else test.fail("Some forward nodes from Grandpa have incorrect state")
  }
}

class TestGrandpaToBartForwardNodesDoNotContain extends Test, Case {
  override predicate run(Qnit test) {
    if
      exists(GraphPathStateSearch<Person, GrandpaToBartConfig>::ForwardNode person |
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
        p instanceof GraphPathStateSearch<Person, GrandpaToBartConfig>::ReverseNode
      )
    then test.pass("All reverse nodes from Grandpa exist")
    else test.fail("Some reverse nodes from Grandpa are missing")
  }
}

class TestGrandpaToBartReverseNodesState extends Test, Case {
  override predicate run(Qnit test) {
    if exists(GraphPathStateSearch<Person, GrandpaToBartConfig>::ReverseNode rev |
        rev.getName() = "Grandpa" and
        rev.getState() = "parent"
    ) and exists(GraphPathStateSearch<Person, GrandpaToBartConfig>::ReverseNode rev |
        rev.getName() = "Homer" and
        rev.getState() = "child"
    ) and exists(GraphPathStateSearch<Person, GrandpaToBartConfig>::ReverseNode rev |
        rev.getName() = "Bart" and
        rev.getState() = "grandchild"
    )
    then test.pass("All reverse nodes from Grandpa have the correct state")
    else test.fail("Some reverse nodes from Grandpa have incorrect state")
  }
}

class TestGrandpaToBartReverseNodesDoNotContain extends Test, Case {
  override predicate run(Qnit test) {
    if
      exists(GraphPathStateSearch<Person, GrandpaToBartConfig>::ReverseNode person |
        not person.getName() = ["Grandpa", "Homer", "Bart"]
      )
    then test.fail("Some unexpected reverse nodes from Grandpa exist")
    else test.pass("No reverse nodes from Grandpa exist that shouldn't")
  }
}

class TestGrandpaToBartHasPath extends Test, Case {
  override predicate run(Qnit test) {
    if exists(Person grandpa, Person bart |
        grandpa.getName() = "Grandpa" and
        bart.getName() = "Bart" and
      GraphPathStateSearch<Person, GrandpaToBartConfig>::hasPath(grandpa, "parent", bart, "grandchild")
    )
    then test.pass("Path from Grandpa to Bart exists")
    else test.fail("Path from Grandpa to Bart does not exist")
  }
}