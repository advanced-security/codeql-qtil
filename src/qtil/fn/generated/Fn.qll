/**
 * GENERATED CODE. DO NOT MODIFY.
 */

import qtil.fn.FnTypes
import qtil.parameterization.SignatureTypes

/**
 * A module to represent a "Function" with 0 arguments, and a result.
 *
 * In qtil speak:
 *  - a "Function" (FnX) is a predicate with a bindingset[] on all of its arguments, and a result
 *  - a "Tuple" (TupleX) is a predicate with finite arguments and no result
 *  - a "Relation" (RelX) is a predicate with finite arguments and a finite result
 *  - a "Property" (PropX) is a predicate with a bindingset[] on all arguments no result
 */
module Fn0<InfiniteStringableType R, FnType0<R>::fn/0 base> {
  /**
   * Take a predicate to map the output of this function according to the mapper.
   *
   * Example:
   * ```ql
   * bindingset[x]
   * int toInt(string x) { result.toString() = x }
   *
   * bindingset[x]
   * int double(int x) { result = x * 2 }
   *
   * int doubleStringNumber(string x) {
   *   // doubleStringNumber("4") = 8, doubleStringNumber("7") = 14, etc
   *   result = Fn1<int, string, toInt/1>::Map<int, double/1>::fn(x)
   * }
   * ```
   *
   * To map the arguments, rather than the result, use `TupleX::Map`
   */
  module Compose<InfiniteType R2, FnType1<R2, R>::fn/1 f2> {
    /**
     * Get the values that have been mapped from the oginal base predicate by the mapper function.
     *
     * See the `Map` for more detail and example usage.
     */
    R2 fn() { result = f2(base()) }
  }

  /**
   * Filter this function to only produce an output when the output satisfies the given property.
   *
   * Sibling predicate of `ToLookup`, which takes a "tuple predicate" instead of a "property."
   */
  module Filter<PropType1<R>::prop/1 prop> {
    R fn() {
      result = base() and
      prop(result)
    }
  }

  /**
   * Use the output of this function as a lookup to values that exist in the provided unary tuple
   * predicate.
   *
   * Sibling predicate of `Filter`, which takes a "property" instead of a "tuple predicate."
   */
  module ToLookup<TpType1<R>::tp/1 tp> {
    R fn() {
      result = base() and
      tp(result)
    }
  }
}

/**
 * A module to represent a "Function" with 1 arguments, and a result.
 *
 * In qtil speak:
 *  - a "Function" (FnX) is a predicate with a bindingset[] on all of its arguments, and a result
 *  - a "Tuple" (TupleX) is a predicate with finite arguments and no result
 *  - a "Relation" (RelX) is a predicate with finite arguments and a finite result
 *  - a "Property" (PropX) is a predicate with a bindingset[] on all arguments no result
 */
module Fn1<InfiniteStringableType R, InfiniteStringableType A, FnType1<R, A>::fn/1 base> {
  /**
   * Take a predicate to map the output of this function according to the mapper.
   *
   * Example:
   * ```ql
   * bindingset[x]
   * int toInt(string x) { result.toString() = x }
   *
   * bindingset[x]
   * int double(int x) { result = x * 2 }
   *
   * int doubleStringNumber(string x) {
   *   // doubleStringNumber("4") = 8, doubleStringNumber("7") = 14, etc
   *   result = Fn1<int, string, toInt/1>::Map<int, double/1>::fn(x)
   * }
   * ```
   *
   * To map the arguments, rather than the result, use `TupleX::Map`
   */
  module Compose<InfiniteType R2, FnType1<R2, R>::fn/1 f2> {
    /**
     * Get the values that have been mapped from the oginal base predicate by the mapper function.
     *
     * See the `Map` for more detail and example usage.
     */
    bindingset[a]
    R2 fn(A a) { result = f2(base(a)) }
  }

  /**
   * Filter this function to only produce an output when the inputs satisfy the given property.
   *
   * Sibling function of `ToRelation`, which takes a "tuple predicate" instead of a "property"
   */
  module If<PropType1<A>::prop/1 prop> {
    bindingset[a]
    R fn(A a) {
      prop(a) and
      result = base(a)
    }
  }

  /**
   * Apply this function to all tuples in the provided tuple predicate in order to build a relation
   * between the input tuples and the function result.
   *
   * Sibling function of `If`, which takes a "property" instead of a "tuple predicate."
   */
  module ToRelation<TpType1<A>::tp/1 tp> {
    R rel(A a) {
      tp(a) and
      result = base(a)
    }
  }

  /**
   * Apply this function to all tuples in the provided tuple predicate.
   */
  module Apply<TpType1<A>::tp/1 tp> {
    R fn() {
      exists(A a |
        tp(a) and
        result = base(a)
      )
    }
  }

  /**
   * Filter this function to only produce an output when the output satisfies the given property.
   *
   * Sibling predicate of `ToLookup`, which takes a "tuple predicate" instead of a "property."
   */
  module Filter<PropType1<R>::prop/1 prop> {
    bindingset[a]
    R fn(A a) {
      result = base(a) and
      prop(result)
    }
  }

  /**
   * Use the output of this function as a lookup to values that exist in the provided unary tuple
   * predicate.
   *
   * Sibling predicate of `Filter`, which takes a "property" instead of a "tuple predicate."
   */
  module ToLookup<TpType1<R>::tp/1 tp> {
    bindingset[a]
    R fn(A a) {
      result = base(a) and
      tp(result)
    }
  }
}

/**
 * A module to represent a "Function" with 2 arguments, and a result.
 *
 * In qtil speak:
 *  - a "Function" (FnX) is a predicate with a bindingset[] on all of its arguments, and a result
 *  - a "Tuple" (TupleX) is a predicate with finite arguments and no result
 *  - a "Relation" (RelX) is a predicate with finite arguments and a finite result
 *  - a "Property" (PropX) is a predicate with a bindingset[] on all arguments no result
 */
module Fn2<
  InfiniteStringableType R, InfiniteStringableType A, InfiniteStringableType B,
  FnType2<R, A, B>::fn/2 base>
{
  /**
   * Take a predicate to map the output of this function according to the mapper.
   *
   * Example:
   * ```ql
   * bindingset[x]
   * int toInt(string x) { result.toString() = x }
   *
   * bindingset[x]
   * int double(int x) { result = x * 2 }
   *
   * int doubleStringNumber(string x) {
   *   // doubleStringNumber("4") = 8, doubleStringNumber("7") = 14, etc
   *   result = Fn1<int, string, toInt/1>::Map<int, double/1>::fn(x)
   * }
   * ```
   *
   * To map the arguments, rather than the result, use `TupleX::Map`
   */
  module Compose<InfiniteType R2, FnType1<R2, R>::fn/1 f2> {
    /**
     * Get the values that have been mapped from the oginal base predicate by the mapper function.
     *
     * See the `Map` for more detail and example usage.
     */
    bindingset[a, b]
    R2 fn(A a, B b) { result = f2(base(a, b)) }
  }

  /**
   * Filter this function to only produce an output when the inputs satisfy the given property.
   *
   * Sibling function of `ToRelation`, which takes a "tuple predicate" instead of a "property"
   */
  module If<PropType2<A, B>::prop/2 prop> {
    bindingset[a, b]
    R fn(A a, B b) {
      prop(a, b) and
      result = base(a, b)
    }
  }

  /**
   * Apply this function to all tuples in the provided tuple predicate in order to build a relation
   * between the input tuples and the function result.
   *
   * Sibling function of `If`, which takes a "property" instead of a "tuple predicate."
   */
  module ToRelation<TpType2<A, B>::tp/2 tp> {
    R rel(A a, B b) {
      tp(a, b) and
      result = base(a, b)
    }
  }

  /**
   * Apply this function to all tuples in the provided tuple predicate.
   */
  module Apply<TpType2<A, B>::tp/2 tp> {
    R fn() {
      exists(A a, B b |
        tp(a, b) and
        result = base(a, b)
      )
    }
  }

  /**
   * Filter this function to only produce an output when the output satisfies the given property.
   *
   * Sibling predicate of `ToLookup`, which takes a "tuple predicate" instead of a "property."
   */
  module Filter<PropType1<R>::prop/1 prop> {
    bindingset[a, b]
    R fn(A a, B b) {
      result = base(a, b) and
      prop(result)
    }
  }

  /**
   * Use the output of this function as a lookup to values that exist in the provided unary tuple
   * predicate.
   *
   * Sibling predicate of `Filter`, which takes a "property" instead of a "tuple predicate."
   */
  module ToLookup<TpType1<R>::tp/1 tp> {
    bindingset[a, b]
    R fn(A a, B b) {
      result = base(a, b) and
      tp(result)
    }
  }
}

/**
 * A module to represent a "Function" with 3 arguments, and a result.
 *
 * In qtil speak:
 *  - a "Function" (FnX) is a predicate with a bindingset[] on all of its arguments, and a result
 *  - a "Tuple" (TupleX) is a predicate with finite arguments and no result
 *  - a "Relation" (RelX) is a predicate with finite arguments and a finite result
 *  - a "Property" (PropX) is a predicate with a bindingset[] on all arguments no result
 */
module Fn3<
  InfiniteStringableType R, InfiniteStringableType A, InfiniteStringableType B,
  InfiniteStringableType C, FnType3<R, A, B, C>::fn/3 base>
{
  /**
   * Take a predicate to map the output of this function according to the mapper.
   *
   * Example:
   * ```ql
   * bindingset[x]
   * int toInt(string x) { result.toString() = x }
   *
   * bindingset[x]
   * int double(int x) { result = x * 2 }
   *
   * int doubleStringNumber(string x) {
   *   // doubleStringNumber("4") = 8, doubleStringNumber("7") = 14, etc
   *   result = Fn1<int, string, toInt/1>::Map<int, double/1>::fn(x)
   * }
   * ```
   *
   * To map the arguments, rather than the result, use `TupleX::Map`
   */
  module Compose<InfiniteType R2, FnType1<R2, R>::fn/1 f2> {
    /**
     * Get the values that have been mapped from the oginal base predicate by the mapper function.
     *
     * See the `Map` for more detail and example usage.
     */
    bindingset[a, b, c]
    R2 fn(A a, B b, C c) { result = f2(base(a, b, c)) }
  }

  /**
   * Filter this function to only produce an output when the inputs satisfy the given property.
   *
   * Sibling function of `ToRelation`, which takes a "tuple predicate" instead of a "property"
   */
  module If<PropType3<A, B, C>::prop/3 prop> {
    bindingset[a, b, c]
    R fn(A a, B b, C c) {
      prop(a, b, c) and
      result = base(a, b, c)
    }
  }

  /**
   * Apply this function to all tuples in the provided tuple predicate in order to build a relation
   * between the input tuples and the function result.
   *
   * Sibling function of `If`, which takes a "property" instead of a "tuple predicate."
   */
  module ToRelation<TpType3<A, B, C>::tp/3 tp> {
    R rel(A a, B b, C c) {
      tp(a, b, c) and
      result = base(a, b, c)
    }
  }

  /**
   * Apply this function to all tuples in the provided tuple predicate.
   */
  module Apply<TpType3<A, B, C>::tp/3 tp> {
    R fn() {
      exists(A a, B b, C c |
        tp(a, b, c) and
        result = base(a, b, c)
      )
    }
  }

  /**
   * Filter this function to only produce an output when the output satisfies the given property.
   *
   * Sibling predicate of `ToLookup`, which takes a "tuple predicate" instead of a "property."
   */
  module Filter<PropType1<R>::prop/1 prop> {
    bindingset[a, b, c]
    R fn(A a, B b, C c) {
      result = base(a, b, c) and
      prop(result)
    }
  }

  /**
   * Use the output of this function as a lookup to values that exist in the provided unary tuple
   * predicate.
   *
   * Sibling predicate of `Filter`, which takes a "property" instead of a "tuple predicate."
   */
  module ToLookup<TpType1<R>::tp/1 tp> {
    bindingset[a, b, c]
    R fn(A a, B b, C c) {
      result = base(a, b, c) and
      tp(result)
    }
  }
}

/**
 * A module to represent a "Function" with 4 arguments, and a result.
 *
 * In qtil speak:
 *  - a "Function" (FnX) is a predicate with a bindingset[] on all of its arguments, and a result
 *  - a "Tuple" (TupleX) is a predicate with finite arguments and no result
 *  - a "Relation" (RelX) is a predicate with finite arguments and a finite result
 *  - a "Property" (PropX) is a predicate with a bindingset[] on all arguments no result
 */
module Fn4<
  InfiniteStringableType R, InfiniteStringableType A, InfiniteStringableType B,
  InfiniteStringableType C, InfiniteStringableType D, FnType4<R, A, B, C, D>::fn/4 base>
{
  /**
   * Take a predicate to map the output of this function according to the mapper.
   *
   * Example:
   * ```ql
   * bindingset[x]
   * int toInt(string x) { result.toString() = x }
   *
   * bindingset[x]
   * int double(int x) { result = x * 2 }
   *
   * int doubleStringNumber(string x) {
   *   // doubleStringNumber("4") = 8, doubleStringNumber("7") = 14, etc
   *   result = Fn1<int, string, toInt/1>::Map<int, double/1>::fn(x)
   * }
   * ```
   *
   * To map the arguments, rather than the result, use `TupleX::Map`
   */
  module Compose<InfiniteType R2, FnType1<R2, R>::fn/1 f2> {
    /**
     * Get the values that have been mapped from the oginal base predicate by the mapper function.
     *
     * See the `Map` for more detail and example usage.
     */
    bindingset[a, b, c, d]
    R2 fn(A a, B b, C c, D d) { result = f2(base(a, b, c, d)) }
  }

  /**
   * Filter this function to only produce an output when the inputs satisfy the given property.
   *
   * Sibling function of `ToRelation`, which takes a "tuple predicate" instead of a "property"
   */
  module If<PropType4<A, B, C, D>::prop/4 prop> {
    bindingset[a, b, c, d]
    R fn(A a, B b, C c, D d) {
      prop(a, b, c, d) and
      result = base(a, b, c, d)
    }
  }

  /**
   * Apply this function to all tuples in the provided tuple predicate in order to build a relation
   * between the input tuples and the function result.
   *
   * Sibling function of `If`, which takes a "property" instead of a "tuple predicate."
   */
  module ToRelation<TpType4<A, B, C, D>::tp/4 tp> {
    R rel(A a, B b, C c, D d) {
      tp(a, b, c, d) and
      result = base(a, b, c, d)
    }
  }

  /**
   * Apply this function to all tuples in the provided tuple predicate.
   */
  module Apply<TpType4<A, B, C, D>::tp/4 tp> {
    R fn() {
      exists(A a, B b, C c, D d |
        tp(a, b, c, d) and
        result = base(a, b, c, d)
      )
    }
  }

  /**
   * Filter this function to only produce an output when the output satisfies the given property.
   *
   * Sibling predicate of `ToLookup`, which takes a "tuple predicate" instead of a "property."
   */
  module Filter<PropType1<R>::prop/1 prop> {
    bindingset[a, b, c, d]
    R fn(A a, B b, C c, D d) {
      result = base(a, b, c, d) and
      prop(result)
    }
  }

  /**
   * Use the output of this function as a lookup to values that exist in the provided unary tuple
   * predicate.
   *
   * Sibling predicate of `Filter`, which takes a "property" instead of a "tuple predicate."
   */
  module ToLookup<TpType1<R>::tp/1 tp> {
    bindingset[a, b, c, d]
    R fn(A a, B b, C c, D d) {
      result = base(a, b, c, d) and
      tp(result)
    }
  }
}

/**
 * A module to represent a "Function" with 5 arguments, and a result.
 *
 * In qtil speak:
 *  - a "Function" (FnX) is a predicate with a bindingset[] on all of its arguments, and a result
 *  - a "Tuple" (TupleX) is a predicate with finite arguments and no result
 *  - a "Relation" (RelX) is a predicate with finite arguments and a finite result
 *  - a "Property" (PropX) is a predicate with a bindingset[] on all arguments no result
 */
module Fn5<
  InfiniteStringableType R, InfiniteStringableType A, InfiniteStringableType B,
  InfiniteStringableType C, InfiniteStringableType D, InfiniteStringableType E,
  FnType5<R, A, B, C, D, E>::fn/5 base>
{
  /**
   * Take a predicate to map the output of this function according to the mapper.
   *
   * Example:
   * ```ql
   * bindingset[x]
   * int toInt(string x) { result.toString() = x }
   *
   * bindingset[x]
   * int double(int x) { result = x * 2 }
   *
   * int doubleStringNumber(string x) {
   *   // doubleStringNumber("4") = 8, doubleStringNumber("7") = 14, etc
   *   result = Fn1<int, string, toInt/1>::Map<int, double/1>::fn(x)
   * }
   * ```
   *
   * To map the arguments, rather than the result, use `TupleX::Map`
   */
  module Compose<InfiniteType R2, FnType1<R2, R>::fn/1 f2> {
    /**
     * Get the values that have been mapped from the oginal base predicate by the mapper function.
     *
     * See the `Map` for more detail and example usage.
     */
    bindingset[a, b, c, d, e]
    R2 fn(A a, B b, C c, D d, E e) { result = f2(base(a, b, c, d, e)) }
  }

  /**
   * Filter this function to only produce an output when the inputs satisfy the given property.
   *
   * Sibling function of `ToRelation`, which takes a "tuple predicate" instead of a "property"
   */
  module If<PropType5<A, B, C, D, E>::prop/5 prop> {
    bindingset[a, b, c, d, e]
    R fn(A a, B b, C c, D d, E e) {
      prop(a, b, c, d, e) and
      result = base(a, b, c, d, e)
    }
  }

  /**
   * Apply this function to all tuples in the provided tuple predicate in order to build a relation
   * between the input tuples and the function result.
   *
   * Sibling function of `If`, which takes a "property" instead of a "tuple predicate."
   */
  module ToRelation<TpType5<A, B, C, D, E>::tp/5 tp> {
    R rel(A a, B b, C c, D d, E e) {
      tp(a, b, c, d, e) and
      result = base(a, b, c, d, e)
    }
  }

  /**
   * Apply this function to all tuples in the provided tuple predicate.
   */
  module Apply<TpType5<A, B, C, D, E>::tp/5 tp> {
    R fn() {
      exists(A a, B b, C c, D d, E e |
        tp(a, b, c, d, e) and
        result = base(a, b, c, d, e)
      )
    }
  }

  /**
   * Filter this function to only produce an output when the output satisfies the given property.
   *
   * Sibling predicate of `ToLookup`, which takes a "tuple predicate" instead of a "property."
   */
  module Filter<PropType1<R>::prop/1 prop> {
    bindingset[a, b, c, d, e]
    R fn(A a, B b, C c, D d, E e) {
      result = base(a, b, c, d, e) and
      prop(result)
    }
  }

  /**
   * Use the output of this function as a lookup to values that exist in the provided unary tuple
   * predicate.
   *
   * Sibling predicate of `Filter`, which takes a "property" instead of a "tuple predicate."
   */
  module ToLookup<TpType1<R>::tp/1 tp> {
    bindingset[a, b, c, d, e]
    R fn(A a, B b, C c, D d, E e) {
      result = base(a, b, c, d, e) and
      tp(result)
    }
  }
}

/**
 * A module to represent a "Function" with 6 arguments, and a result.
 *
 * In qtil speak:
 *  - a "Function" (FnX) is a predicate with a bindingset[] on all of its arguments, and a result
 *  - a "Tuple" (TupleX) is a predicate with finite arguments and no result
 *  - a "Relation" (RelX) is a predicate with finite arguments and a finite result
 *  - a "Property" (PropX) is a predicate with a bindingset[] on all arguments no result
 */
module Fn6<
  InfiniteStringableType R, InfiniteStringableType A, InfiniteStringableType B,
  InfiniteStringableType C, InfiniteStringableType D, InfiniteStringableType E,
  InfiniteStringableType F, FnType6<R, A, B, C, D, E, F>::fn/6 base>
{
  /**
   * Take a predicate to map the output of this function according to the mapper.
   *
   * Example:
   * ```ql
   * bindingset[x]
   * int toInt(string x) { result.toString() = x }
   *
   * bindingset[x]
   * int double(int x) { result = x * 2 }
   *
   * int doubleStringNumber(string x) {
   *   // doubleStringNumber("4") = 8, doubleStringNumber("7") = 14, etc
   *   result = Fn1<int, string, toInt/1>::Map<int, double/1>::fn(x)
   * }
   * ```
   *
   * To map the arguments, rather than the result, use `TupleX::Map`
   */
  module Compose<InfiniteType R2, FnType1<R2, R>::fn/1 f2> {
    /**
     * Get the values that have been mapped from the oginal base predicate by the mapper function.
     *
     * See the `Map` for more detail and example usage.
     */
    bindingset[a, b, c, d, e, f]
    R2 fn(A a, B b, C c, D d, E e, F f) { result = f2(base(a, b, c, d, e, f)) }
  }

  /**
   * Filter this function to only produce an output when the inputs satisfy the given property.
   *
   * Sibling function of `ToRelation`, which takes a "tuple predicate" instead of a "property"
   */
  module If<PropType6<A, B, C, D, E, F>::prop/6 prop> {
    bindingset[a, b, c, d, e, f]
    R fn(A a, B b, C c, D d, E e, F f) {
      prop(a, b, c, d, e, f) and
      result = base(a, b, c, d, e, f)
    }
  }

  /**
   * Apply this function to all tuples in the provided tuple predicate in order to build a relation
   * between the input tuples and the function result.
   *
   * Sibling function of `If`, which takes a "property" instead of a "tuple predicate."
   */
  module ToRelation<TpType6<A, B, C, D, E, F>::tp/6 tp> {
    R rel(A a, B b, C c, D d, E e, F f) {
      tp(a, b, c, d, e, f) and
      result = base(a, b, c, d, e, f)
    }
  }

  /**
   * Apply this function to all tuples in the provided tuple predicate.
   */
  module Apply<TpType6<A, B, C, D, E, F>::tp/6 tp> {
    R fn() {
      exists(A a, B b, C c, D d, E e, F f |
        tp(a, b, c, d, e, f) and
        result = base(a, b, c, d, e, f)
      )
    }
  }

  /**
   * Filter this function to only produce an output when the output satisfies the given property.
   *
   * Sibling predicate of `ToLookup`, which takes a "tuple predicate" instead of a "property."
   */
  module Filter<PropType1<R>::prop/1 prop> {
    bindingset[a, b, c, d, e, f]
    R fn(A a, B b, C c, D d, E e, F f) {
      result = base(a, b, c, d, e, f) and
      prop(result)
    }
  }

  /**
   * Use the output of this function as a lookup to values that exist in the provided unary tuple
   * predicate.
   *
   * Sibling predicate of `Filter`, which takes a "property" instead of a "tuple predicate."
   */
  module ToLookup<TpType1<R>::tp/1 tp> {
    bindingset[a, b, c, d, e, f]
    R fn(A a, B b, C c, D d, E e, F f) {
      result = base(a, b, c, d, e, f) and
      tp(result)
    }
  }
}
