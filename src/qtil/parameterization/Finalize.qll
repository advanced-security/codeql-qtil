private import qtil.parameterization.SignatureTypes

/**
 * A convenience module to create a final version of a type, for the purposes of extending it in a
 * parameterized module, without having to define a new final alias of that type.
 *
 * ```ql
 * module MyModule<...> {
 *   // Using this module:
 *   class MyExpr extends Final<Expr>::Type { ... }
 *
 *   // Ordinary behavior:
 *   // Error: cannot extend types outside the current parameterized module
 *   class MyExpr extends Expr { ... }
 *
 *   // Ordinary behavior:
 *   // Workaround: define a new final alias of the type
 *   class FinalExpr = Expr;
 *   class MyExpr extends FinalExpr { ... }
 * }
 * ```
 */
module Final<InfiniteType T> {
  /** The class to extend, i.e., `class MyExpr extends Final<Expr>::Type {...}` */
  final class Type = T;
}
