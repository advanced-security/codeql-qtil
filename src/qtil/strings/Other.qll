import qtil.parameterization.SignaturePredicates
import qtil.parameterization.SignatureTypes
import qtil.strings.Char

/**
 * CodeQL 2.21.1 has a bug where `concat` with a delimiter and an order will silently drop the
 * delimiter.
 *
 * Use this module to work around that bug.
 *
 * Example:
 *
 * ```
 * string names(int x) {
 *   x = 0 and result = "foo" or
 *   x = 1 and result = "bar" or
 *   x = 2 and result = "baz"
 * }
 *
 * // BUG: selects foobarbaz
 * select concat(int x, string name | name = names(x) | name order by x, ",")
 *
 * // FIXED: selects foo,bar,baz
 * select ConcatDelimOrderFixed<Chars::comma/0, names/1>::join()
 * ```
 */
module ConcatDelimOrderFixed<
  Nullary::Ret<Char>::pred/0 separator, Unary<int>::Ret<string>::pred/1 items>
{
  /**
   * Perform the concatenation with the given separator and items/order.
   */
  string join() {
    exists(int lastIdx |
      lastIdx = max(int x | exists(items(x))) and
      result =
        concat(int x, string given, string separated |
          given = items(x) and
          if x = lastIdx then separated = given else separated = given + separator()
        |
          separated order by x
        )
    )
    or
    // Match CodeQL concat() behavior and always return an empty string if there are no items.
    not exists(items(_)) and result = ""
  }
}
