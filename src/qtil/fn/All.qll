private import qtil.parameterization.SignatureTypes
private import qtil.fn.FnTypes
private import qtil.fn.Tp

/**
 * A module that defines the set of all values of a certain type.
 *
 * This is a wrapper around `Tp1`, a tuple predicate that represents a set of tuples with only one
 * element, where the element is any value of the type.
 *
 * See `Tp1` for more details and the full API, which includes mapping and filtering etc.
 */
module All<FiniteStringableType T> {
  private predicate baseTp(T t) { any() }

  import Tp1<T, baseTp/1>
}
