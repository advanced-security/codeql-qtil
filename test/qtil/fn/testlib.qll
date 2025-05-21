predicate one(int i) { i = 1 }

predicate oneToThree(int i) { i in [1, 2, 3] }

int getOne() { result = 1 }

int getOneToThree() { result in [1, 2, 3] }

bindingset[i]
int addOne(int i) { result = i + 1 }

bindingset[a, b]
int add(int a, int b) { result = a + b }

bindingset[i]
int double(int i) { result = i * 2 }

bindingset[a, b]
int multiply(int a, int b) { result = a * b }

bindingset[i]
predicate isEven(int i) { i % 2 = 0 }

bindingset[i]
predicate isOdd(int i) { i % 2 = 1 }

bindingset[str]
string toUpperCase(string str) {
  result = str.toUpperCase()
}

bindingset[a, b]
string spaceJoin(string a, string b) {
  result = a + " " + b
}

bindingset[a, b] 
string rspaceJoin(string a, string b) {
  result = b + " " + a
}

bindingset[i]
string stringifyInt(int i) { result = i.toString() }

bindingset[str]
predicate isOneChar(string str) {
  str.length() = 1
}

predicate person(string firstName, string lastName) {
  firstName = "Marie" and lastName = "Curie"
  or
  firstName = "Albert" and lastName = "Einstein"
  or
  firstName = "Ada" and lastName = "Lovelace"
  or
  firstName = "Alan" and lastName = "Turing"
  or
  firstName = "Grace" and lastName = "Hopper"
}

string getElementNamedAfter(string firstName, string lastName) {
  firstName = "Marie" and lastName = "Curie" and result = "Curium"
  or
  firstName = "Albert" and lastName = "Einstein" and result = "Einsteinium"
}

string getInitials(string firstName, string lastName) {
  person(firstName, lastName) and
  result = firstName.charAt(0).toUpperCase() + lastName.charAt(0).toUpperCase()
}

string mightHaveLastName(string firstName) {
    person(firstName, result)
}

string mightHaveFirstName(string lastName) {
    person(result, lastName)
}

predicate personInitialed(string firstName, string lastName, string initials) {
  getInitials(firstName, lastName) = initials
}