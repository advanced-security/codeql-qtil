private import codeql.util.Option
private import codeql.util.Location
private import qtil.parameterization.Finalize
private import qtil.locations.NullLocation

/**
 * A module which exposes a class that represents a location that may not exist.
 *
 * To use this module, instantiate it with the type of location you want to use, and then import the
 * `Location` class.
 *
 * ```ql
 * ...
 * import cpp as cpp
 * ...
 * class OptionalLocation = OptionalLocation<cpp::Location>::Location;
 * ```
 *
 * Note that if you use `Option<Location>`, then CodeQL will not know that the class is a location,
 * as it does not have the `hasLocationInfo` predicate.
 *
 * See the documentation for the `Location` class for more information.
 */
module OptionalLocation<LocationSig L> {
  // LocationSig has bindingset[this] on toString(), which Option doesn't allow, so we can't do:
  // class Location extends Final<Option<L>::Option>::Type {}
  private newtype TLocationOption =
    TNone() or
    TSome(L loc)

  /**
   * A class that represents a location that may not exist.
   *
   * The API resembles a union of the `codeql.util.Option` class with the `codeql.util.Location`
   * class.
   *
   * Example usage:
   *
   * ```ql
   * OptionalLocation locationOf(... x) {
   *   if x.hasLocation()
   *   then result.asSome() = x.getLocation()}}
   *   else result.isNone()
   * }
   * ```
   *
   * Note that if you used `Option<Location>`, then CodeQL would not know that the class is a
   * location, as it does not have the `hasLocationInfo` predicate.
   */
  class Location extends TLocationOption {
    /**
     * Gets the location if it exists.
     */
    L asSome() { this = TSome(result) }

    /**
     * Holds when this refers to a location that does not exist.
     */
    predicate isNone() { this = TNone() }

    string toString() {
      isNone() and result = "(none)"
      or
      result = this.asSome().toString()
    }

    /**
     * Location info predicate so that CodeQL can use this class as a location.
     * 
     * Only holds if the location exists. If it does not exist, and this is selected as a query
     * location, then the CodeQL engine will use an empty filename and line/column numbers of 0.
     */
    predicate hasLocationInfo(
      string filePath, int startLine, int startColumn, int endLine, int endColumn
    ) {
      this.asSome().hasLocationInfo(filePath, startLine, startColumn, endLine, endColumn)
    }
  }
}
