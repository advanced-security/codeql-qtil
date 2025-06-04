private import qtil.parameterization.SignatureTypes
private import qtil.fn.FnTypes
private import qtil.fn.Tp

/**
 * A module that defines the set of values returned by a function with no parameters.
 *
 * This is a wrapper around `Tp1`, a tuple predicate that represents a set of tuples with only one
 * element, which is the result of the function.
 *
 * See `Tp1` for more details and the full API, which includes mapping and filtering etc.
 */
module ResultSet<InfiniteStringableType T, FnType0<T>::fn/0 baseFn> {
  private predicate baseTp(T t) { t = baseFn() }

  import Tp1<T, baseTp/1>
}
