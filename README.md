# qtil, a util library for CodeQL!

`qtil` is a utility library providing a wide array of features and conveniences for CodeQL. `qtil` is developed under the following two guiding principles:

- What would the `underscore.js` of CodeQL look like?
- No helper utility is too small to belong in `qtil`.

For examples of the former, `qtil` has conveniences such as string escaping. For examples of the latter, `qtil` has a class does nothing more than remove the need to write the declaration `final FinalType = Type` during parameterized module development.

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

**Ordered**: Takes orderable data, and automatically adds `getPrevious()`, `getNext()` predicate members for ease of traversal.

_Note: the `getOrder()` predicate should not have duplicates._

```ql
class AgeOrderedPerson extends Qtil::Ordered<Person>::Type {
  override int getOrder() { result = getAge() }
}

// Selects people, along with the next youngest and next oldest.
from AgeOrderedPerson p
select p.getName(), p.getPrevious().getName(), p.getNext().getName()
```

This module is also possible to use with groupings, in order to segment the data into different lists.

_Note: the `getOrder()` predicate should not have duplicates for items in the same group._

```ql
class AgeOrderedCityPerson extends Qtil::Ordered<Person>::GroupBy<City>::Type {
  override int getOrder() { result = getAge() }
  override int getGroup() { result = getCity() }
}

// Selects people, along with the next youngest and next oldest in the same city.
from AgeOrderedCityPerson p
select p.getName(), p.getCity(), p.getPrevious.getName(), p.getNext.getName()
```

**CondensedList**: Like the `Ordered` class, but creates a separate `ListEntry` type rather than
requiring you to extend the underlying type.

```ql
int getAge(Person p) { result = p.getAge() }
class GlobalListEntry = Qtil::CondenseList<Person, getAge/1>::Global::ListEntry

// Selects people, and the next oldest person
from GlobalListEntry listEntry
select listEntry.getItem().getName(), listEntry.getNext().getItem().getName()

// Optional grouping to create separate lists per city:
City getCity(Person p) { result = p.getCity() }
class CityListEntry = Qtil::CondenseList<Person, getAge/1>::GroupBy<City, getCity/1>::ListEntry

// Selects people, and the next oldest person, for a given city
from CityListEntry listEntry
select listEntry.getItem().getName(), listEntry.getDivision().getName(),
listEntry.getNext().getItem().getName()
```

### Strings

### Query Formatting

### Inheritance

### Locations

### Performance

### Testing

### Parameterization