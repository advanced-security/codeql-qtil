# qtil, a util library for CodeQL!

`qtil` is a utility library providing a wide array of features and conveniences for CodeQL. `qtil` is developed under the following two guiding principles:

- What would the `underscore.js` of CodeQL look like?
- No helper utility is too small to belong in `qtil`.

For examples of the former, `qtil` has conveniences such as string escaping. For examples of the latter, `qtil` has a class does nothing more than remove the need to write the declaration `final FinalType = Type` during parameterized module development.

Let's dive in!

## License 

This project is licensed under the terms of the MIT open source license. Please refer to [MIT](./LICENSE.txt) for the full terms.

CodeQL is subject to the [GithHub CodeQL Terms & Conditions](https://securitylab.github.com/tools/codeql/license).

## Background

This pack is just a collection of useful ideas, and no specific new features are currently planned.
If you have an idea on how to make writing CodeQL queries easier, please open an issue or a pull
request! And make sure to check back in on occasion to see what new features may have been added.

## Requirements 

To use this library, you should have the CodeQL CLI installed, and a license to use CodeQL on your
project (it is free for open source). For writing queries, we recommend using the
[VsCode CodeQL starter workspace](https://github.com/github/vscode-codeql-starter) and using the
CodeQL vscode extension.

Once a query development is up and running, you are ready to install `qtil` with the instructions
below.

### Installing and using qtil

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
import qtil.Qtil
class MyPair extends Qtil::Pair<...> { ... }

// or import what you need with no namepsace
import qtil.tuple.Pair
class MyPair extends Pair<...> { ... }
```

Most examples below assume that qtil is imported via the former method. Additionally, some qtilities
are language specific and should typically be accessed by `import qtil.lang`, e.g., `qtil.cpp`.

## Supported Languages

- C/C++: ✅ available as `import qtil.Cpp` in pack `GithubSecurityLab/qtil-cpp`
- C#: ✅ available as `import qtil.CSharp` in pack `GithubSecurityLab/qtil-csharp`
- Go: ✅ available as `import qtil.Go` in pack `GithubSecurityLab/qtil-go`
- Java: ✅ available as `import qtil.Java` in pack `GithubSecurityLab/qtil-java`
- JavaScript: ✅ available as `import qtil.Javascript` in pack `GithubSecurityLab/qtil-javascript`
- Python: ✅ available as `import qtil.Python` in pack `GithubSecurityLab/qtil-python`
- Ruby: ✅ available as `import qtil.Ruby` in pack `GithubSecurityLab/qtil-ruby`
- Rust: ❌ not yet available
- Swift: ✅ available as `import qtil.Swift` in pack `GithubSecurityLab/qtil-swift`
- QL: ❌ not yet available
- other languages: ❌ not supported by CodeQL.

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

**join(sep, ...)**: The first argument is used as a separator to join the remaining two to eight arguments.

This is not intended to replace the CodeQL `concat` aggregation, but rather, to be used in cases where aggregation is not desired.

```ql
// Result is "a,b,c"
select Qtil::join(",", "a", "b", "c")
```

**Escape**: Provides a set of modules for escaping and unescaping strings.

_CAUTION: Be careful in applying this escaping, which has not yet been thoroughly tested or validated, to a sensitive security context._

```ql
// Result is "foo\\\\bar\\nbaz", "foo\\bar\nbaz"
select Qtil::Escape<Qtil::defaultEscapeMap/2>::escape("foo\\bar\nbaz"),
    Qtil::Escape<Qtil::defaultEscapeMap/2>::unescape("foo\\\\bar\\nbaz")

// Result is "\"foo\\\"bar\\\\baz\"", "foo\"bar\\baz"
select Qtil::doubleQuoteWrap("foo\"bar\\baz"), Qtil::unescapeDoubleQuote("\"foo\\\"bar\\\\baz\"")

// CSV-like functionality: result is "foo\\,bar,baz\\\\qux", "foo,bar"
select Qtil::SeparatedEscape<Qtil::Chars::comma\0>::EscapeBackslash::of2("foo,bar", "baz\\qux"),
    Qtil::SeparatedEscape<Qtil::Chars::comma\0>::split("foo\\,bar,baz\\\\qux", Qtil::charOf("\\"), 0)
```

Escaping characters will carefully escape and unescape themselves. See documentation on escape maps
to handle cases like turning newlines into `\n`, etc.

**Char**: A subtype of `int` that holds a character code, with members such as `toUppercase()`,
`isLowercase()`, `isDigit()`, and `repeat(n)`.

```ql
// Selects "A", "B", "0"
from Qtil::Char c
where c.isStr("a") or c = charOf("b") or c = "0".codePointAt(0)
select b.toUppercase().toString()
```

See also the module `Chars` which defines standard nullary predicates that common characters, for
instance, `Qtil::Chars::dollar()` holds for the result `"$"`,`Qtil::Chars::a()` holds for `"a"`, and `Qtil::Chars::upperA()` holds for `"A"`.

### ASTs:

The following modules are usable by importing `qtil.lang`, for instance, `qtil.cpp`. However, the
implementations are shared across languages and are available in a do-it-yourself way as well.

**TwoOperands**: A module to simplify checks that an operator uses two distinct operands in a
certain manner.

```ql
import qtil.cpp

predicate intPlusConstant(BinaryExpr e) {
  exists(Qtil::TwoOperands<BinaryExpr>::Set set |
    set.getOperation() = e and
    set.someOperand().getType() instanceof IntType and
    set.otherOperand().isConstant()
  )
}

// Roughly equivalent to:
predicate intPlusConstantOld(BinaryExpr e) {
  exists(Expr a, Expr b |
    a = e.getAnOperand() and
    b = e.getAnOperand() and
    not a = b and
    a.getType() instanceof IntType and
    b.isConstant()
  )
}
```

### Query Formatting

**QlFormat** offers a way of formatting CodeQL query messages in a consistent way, with varying
numbers of placeholders, via a template-like syntax. This module is useful for writing more
user-friendly messages for certain types of queries, with a cleaner query implementation.

QlFormat can be used as follows:

```ql
import qtil.Cpp // or qtil.Java, etc.

// Define a problem predicate for a Locatable and a Qtil::Template:
predicate problem(Locatable elem, Qtil::Template template) {
  exists(Variable var, FunctionCall fc |
    var = elem and
    fc = var.getInitializer().getAChild*() and
    template = Qtil::tpl("Initializer of variable '{name}' calls {fn}.")
      .text("name", var.getName())
      .link("fn", fc.getFunction())
  )
}

// Import the Problem::Query module:
import Qtil::Problem<problem/2>::Query
```

The resulting query results will insert the variable name into the alert message, and insert a
placeholder link from the function name to the function itself.

This is particularly useful for when queries have different placeholders, or use placeholders in
different orders:

```ql
predicate problem(...) {
  ... // Previous case which has a placeholder for a function call
  or
  // Mixed with alternate case which has no placeholder:
  exists(Variable var |
    var = elem and
    not exists(FunctionCall fc | fc = var.getInitializer().getAChild*()) and
    template = Qtil::tpl("Variable '{name}' has no initializer.")
      .text("name", var.getName())
  )
}
```

This mixture of query results with different numbers of placeholders can be done without the
`QlFormat` features of qtil, but this approach can allow for much better readability and
maintainability of the query code.

**CustomPathProblem**: Allows users to create a query that has a custom trace through the source
code. For example, CodeQL data flow `PathGraph` shows dataflow through a program. However, by using
this module, query authors can trace any path -- a call graph, inheritance chain, transitive
file imports, etc.

To use the `CustomPathProblem` module, you must define a graph where each `Node` is a `Locatable`,
and the (directed) edges through that graph. Then by defining start nodes and end nodes, this
module will attempt to efficiently find paths to be reported as problems.

```ql
/**
 * Find paths through which `main.cpp` may transitively `#include` a banned file "banned_header.h".
 * ...
 * @kind path-problem
 * ...
 */
module MyPathProblem implements Qtil::CustomPathProblemConfigSig {
  class Node = IncludeDirective;
  predicate start(IncludeDirective n) { node.isInFile("main.cpp") }
  predicate end(IncludeDirective l) { node.includesFile("banned_header.h") }
  predicate edge(IncludeDirective a, IncludeDirective b) {
    b = a.getIncludedFile().getAnIncludeDirective()
  }
}

import CustomPathProblem<MyPathProblem>
from IncludeDirective start, IncludeDirective end
where problem(start, end) // This limits the query to the identified problematic paths.
select end, start, end, "Transitive inclusion of banned_header.h from main.cpp"
```

If you wish to perform a path search such as the above, but without reporting problems, you can
use the `Qtil::GraphPathSearch` module instead, which provides an efficient search algorithm
without producing a `@kind path-problem` query.

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

**Finitize**: A module to produce a finite type from an infinite type (such as `string`, `int`, or
`Qtil::InfInstance<string>::Type`, etc.) by providing predicate that constrains that infinite type.

```ql
class Person extends Qtil::UnderlyingString { ... }
predicate realPerson(Person p) { p in ["Marie Curie", "Albert Einstein", ...] }

class RealPerson = Qtil::Finitize<Person, realPerson/1>::Type;
```

Since infinite types should generally be avoided, but sometimes are necessary to enable certain
clean APIs, a common pattern is to have a stage where infinite types are collected, and then use
a constraint such as this one to finitize them at a later stage, to reduce the impact of using
infinite types in a query.

### Locations

Location types in CodeQL are different types across languages. To use these classes, import
`qtil.lang` (for instance, `qtil.cpp`).

**StringLocation**: A class that supports the codification of any location as a string, which the
CodeQL engine will use as a location when selected by a query. Also includes support to turn
existing locations into strings with `StringToLocation`, and support to finitize them at the point
where a query no longer must deal with an infinite set using the `Finitize` module.

**OptionalLocation**: A class that works much like `Option<Location>`, but that also implements the
`hasLocation()` predicate which the CodeQL engine expects of a location. Allows queries to select
placeholder locations that may or may not exist.

**NullLocation**: An empty location.

**Locatable**: A signature module that allows cross language support for locatable elements in a
query language, for instance C++ or Java.

This module, and `qtil` modules that depend on it, should already have preexisting
language-specific implementations in the `qtil` modules for each language, so that you don't have
to implement it yourself, for instance, in `qtil.Cpp` or `qtil.Java`. However, implementing this
module allows you to add qtil support for new languages.

### Graphs

**GraphPathSearch**: A module for efficiently finding paths in custom directed graphs from a set of
starting nodes to a set of ending nodes. For performance, this module uses a pattern called "forward
reverse pruning," a pattern widely used in the CodeQL dataflow libraries.

```ql
module Config implement Qtil::GraphPathSearchSig<Person> {
  predicate start(Person p) { p.checkSomething() }
  predicate end(Person p) { p.checkSomethingElse() }
  predicate edge(Person a, Person b) { a.getParent() = b }
}

from Person a, Person b
where Qtil::GraphPathSearch<Person, Config>::hasPath(a, b)
select a, b
```

This module takes a set of starting points, ending points, and edges in a graph, and the predicate
`hasPath` reveals which end nodes are reachable from the given start nodes.

For displaying the discovered paths to users, see the `CustomPathProblem` module above.

### Testing with Qnit

While codeql's `test run` subcommand is a great way to test queries, it can be better in some cases
to write a more traditional unit test for CodeQL libraries. Rather than selecting a set of outputs
in a query and then inspecting that the query result (in the `.expectations` file) makes sense, qtil
provides a library called "Qnit" for writing direct test cases with expectations, so that there's
better cohesion between a test case and its expected output.

To use Qnit, import the `qtil.testing.Qnit` module, and create a test class that extends
`Test, Case`. Inside the class override the `run(Qnit test)` member predicate, and conditionally
call `test.pass(name)` or `test.fail(description)` as appropriate.

```ql
import qtil.testing.Qnit

class MyTest extends Test, Case {
  override predicate run(Qnit test) {
    if 1 = 1
    then test.pass("1 equals 1")
    else test.fail("1 does not equal 1")
  }
}
```

You may define as many test classes as you like, and they will all be run when you run the command
`codeql test run $TESTDIR`. If all tests pass, the test will output "{n} tests passed." If any test
fails, the result of each test will be selected (including failing and passing tests).

For correct use, ensure that each test class passes with a unique name, and that tests always hold
for some result, whether its a pass or a fail.

```
  override predicate run(Qnit test) {
    if 1 = 1
    then test.pass("1 equals 1") // Ensure this is unique to the test
    else none() // This would be valid CodeQL, but it would not fail.
  }
```

It is particularly risky, albeit useful, to write `test.fail("..." + somePredicate().toString())`,
as this test will **not** fail if `somePredicate()` does not hold. This is a risky pattern, and so
should only be applied with some caution.

See the README in the `qtil.testing` directory for more information on how to use Qnit.

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
 - `Qtil::Binary<int, string>::Ret<int>::pred/2`: A predicate with two parameters, an int and a
      string, and an int result.
 - etc., for `Ternary`, `Quaternary`, and up to `Senary` (six parameter) predicates.

**SignatureTypes.qll** contains various baseline signature types to aid in writing correct
parameterized modules, as well as a utility to create a signature type from any existing type.

```ql
// A module that accepts any type that is a subclass of `Expr`:
module MyModule<Qtil::Signature<Expr>::Type ExprType> { ... }>

// A module that accepts any pair of finite types:
module MyModule<Qtil::FiniteType A, Qtil::FiniteType B> { ... }
```

 - `Qtil::Signature<T>::Type`: A module that allows you to create a signature type from any existing
      type `T`. This is useful for parameterized modules that need to accept a type as a parameter.
 - `Qtil::FiniteType`: Any finite type. Supports `newtype`s. No support for primitive types.
 - `Qtil::FiniteStringableType`: Any finite class (has a `toString()` member). No support for
      `newtype`s or primitive types.
 - `Qtil::InfSignature<T>::Type`: Like `Qtil::Signature<T>::Type`, but allows you to create a signature
      type from any existing infinite type `T`.
 - `Qtil::InfiniteType`: Any finite or infinite type, with `bindingset[this]`. Supports
      `newtype`s and primitives.
 - `Qtil::InfiniteStringableType`: Any finite or infinite class, with `bindingset[this]`,
      Supports primitives. Does not support `newtype`.
 - `Qtil::StringlikeType`: Any type that extends or is an instanceof `string`.

## Contributing

This project welcomes contributions and suggestions. See [Contributing](CONTRIBUTING.md) for more
details.

## Support

This project is intended to be useful and help the CodeQL community. That said, we may not have
time and resources to support every feature request or bug report, and when support is offered it
may be subject to some delay.

If you have a feature request or bug report that is of significant importance to you, please do make
its importance and urgency clear in your issue or pull request, to increase the likelihood of
receiving timely support amidst our busy jobs here at GitHub!

## Maintainers

This project is currently maintained by @michaelrfairhurst with help from other CodeQL/security
experts at GitHub.
