private import qtil.parameterization.SignatureTypes
private import qtil.parameterization.SignaturePredicates

/**
 * A module that provides a tuple of values of type A, B, and C.
 *
 * In `qtil` parlance, a "Tuple" has three or more types/values, constrained by some predicate, a
 * "Pair" is a specific set of two types, A and B, constrained by some predicate, and a "Product" is
 * the combination of types/values which are not constrained by a predicate.
 *
 * To use this module, write a predicate that holds for the types you want to constrain, and
 * instantiate the relevantly sized like so:
 *
 * ```ql
 * import qtil.tuple.Tuple
 *
 * predicate myPredicate(int a, string b, Char c) {
 *   a = [0..10] and b = a.toString() and c.isStr(b)
 * }
 *
 * class Tuple = Tuple3<int, string, Char, myPredicate>::Tuple;
 * ```
 *
 * Each tuple type exposes the `getFirst()`, `getSecond()`, `getThird()` member predicates, which
 * retrieves the first and second and third values of the tuple, respectively.
 */
module Tuple5<
  InfiniteStringableType A, InfiniteStringableType B, InfiniteStringableType C,
  InfiniteStringableType D, InfiniteStringableType E, Quinary<A, B, C, D, E>::pred/5 constraint>
{
  private newtype TAll = TSome(A a, B b, C c, D d, E e) { constraint(a, b, c, d, e) }

  class Tuple extends TAll {
    A getFirst() { this = TSome(result, _, _, _, _) }

    B getSecond() { this = TSome(_, result, _, _, _) }

    C getThird() { this = TSome(_, _, result, _, _) }

    D getFourth() { this = TSome(_, _, _, result, _) }

    E getFifth() { this = TSome(_, _, _, _, result) }

    string toString() { result = getFirst().toString() + ", " + getSecond().toString() }
  }
}

module Tuple6<
  InfiniteStringableType A, InfiniteStringableType B, InfiniteStringableType C,
  InfiniteStringableType D, InfiniteStringableType E, InfiniteStringableType F,
  Senary<A, B, C, D, E, F>::pred/6 constraint>
{
  private newtype TAll = TSome(A a, B b, C c, D d, E e, F f) { constraint(a, b, c, d, e, f) }

  class Tuple extends TAll {
    A getFirst() { this = TSome(result, _, _, _, _, _) }

    B getSecond() { this = TSome(_, result, _, _, _, _) }

    C getThird() { this = TSome(_, _, result, _, _, _) }

    D getFourth() { this = TSome(_, _, _, result, _, _) }

    E getFifth() { this = TSome(_, _, _, _, result, _) }

    F getSixth() { this = TSome(_, _, _, _, _, result) }

    string toString() { result = getFirst().toString() + ", " + getSecond().toString() }
  }
}
