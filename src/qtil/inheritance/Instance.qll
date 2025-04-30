private import qtil.parameterization.SignatureTypes

/**
 * A module to make it more convenient to use `instanceof` inheritance in QL, by providing a 
 * convenience cast member, and inheriting `toString()` from the instance type.
 * 
 * To use this module, instead of declaring `instanceof T`, declare `extend Instance<T>::Type` and
 * then use the `inst()` member to access members on the base class `T`.
 * 
 * Example usage:
 * ```ql
 * class MyExpr extends Instance<Expr>::Type {
 *   predicate isConstant() { inst().isConstant() }
 * }
 * 
 * // is equivalent to:
 * class MyExpr2 instanceof Expr {
 *   string toString() { result = this.(Expr).toString() }
 *   predicate isConstant() {this.(Expr).isConstant() }
 * }
 * ```
 * 
 * For using `instanceof` inheritance with infinite types, use the `InfInstance` module instead, as
 * additional bindingset declarations are required to support infinite types.
 */
module Instance<FiniteStringableType T> {
  /**
   * A convenience base class that is an `instanceof` the type `T`.
   * 
   * This class inherits the `toString()` method from the instance type `T`, and provides a
   * convenience method `inst()` to cast `this` to the instance type `T`.
   */
  final class Type instanceof T {
    /**
     * Convenience method to cast `this` to the instance type `T`.
     * 
     * Specified as `final` for performance and maintainability reasons.
     **/
    final T inst() { result = this }

    string toString() {
      result = inst().toString()
    }
  }
}

/**
 * A version of the `Instance` module that works with infinite types.
 * 
 * See `Instance` for more details.
 * 
 * When using `instanceof` inheritance with finite types, prefer using the `Instance` module.
 */
module InfInstance<InfiniteStringableType T> {
  /**
   * A convenience base class that is an `instanceof` an infinite type `T`.
   * 
   * This class inherits the `toString()` method from the instance type `T`, and provides a
   * convenience method `inst()` to cast `this` to the instance type `T`.
   */
  bindingset[this]
  final class Type instanceof T {
    /**
     * Convenience method to cast `this` to the infinite instance type `T`.
     * 
     * Specifies bindingsets to allow for two-way bindings, so that the underlying instance value
     * can be constrained to a finite set of values and vice versa. Specified as `final` for
     * performance and maintainability reasons.
     **/
    bindingset[result] bindingset[this]
    T inst() { result = this }

    bindingset[this]
    string toString() {
      result = inst().toString()
    }
  }
}