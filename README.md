# qtil, a util library for CodeQL!

`qtil` is a utility library providing a wide array of features and conveniences for CodeQL. `qtil` is developed under the following two guiding principles:

- What would the `underscore.js` of CodeQL look like?
- No helper utility is too small to belong in `qtil`.

For examples of the former, `qtil` has conveniences such as string escaping. For examples of the latter, `qtil` has a class which removes the need to write the declaration `final FinalType = Type` during parameterized module development.

Let's dive in!

## Installing and using qtil

To install `qtil` for CodeQL development, add the following dependency to the `qlpack.yml` for your project:

```yaml
...
dependencies:
  ...
  GithubSecurityLab/qtil: "*"
```

To use `qtil`, you can either import everything at once, or pick what you need:

```ql
// Import everything under the namespace Qtil
import qtil
class MyPair extends Qtil::Pair<...> { ... }

// or import what you need with no namepsace
import qtil.tuple.Pair
class MyPair extends Pair<...> { ... }
```

All examples below use the former.

## Features

### Pairs, Tuples, and Products, oh my!

**Pair**: A class to hold some set of paired values of two distinct types.

```ql
predicate nameAge(string name, int age) {
  exists(Person p | name = p.getName() and age = p.getAge())
}

// Selects name, age for all people:
from Qtil::Pair<string, int, nameAge/2>::Pair pair
select pair.getFirst(), pair.getSecond()
```

**Tuple**: Like a pair, but supports more than two columns.

```ql
predicate nameAgeCity(string name, int age, City city) {
  exists(Person p | name = p.getName() and age = p.getAge() and city = p.getCity())
}

// Selects name, age, city for all people:
from Qtil::Tuple3<string, int, City, nameAgeCity/3>::Tuple tuple
select tuple.getFirst(), tuple.getSecond(), tuple.getThird()
```

**Product**: A class to hold all combinations of values of two distinct types.

```ql
// Selects all combinations of people and cities
from Qtil::Product<Person, City>::Product product
select product.getFirst(), product.getSecond()
```

### Lists

**CondensedList**: Takes orderable data, and turns it into a linked list of values for ease of traversal.

```ql
VariableListConfig implements Qtil::CondenseListConfigSig {
  class Division = File;
  class Item = Variable;

  int getSparseIndex(File file, Variable variable) {
    variable.getFile() = file and result = variable.getLine()
  }
}

import Condense<VariableListConfig>::ListItem

// For each file, selects all variables, the variable before it and the variable after it.
from ListItem entry
select entry.getDivision(), entry.getItem(),
    entry.getPrev().getItem(), entry.getNext().getItem()
```

### Strings

### Query Formatting

### Inheritance

### Locations

### Performance

### Testing

### Parameterization