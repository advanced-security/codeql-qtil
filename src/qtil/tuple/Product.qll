private import qtil.parameterization.SignatureTypes

/**
 * A module that provides the product of values of type A and B.
 * 
 * *Caution*: Product types can have a large number of values and are not suitable for many use
 * cases. Carefully consider if using a `Pair` or `Tuple` type is more appropriate before using
 * this module.
 * 
 * In `qtil` parlance, a "Pair" is a specific set of two types, A and B, constrained by some
 * predicate, a "Tuple" has three or more types/values, and a "Product" is the combination of
 * types/values which are not constrained by a predicate.
 * 
 * To use this module, instantiate the module with a set of finite types. Infinite types are not
 * supportable.
 * 
 * ```ql
 * import qtil.tuple.Product
 * 
 * class ABProduct = Product2<A, B>::Product;
 * ```
 * 
 * Each product exposes the `getFirst()` and `getSecond()` member predicates, which retrieves
 * the first and second values of the product, respectively.
 */
module Product2<FiniteStringableType A, FiniteStringableType B> {
  private newtype TAll = TSome(A a, B b)

  class Product extends TAll {
    A getFirst() {
      this = TSome(result, _)
    }

    B getSecond() {
      this = TSome(_, result)
    }

    string toString() {
      result = getFirst().toString() + ", " + getSecond().toString()
    }
  }
}