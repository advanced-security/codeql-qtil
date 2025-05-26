newtype TPerson =
  TSomePerson(string name, string mother, string father) {
    name = "Bart" and mother = "Marge" and father = "Homer"
    or
    name = "Lisa" and mother = "Marge" and father = "Homer"
    or
    name = "Maggie" and mother = "Marge" and father = "Homer"
    or
    name = "Homer" and mother = "Mona" and father = "Grandpa"
    or
    name = "Marge" and mother = "Jacquelin" and father = "Clancy"
    or
    name = "Patty" and mother = "Jacquelin" and father = "Clancy"
    or
    name = "Selma" and mother = "Jacquelin" and father = "Clancy"
    or
    name = "Clancy" and mother = "unknown" and father = "unknown"
    or
    name = "Jacquelin" and mother = "unknown" and father = "unknown"
    or
    name = "Mona" and mother = "unknown" and father = "unknown"
    or
    name = "Grandpa" and mother = "unknown" and father = "unknown"
    or
    name = "Rod" and mother = "Maude" and father = "Ned"
    or
    name = "Todd" and mother = "Maude" and father = "Ned"
    or
    name = "Ned" and mother = "unknown" and father = "unknown"
    or
    name = "Maude" and mother = "unknown" and father = "unknown"
  }

class Person extends TPerson {
  string getName() { this = TSomePerson(result, _, _) }

  Person getMother() {
    exists(string mother |
      this = TSomePerson(_, mother, _) and
      result.getName() = mother
    )
  }

  Person getFather() {
    exists(string father |
      this = TSomePerson(_, _, father) and
      result.getName() = father
    )
  }

  Person getAParent() { result = getMother() or result = getFather() }

  Person getAChild() { result.getAParent() = this }

  string toString() { result = getName() }
}
