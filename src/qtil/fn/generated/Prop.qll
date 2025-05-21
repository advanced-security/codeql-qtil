/**
 * GENERATED CODE. DO NOT MODIFY.
 */

import qtil.fn.FnTypes
import qtil.parameterization.SignatureTypes

/**
 * A module to represent a "Property" with 1 arguments, and no result.
 *
 * In qtil speak:
 *  - a "Function" (FnX) is a predicate with a bindingset[] on all of its arguments, and a result
 *  - a "Tuple" (TupleX) is a predicate with finite arguments and no result
 *  - a "Relation" (RelX) is a predicate with finite arguments and a finite result
 *  - a "Property" (PropX) is a predicate with a bindingset[] on all arguments no result
 */
module Prop1<InfiniteStringableType A, PropType1<A>::prop/1 base> {
  /**
   * Take the given function and make a new one that only has a result when this property holds for
   * its input parameters.
   *
   * Sibling of `FilterRel`, which takes a "relation" instead of a "function."
   */
  module Restrict<InfiniteType R, FnType1<R, A>::fn/1 f> {
    bindingset[a]
    R fn(A a) {
      base(a) and
      result = f(a)
    }
  }

  /**
   * Take the given relation and restrict its range to only have a relation result for inputs that
   * satisfy this property.
   *
   * Sibling of `Restrict`, which takes a "relation" instead of a "function."
   */
  module FilterRel<InfiniteType R, RelType1<R, A>::rel/1 r> {
    R rel(A a) {
      base(a) and
      result = r(a)
    }
  }

  /**
   * Take the given relation and restrict its range to only have a relation result for inputs that
   * satisfy this property.
   *
   * Sibling of `And`, which takes a "property" instead of a "tuple predicate."
   */
  module FilterTp<TpType1<A>::tp/1 tpIn> {
    predicate tp(A a) {
      tpIn(a) and
      base(a)
    }
  }

  /**
   * Combine two properties to make one that only holds when both hold.
   *
   * Sibling function of `FilterTp`, which takes a "tuple predicate" instead of a "property"
   */
  module And<PropType1<A>::prop/1 p2> {
    bindingset[a]
    predicate prop(A a) {
      base(a) and
      p2(a)
    }
  }

  /**
   * Combine two properties to make one that holds when either hold.
   *
   * Sibling function of `Filter`, which takes a "tuple predicate" instead of a "property"
   */
  module Or<PropType1<A>::prop/1 p2> {
    bindingset[a]
    predicate prop(A a) {
      base(a) and
      p2(a)
    }
  }

  /**
   * Create a property that is the inverse of this one; the new property only holds when the current
   * property does not, and vice versa.
   */
  module Not {
    bindingset[a]
    predicate prop(A a) { not base(a) }
  }
}

/**
 * A module to represent a "Property" with 2 arguments, and no result.
 *
 * In qtil speak:
 *  - a "Function" (FnX) is a predicate with a bindingset[] on all of its arguments, and a result
 *  - a "Tuple" (TupleX) is a predicate with finite arguments and no result
 *  - a "Relation" (RelX) is a predicate with finite arguments and a finite result
 *  - a "Property" (PropX) is a predicate with a bindingset[] on all arguments no result
 */
module Prop2<InfiniteStringableType A, InfiniteStringableType B, PropType2<A, B>::prop/2 base> {
  /**
   * Take the given function and make a new one that only has a result when this property holds for
   * its input parameters.
   *
   * Sibling of `FilterRel`, which takes a "relation" instead of a "function."
   */
  module Restrict<InfiniteType R, FnType2<R, A, B>::fn/2 f> {
    bindingset[a, b]
    R fn(A a, B b) {
      base(a, b) and
      result = f(a, b)
    }
  }

  /**
   * Take the given relation and restrict its range to only have a relation result for inputs that
   * satisfy this property.
   *
   * Sibling of `Restrict`, which takes a "relation" instead of a "function."
   */
  module FilterRel<InfiniteType R, RelType2<R, A, B>::rel/2 r> {
    R rel(A a, B b) {
      base(a, b) and
      result = r(a, b)
    }
  }

  /**
   * Take the given relation and restrict its range to only have a relation result for inputs that
   * satisfy this property.
   *
   * Sibling of `And`, which takes a "property" instead of a "tuple predicate."
   */
  module FilterTp<TpType2<A, B>::tp/2 tpIn> {
    predicate tp(A a, B b) {
      tpIn(a, b) and
      base(a, b)
    }
  }

  /**
   * Combine two properties to make one that only holds when both hold.
   *
   * Sibling function of `FilterTp`, which takes a "tuple predicate" instead of a "property"
   */
  module And<PropType2<A, B>::prop/2 p2> {
    bindingset[a, b]
    predicate prop(A a, B b) {
      base(a, b) and
      p2(a, b)
    }
  }

  /**
   * Combine two properties to make one that holds when either hold.
   *
   * Sibling function of `Filter`, which takes a "tuple predicate" instead of a "property"
   */
  module Or<PropType2<A, B>::prop/2 p2> {
    bindingset[a, b]
    predicate prop(A a, B b) {
      base(a, b) and
      p2(a, b)
    }
  }

  /**
   * Create a property that is the inverse of this one; the new property only holds when the current
   * property does not, and vice versa.
   */
  module Not {
    bindingset[a, b]
    predicate prop(A a, B b) { not base(a, b) }
  }
}

/**
 * A module to represent a "Property" with 3 arguments, and no result.
 *
 * In qtil speak:
 *  - a "Function" (FnX) is a predicate with a bindingset[] on all of its arguments, and a result
 *  - a "Tuple" (TupleX) is a predicate with finite arguments and no result
 *  - a "Relation" (RelX) is a predicate with finite arguments and a finite result
 *  - a "Property" (PropX) is a predicate with a bindingset[] on all arguments no result
 */
module Prop3<
  InfiniteStringableType A, InfiniteStringableType B, InfiniteStringableType C,
  PropType3<A, B, C>::prop/3 base>
{
  /**
   * Take the given function and make a new one that only has a result when this property holds for
   * its input parameters.
   *
   * Sibling of `FilterRel`, which takes a "relation" instead of a "function."
   */
  module Restrict<InfiniteType R, FnType3<R, A, B, C>::fn/3 f> {
    bindingset[a, b, c]
    R fn(A a, B b, C c) {
      base(a, b, c) and
      result = f(a, b, c)
    }
  }

  /**
   * Take the given relation and restrict its range to only have a relation result for inputs that
   * satisfy this property.
   *
   * Sibling of `Restrict`, which takes a "relation" instead of a "function."
   */
  module FilterRel<InfiniteType R, RelType3<R, A, B, C>::rel/3 r> {
    R rel(A a, B b, C c) {
      base(a, b, c) and
      result = r(a, b, c)
    }
  }

  /**
   * Take the given relation and restrict its range to only have a relation result for inputs that
   * satisfy this property.
   *
   * Sibling of `And`, which takes a "property" instead of a "tuple predicate."
   */
  module FilterTp<TpType3<A, B, C>::tp/3 tpIn> {
    predicate tp(A a, B b, C c) {
      tpIn(a, b, c) and
      base(a, b, c)
    }
  }

  /**
   * Combine two properties to make one that only holds when both hold.
   *
   * Sibling function of `FilterTp`, which takes a "tuple predicate" instead of a "property"
   */
  module And<PropType3<A, B, C>::prop/3 p2> {
    bindingset[a, b, c]
    predicate prop(A a, B b, C c) {
      base(a, b, c) and
      p2(a, b, c)
    }
  }

  /**
   * Combine two properties to make one that holds when either hold.
   *
   * Sibling function of `Filter`, which takes a "tuple predicate" instead of a "property"
   */
  module Or<PropType3<A, B, C>::prop/3 p2> {
    bindingset[a, b, c]
    predicate prop(A a, B b, C c) {
      base(a, b, c) and
      p2(a, b, c)
    }
  }

  /**
   * Create a property that is the inverse of this one; the new property only holds when the current
   * property does not, and vice versa.
   */
  module Not {
    bindingset[a, b, c]
    predicate prop(A a, B b, C c) { not base(a, b, c) }
  }
}

/**
 * A module to represent a "Property" with 4 arguments, and no result.
 *
 * In qtil speak:
 *  - a "Function" (FnX) is a predicate with a bindingset[] on all of its arguments, and a result
 *  - a "Tuple" (TupleX) is a predicate with finite arguments and no result
 *  - a "Relation" (RelX) is a predicate with finite arguments and a finite result
 *  - a "Property" (PropX) is a predicate with a bindingset[] on all arguments no result
 */
module Prop4<
  InfiniteStringableType A, InfiniteStringableType B, InfiniteStringableType C,
  InfiniteStringableType D, PropType4<A, B, C, D>::prop/4 base>
{
  /**
   * Take the given function and make a new one that only has a result when this property holds for
   * its input parameters.
   *
   * Sibling of `FilterRel`, which takes a "relation" instead of a "function."
   */
  module Restrict<InfiniteType R, FnType4<R, A, B, C, D>::fn/4 f> {
    bindingset[a, b, c, d]
    R fn(A a, B b, C c, D d) {
      base(a, b, c, d) and
      result = f(a, b, c, d)
    }
  }

  /**
   * Take the given relation and restrict its range to only have a relation result for inputs that
   * satisfy this property.
   *
   * Sibling of `Restrict`, which takes a "relation" instead of a "function."
   */
  module FilterRel<InfiniteType R, RelType4<R, A, B, C, D>::rel/4 r> {
    R rel(A a, B b, C c, D d) {
      base(a, b, c, d) and
      result = r(a, b, c, d)
    }
  }

  /**
   * Take the given relation and restrict its range to only have a relation result for inputs that
   * satisfy this property.
   *
   * Sibling of `And`, which takes a "property" instead of a "tuple predicate."
   */
  module FilterTp<TpType4<A, B, C, D>::tp/4 tpIn> {
    predicate tp(A a, B b, C c, D d) {
      tpIn(a, b, c, d) and
      base(a, b, c, d)
    }
  }

  /**
   * Combine two properties to make one that only holds when both hold.
   *
   * Sibling function of `FilterTp`, which takes a "tuple predicate" instead of a "property"
   */
  module And<PropType4<A, B, C, D>::prop/4 p2> {
    bindingset[a, b, c, d]
    predicate prop(A a, B b, C c, D d) {
      base(a, b, c, d) and
      p2(a, b, c, d)
    }
  }

  /**
   * Combine two properties to make one that holds when either hold.
   *
   * Sibling function of `Filter`, which takes a "tuple predicate" instead of a "property"
   */
  module Or<PropType4<A, B, C, D>::prop/4 p2> {
    bindingset[a, b, c, d]
    predicate prop(A a, B b, C c, D d) {
      base(a, b, c, d) and
      p2(a, b, c, d)
    }
  }

  /**
   * Create a property that is the inverse of this one; the new property only holds when the current
   * property does not, and vice versa.
   */
  module Not {
    bindingset[a, b, c, d]
    predicate prop(A a, B b, C c, D d) { not base(a, b, c, d) }
  }
}

/**
 * A module to represent a "Property" with 5 arguments, and no result.
 *
 * In qtil speak:
 *  - a "Function" (FnX) is a predicate with a bindingset[] on all of its arguments, and a result
 *  - a "Tuple" (TupleX) is a predicate with finite arguments and no result
 *  - a "Relation" (RelX) is a predicate with finite arguments and a finite result
 *  - a "Property" (PropX) is a predicate with a bindingset[] on all arguments no result
 */
module Prop5<
  InfiniteStringableType A, InfiniteStringableType B, InfiniteStringableType C,
  InfiniteStringableType D, InfiniteStringableType E, PropType5<A, B, C, D, E>::prop/5 base>
{
  /**
   * Take the given function and make a new one that only has a result when this property holds for
   * its input parameters.
   *
   * Sibling of `FilterRel`, which takes a "relation" instead of a "function."
   */
  module Restrict<InfiniteType R, FnType5<R, A, B, C, D, E>::fn/5 f> {
    bindingset[a, b, c, d, e]
    R fn(A a, B b, C c, D d, E e) {
      base(a, b, c, d, e) and
      result = f(a, b, c, d, e)
    }
  }

  /**
   * Take the given relation and restrict its range to only have a relation result for inputs that
   * satisfy this property.
   *
   * Sibling of `Restrict`, which takes a "relation" instead of a "function."
   */
  module FilterRel<InfiniteType R, RelType5<R, A, B, C, D, E>::rel/5 r> {
    R rel(A a, B b, C c, D d, E e) {
      base(a, b, c, d, e) and
      result = r(a, b, c, d, e)
    }
  }

  /**
   * Take the given relation and restrict its range to only have a relation result for inputs that
   * satisfy this property.
   *
   * Sibling of `And`, which takes a "property" instead of a "tuple predicate."
   */
  module FilterTp<TpType5<A, B, C, D, E>::tp/5 tpIn> {
    predicate tp(A a, B b, C c, D d, E e) {
      tpIn(a, b, c, d, e) and
      base(a, b, c, d, e)
    }
  }

  /**
   * Combine two properties to make one that only holds when both hold.
   *
   * Sibling function of `FilterTp`, which takes a "tuple predicate" instead of a "property"
   */
  module And<PropType5<A, B, C, D, E>::prop/5 p2> {
    bindingset[a, b, c, d, e]
    predicate prop(A a, B b, C c, D d, E e) {
      base(a, b, c, d, e) and
      p2(a, b, c, d, e)
    }
  }

  /**
   * Combine two properties to make one that holds when either hold.
   *
   * Sibling function of `Filter`, which takes a "tuple predicate" instead of a "property"
   */
  module Or<PropType5<A, B, C, D, E>::prop/5 p2> {
    bindingset[a, b, c, d, e]
    predicate prop(A a, B b, C c, D d, E e) {
      base(a, b, c, d, e) and
      p2(a, b, c, d, e)
    }
  }

  /**
   * Create a property that is the inverse of this one; the new property only holds when the current
   * property does not, and vice versa.
   */
  module Not {
    bindingset[a, b, c, d, e]
    predicate prop(A a, B b, C c, D d, E e) { not base(a, b, c, d, e) }
  }
}

/**
 * A module to represent a "Property" with 6 arguments, and no result.
 *
 * In qtil speak:
 *  - a "Function" (FnX) is a predicate with a bindingset[] on all of its arguments, and a result
 *  - a "Tuple" (TupleX) is a predicate with finite arguments and no result
 *  - a "Relation" (RelX) is a predicate with finite arguments and a finite result
 *  - a "Property" (PropX) is a predicate with a bindingset[] on all arguments no result
 */
module Prop6<
  InfiniteStringableType A, InfiniteStringableType B, InfiniteStringableType C,
  InfiniteStringableType D, InfiniteStringableType E, InfiniteStringableType F,
  PropType6<A, B, C, D, E, F>::prop/6 base>
{
  /**
   * Take the given function and make a new one that only has a result when this property holds for
   * its input parameters.
   *
   * Sibling of `FilterRel`, which takes a "relation" instead of a "function."
   */
  module Restrict<InfiniteType R, FnType6<R, A, B, C, D, E, F>::fn/6 f> {
    bindingset[a, b, c, d, e, f]
    R fn(A a, B b, C c, D d, E e, F f) {
      base(a, b, c, d, e, f) and
      result = f(a, b, c, d, e, f)
    }
  }

  /**
   * Take the given relation and restrict its range to only have a relation result for inputs that
   * satisfy this property.
   *
   * Sibling of `Restrict`, which takes a "relation" instead of a "function."
   */
  module FilterRel<InfiniteType R, RelType6<R, A, B, C, D, E, F>::rel/6 r> {
    R rel(A a, B b, C c, D d, E e, F f) {
      base(a, b, c, d, e, f) and
      result = r(a, b, c, d, e, f)
    }
  }

  /**
   * Take the given relation and restrict its range to only have a relation result for inputs that
   * satisfy this property.
   *
   * Sibling of `And`, which takes a "property" instead of a "tuple predicate."
   */
  module FilterTp<TpType6<A, B, C, D, E, F>::tp/6 tpIn> {
    predicate tp(A a, B b, C c, D d, E e, F f) {
      tpIn(a, b, c, d, e, f) and
      base(a, b, c, d, e, f)
    }
  }

  /**
   * Combine two properties to make one that only holds when both hold.
   *
   * Sibling function of `FilterTp`, which takes a "tuple predicate" instead of a "property"
   */
  module And<PropType6<A, B, C, D, E, F>::prop/6 p2> {
    bindingset[a, b, c, d, e, f]
    predicate prop(A a, B b, C c, D d, E e, F f) {
      base(a, b, c, d, e, f) and
      p2(a, b, c, d, e, f)
    }
  }

  /**
   * Combine two properties to make one that holds when either hold.
   *
   * Sibling function of `Filter`, which takes a "tuple predicate" instead of a "property"
   */
  module Or<PropType6<A, B, C, D, E, F>::prop/6 p2> {
    bindingset[a, b, c, d, e, f]
    predicate prop(A a, B b, C c, D d, E e, F f) {
      base(a, b, c, d, e, f) and
      p2(a, b, c, d, e, f)
    }
  }

  /**
   * Create a property that is the inverse of this one; the new property only holds when the current
   * property does not, and vice versa.
   */
  module Not {
    bindingset[a, b, c, d, e, f]
    predicate prop(A a, B b, C c, D d, E e, F f) { not base(a, b, c, d, e, f) }
  }
}
