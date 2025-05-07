/**
 * A module for building CSV-like strings, or types that extend string, from a custom separator
 * and/or custom types.
 *
 * Each module provides predicates `of2(...)` to `of8(...)` for creating a list of up to 8 items,
 * which take either a string or a custom type as input to be converted to a string. The result will
 * either be a string, or a custom type that extends string.
 *
 * The following modules are provided:
 * - `ListBuilder<separator>`: Predicates to build a string from a list of string-valued arguments
 *     separated by a custom separator.
 * - `ListBuilderOf<separator, T, toString>`: Predicates to build a string from a list of arguments
 *     of a custom type `T`, converted to strings via the `toString` predicate, using a custom
 *     separator.
 * - `TypedListBuilder<separator, S>`: Predicates to build a string from a list of string-valued
 *     arguments separated by a custom separator, where the result is a custom type `S` that extends
 *     string.
 * - `TypedListBuilderOf<separator, S, T, toString>`: Predicates to build a string from a list of
 *     arguments of a custom type `T`, converted to strings via the `toString` predicate, using a
 *     custom separator, where the result is a custom type `S` that extends string.
 *
 * A recommended use of this module is by using the predicates defined in the `qtil.strings.Chars`
 * module, which defines predicates such as `Char::comma/0`, `Char::colon/0`, `Char::at/0`, etc.
 */

import qtil.strings.Char
import qtil.strings.Join
import qtil.parameterization.SignatureTypes
import qtil.parameterization.SignaturePredicates

/**
 * A module that declares predicates `of2(...)` to `of8(...)` for building a string from a list of
 * string-valued arguments separated by a custom separator.
 *
 * To build a type that extends string, use `TypedListBuilder<separator, T>`. To build a string from
 * non-string arguments, use `ListBuilderOf<separator, T, toString>`. To build a type that extends
 * string from non-string arguments, use `TypedListBuilderOf<separator, T, S, toString>`.
 *
 * Example usage:
 *
 * ```ql
 * ListBuilder<Separator::comma/0>::of2("foo", "bar") // returns "foo,bar"
 * ```
 */
module ListBuilder<Nullary::Ret<Char>::pred/0 separator> {
  // We do not need to redefine the predicates `of2(...)` to `of8(...)` here, we can use the module
  // `TypedListBuilder<separator, T>` to do that, where `T` is a string.
  import TypedListBuilder<separator/0, string>
}

/**
 * A module that declares predicates `of2(...)` to `of8(...)` for building a string from a list of
 * arguments of a custom type `T`, converted to strings via the `toString` predicate, using a
 * custom separator.
 *
 * The `toString` predicate should be a unary predicate that takes an argument of type `T` and
 * returns a string. It should be declared with `bindingset[result]` and `bindingset[arg]`, to have
 * two way binding between the input and output, allowing conversion and deconversion via one
 * predicate.
 *
 * If you do not need to build strings from non-string arguments, you can simply use the module
 * `ListBuilder<separator>`. To build a type that extends string from a list of non-string
 * arguments, use `TypedListBuilderOf<separator, T, S, toString>`. You may also use the module
 * `TypedListBuilder<separator, T>` to build a type that extends string from a list of string-valued
 * arguments.
 *
 * Example usage:
 *
 * ```ql
 * bindingset[result] bindingset[arg]
 * string toString(int arg) {
 *   result = arg.toString() and
 *   result.toInt() = arg
 * }
 *
 * // selects "1,2"
 * select ListBuilder<Separator::comma/0, int, toString/1>::of2(1, 2)
 * ```
 */
module ListBuilderOf<
  Nullary::Ret<Char>::pred/0 separator, InfiniteType T, Unary<T>::Ret<string>::bindInput/1 toString>
{
  // We do not need to redefine the predicates `of2(...)` to `of8(...)` here, we can use the module
  // `TypedListBuilderOf<separator, S, T, toString>` to do that, where `S` is a string, and `T` and
  // `toString` are unchanged.
  import TypedListBuilderOf<separator/0, string, T, toString/1>
}

/**
 * A module that declares predicates `of2(...)` to `of8(...)` for building a type that extends
 * string from a list of string-valued arguments separated by a custom separator.
 *
 * To build a string (rather than a type that extends string) from a list of string-valued
 * arguments, use `ListBuilder<separator>`. To build a string from non-string arguments, use
 * `ListBuilderOf<separator, T, toString>`. To build a type that extends string from non-string
 * arguments, use `TypedListBuilderOf<separator, T, S, toString>`.
 *
 * Example usage:
 *
 * ```ql
 * bindingset[this]
 * class MyString extends string {
 *   bindingset[this]
 *   string reverse() {
 *     result = concat(string c, int idx | c = this.charAt(idx) | c order by idx desc)
 *   }
 * }
 *
 * // Selects "rab,oof".
 * // Resulting type is of `MyString`, which allows for the `.reverse()` member predicate here.
 * select TypedListBuilder<Separator::comma/0, MyString>
 *     ::of2("foo", "bar")
 *     .reverse()
 */
module TypedListBuilder<Nullary::Ret<Char>::pred/0 separator, StringlikeType S> {
  /**
   * A toString function from string to string with two way binding (merely the identity function).
   *
   * This predicate is declared so that this module may simply import the predicates `of2(...)` to
   * `of8(...)` from the module `TypedListBuilderOf<separator, S, string, toString>`, where the
   * `toString` predicate is this identity function.
   */
  bindingset[result]
  bindingset[s]
  pragma[inline]
  private string identity(string s) { result = s }

  // Import predicates `of2(...)` to `of8(...)` from the module
  // `TypedListBuilderOf<separator, S, string, identity>`, where the `toString` predicate is the
  // identity function.
  import TypedListBuilderOf<separator/0, S, string, identity/1>
}

/**
 * A module that declares predicates `of2(...)` to `of8(...)` for building a type that extends
 * string from a list of arguments of a custom type `T`, converted to strings via the `toString`
 * predicate, using a custom separator.
 *
 * The `toString` predicate should be a unary predicate that takes an argument of type `T` and
 * returns a string. It should be declared with `bindingset[result]` and `bindingset[arg]`, to have
 * two way binding between the input and output, allowing conversion and deconversion via one
 * predicate.
 *
 * If you do not need to build types that extend string from non-string arguments, you can simply
 * use the module `TypedListBuilder<separator, S>`. To build a string from non-string arguments, use
 * `ListBuilderOf<separator, T, toString>`. You may also use the module
 * `ListBuilder<separator>` to build a string from a list of string-valued arguments.
 *
 * Example usage:
 *
 * ```ql
 * bindingset[this]
 * class MyString extends string {
 *   bindingset[this]
 *   string reverse() {
 *     result = concat(string c, int idx | c = this.charAt(idx) | c order by idx desc)
 *   }
 * }
 *
 * bindingset[result] bindingset[arg]
 * string toString(MyString arg) {
 *   result = arg.toString() and
 *   result.toString() = arg
 * }
 *
 * // Selects "43,21".
 * // Resulting type is of `MyString`, which allows for the `.reverse()` member predicate here.
 * select TypedListBuilderOf<Separator::comma/0, MyString, int, toString/1>
 *     ::of2(12, 34)
 *    .reverse()
 * ```
 */
module TypedListBuilderOf<
  Nullary::Ret<Char>::pred/0 separator, StringlikeType S, InfiniteType T,
  Unary<T>::Ret<string>::bindInput/1 toString>
{
  /* The separator is a character, so we need to convert it to a string. */
  pragma[inline]
  private string sepStr() { result = separator().toString() }

  /**
   * Produces a CSV-like list of 1 item, cast to type `S` which extends string, using the custom
   * separator.
   *
   * The predicate `toString` is used on the arguments to ensure that they are converted to strings
   * before being joined together.
   */
  bindingset[v1]
  S of1(T v1) { result = toString(v1) }

  /**
   * Produces a CSV-like list of 2 items, cast to type `S` which extends string, using the custom
   * separator.
   *
   * The predicate `toString` is used on the arguments to ensure that they are converted to strings
   * before being joined together.
   */
  bindingset[v1, v2]
  S of2(T v1, T v2) { result = join(sepStr(), toString(v1), toString(v2)) }

  /**
   * Produces a CSV-like list of 3 items, cast to type `S` which extends string, using the custom
   * separator.
   *
   * The predicate `toString` is used on the arguments to ensure that they are converted to strings
   * before being joined together.
   */
  bindingset[v1, v2, v3]
  S of3(T v1, T v2, T v3) { result = join(sepStr(), toString(v1), toString(v2), toString(v3)) }

  /**
   * Produces a CSV-like list of 4 items, cast to type `S` which extends string, using the custom
   * separator.
   *
   * The predicate `toString` is used on the arguments to ensure that they are converted to strings
   * before being joined together.
   */
  bindingset[v1, v2, v3, v4]
  S of4(T v1, T v2, T v3, T v4) {
    result = join(sepStr(), toString(v1), toString(v2), toString(v3), toString(v4))
  }

  /**
   * Produces a CSV-like list of 5 items, cast to type `S` which extends string, using the custom
   * separator.
   *
   * The predicate `toString` is used on the arguments to ensure that they are converted to strings
   * before being joined together.
   */
  bindingset[v1, v2, v3, v4, v5]
  S of5(T v1, T v2, T v3, T v4, T v5) {
    result = join(sepStr(), toString(v1), toString(v2), toString(v3), toString(v4), toString(v5))
  }

  /**
   * Produces a CSV-like list of 6 items, cast to type `S` which extends string, using the custom
   * separator.
   *
   * The predicate `toString` is used on the arguments to ensure that they are converted to strings
   * before being joined together.
   */
  bindingset[v1, v2, v3, v4, v5, v6]
  S of6(T v1, T v2, T v3, T v4, T v5, T v6) {
    result =
      join(sepStr(), toString(v1), toString(v2), toString(v3), toString(v4), toString(v5),
        toString(v6))
  }

  /**
   * Produces a CSV-like list of 7 items, cast to type `S` which extends string, using the custom
   * separator.
   *
   * The predicate `toString` is used on the arguments to ensure that they are converted to strings
   * before being joined together.
   */
  bindingset[v1, v2, v3, v4, v5, v6, v7]
  S of7(T v1, T v2, T v3, T v4, T v5, T v6, T v7) {
    result =
      join(sepStr(), toString(v1), toString(v2), toString(v3), toString(v4), toString(v5),
        toString(v6), toString(v7))
  }

  /**
   * Produces a CSV-like list of 8 items, cast to type `S` which extends string, using the custom
   * separator.
   *
   * The predicate `toString` is used on the arguments to ensure that they are converted to strings
   * before being joined together.
   */
  bindingset[v1, v2, v3, v4, v5, v6, v7, v8]
  S of8(T v1, T v2, T v3, T v4, T v5, T v6, T v7, T v8) {
    result =
      join(sepStr(), toString(v1), toString(v2), toString(v3), toString(v4), toString(v5),
        toString(v6), toString(v7), toString(v8))
  }
}
