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

**Instance**: A module to make `instanceof` inheritance easier in CodeQL, by writing
`class Foo extends Qtil::Instanceof<Bar>::Type`, which automatically adds `toString()` and a
member `Bar inst()` to access the member predicates on the `Bar` parent class.

In CodeQL, instance inheritance is available as `class Foo instanceof Bar`. In this style of
inheritance, a `Foo` matches all `Bar`s, but inherits none of the members. This is a useful
concept, but in practice often requires a boilerplate `toString()` member and casts:

```ql
class Foo extends Qtil::Instance<Bar>::Type {
  predicate qux() { inst().check() }
}

// is (roughly) equivalent to:
class Foo instanceof Bar {
  predicate qux() { this.(Bar).check() }
  string toString() { result = this.(Bar).toString() }
}
```

There is also a module `InfInstance` which handles infinite types. Ordinarily, `Instance<T>`
requires a finite type (standard CodeQL class type). However, infinite types (such as
primitives) require special care, which `InfInstance` handles correctly, allowing
`bindingset[this] class OpaqueIntType extends Qtil::InfInstance<int>::Type {}`. See also `UnderlyingString`.

**Final**: A module to avoid creating final type alias declarations, which are required in
some contexts, such as parameterized modules. Simply extend `Qtil::Final<T>::Type` instead of
declaring a final alias type.

```
// Use CodeQL "final" extension:
class MyFoo1 extends Qtil::Final<Foo>::Type { ... }

// So that you don't need to create a final alias declaration:
final class FinalFoo = Foo;
class MyFoo2 extends FinalFoo { ... }
```

**UnderlyingString**: A class to support inheriting from string in order to create custom
infinite types with a hidden string representation.

```ql
class Person extends Qtil::UnderlyingString {
  string getFirstName() { result = str().split(" ", 0) }
  string getLastName() { result = str().split(" ", 1) }
}
```

_Note: this class is effectively the same as `Qtil::InfInstance<string>::Type`, but uses the member `str()` to get the underlying string instead of the member `inst()`._

### Locations

### Performance

**ForwardReverse**: A module that implements a performant CodeQL graph search pattern called
"forward reverse pruning," a pattern widely used in the CodeQL dataflow libraries.

```ql
module Config implement Qtil::ForwardReverseSig<Person> {
  predicate start(Person p) { p.checkSomething() }
  predicate end(Person p) { p.checkSomethingElse() }
  predicate edge(Person a, Person b) { a.getParent() = b }
}

from Person a, Person b
where Qtil::ForwardReverse<Person, Config>::hasPath(a, b)
select a, b
```

This pattern takes a set of starting points, ending points, and edges in a graph. From the starting
nodes it scans forward along edges to find all reachable nodes. This is fast because it is a unary,
rather than binary, operation. These are called "forward nodes." Then, the from the set of ending
points that are also forward nodes (reachable from the starting points), we reverse the process to
find all forward nodes that reach end nodes. This is also fast because it is another unary
operation. These are called "reverse nodes." As a last step, this smaller set of reverse nodes is
far more efficient to search for paths connecting starting points to ending points.

The performance of this module depends heavily on its configuration predicates.

This module may not fit your use case exactly as is. In this case, this module can be an example
performance optimization to draw inspiration from as you create a solution that fits your specific
needs.

### Testing

### Parameterization

**SignaturePredicates.qll** defines modules for creating signature predicates without separate
signature predicate declarations.

Rather than writing:

```ql
signature predicate binary(int a, int b);

module MyModule<binary/2 binop> { ... }
```

This module allows you to write:

```
module MyModule<Qtil::Binary<int, int>::pred/2 binop> { ... }
```

This is particularly useful when you otherwise would have to declare a parameterized module to
declare your signature to your own parameterized module:

```ql
// Simply write:
module MyModule<Foo A, Bar B, Qtil::Binary<A, B>::pred/2 binop> { ... }

// Instead of:
module SignatureModule<Foo A, Foo B> {
  signature predicate binary(A, B);
}
module MyModule<Foo A, Foo B, SignatureModule<A, B>::binary/2 binary> { ... }
```

The declared predicate signatures look as follows:
 - `Qtil::Nullary::pred/0`: A predicate with no parameters and no result.
 - `Qtil::Nullary::Ret<int>::pred/0`: A predicate with no parameters and an `int` result.
 - `Qtil::Unary<int>::pred/1`: A predicate with one int parameter and no result.
 - `Qtil::Unary<int>::Ret<string>::pred/1`: A predicate with one int parameter and a string result.
 - `Qtil::Binary<int, string>::pred/2`: A predicate with two parameters, an int and a string, and no
      result.
 - `Binary<int, string>::Ret<int>::pred/2`: A predicate with two parameters, an int and a string,
      and an int result.
 - etc., for `Ternary`, `Quaternary`, and up to `Quinary` predicates.

**SignatureTypes.qll** contains various baseline signature types to aid in writing correct
parameterized modules:

```ql
module MyModule<Qtil::FiniteType A, Qtil::FiniteType B> { ... }
```

 - `Qtil::FiniteType`: Any finite type. Supports `newtype`s. No support for primitive types.
 - `Qtil::FiniteStringableType`: Any finite class (has a `toString()` member). No support for
      `newtype`s or primitive types.
 - `Qtil::InfiniteType`: Any finite or infinite type, with `bindingset[this]`. Supports
      `newtype`s and primitives.
 - `Qtil::InfiniteStringableType`: Any finite or infinite class, with `bindingset[this]`,
      Supports primitives. Does not support `newtype`.
