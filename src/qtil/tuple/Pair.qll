private import qtil.parameterization.SignatureTypes
private import qtil.parameterization.SignaturePredicates

/**
 * A module that provides a pair of values of type A and B.
 *
 * In `qtil` parlance, a "Pair" is a specific set of two types, A and B, constrained by some
 * predicate, a "Tuple" has three or more types/values, and a "Product" is the combination of
 * types/values which are not constrained by a predicate.
 *
 * To use this module, write a predicate that holds for the two types you want to constrain, and
 * instantiate this module like so:
 *
 * ```ql
 * import qtil.tuple.Pair
 *
 * predicate myPredicate(int a, string b) {
 *   a = [0..10] and b = a.toString()
 * }
 *
 * class MyIntStringPair = Pair<int, string, myPredicate>::Pair;
 * ```
 *
 * Each tuple type exposes the `getFirst()` and `getSecond()` member predicates, which retrieves
 * the first and second values of the pair, respectively.
 */
module Pair<InfiniteStringableType A, InfiniteStringableType B, Binary<A, B>::pred/2 constraint> {
  private newtype TAll = TSome(A a, B b) { constraint(a, b) }

  class Pair extends TAll {
    A getFirst() { this = TSome(result, _) }

    B getSecond() { this = TSome(_, result) }

    string toString() { result = getFirst().toString() + ", " + getSecond().toString() }
  }
}
