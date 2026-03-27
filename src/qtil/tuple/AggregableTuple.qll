private import qtil.parameterization.SignatureTypes
private import qtil.parameterization.SignaturePredicates
private import qtil.tuple.StringTuple as CustomStringTuple
private import qtil.strings.Chars
private import qtil.inheritance.Instance
private import codeql.util.Boolean

class StringTuple = CustomStringTuple::StringTuple<Chars::comma/0>::Tuple;

/**
 * A module that allows multiple values to be aggregated at the same time, where each value
 * (including the aggregated value) acts like a tuple.
 *
 * The tuple may contain any number of the following types of columns:
 * - `string` columns, which are concatenated with a separator
 * - `int` columns, which are summed
 *
 * Additionally, the unique values of each column can be counted, and the total number of unique
 * aggregated tuples can be counted.
 *
 * This can be useful for writing generic code where a module may wish to perform an unknown number
 * of aggregations in a context where it cannot perform the aggregation for itself.
 *
 * Each value to be aggregated should be of type `AggregableTuple::Piece`, and pieces should be
 * aggregated with `concat(Piece p | p, ",")`, as the underlying representation is a comma
 * -separated string (a `StringTuple`).
 *
 * After aggregation, the result should be cast to a `AggregableTuple::Sum` to access the
 * aggregated values of each column.
 *
 * Note: This will not be as performant as individual aggregations, and should only be used in cases
 * where a single aggregation is not practical.
 *
 * Example usage:
 * ```ql
 * // What values a "person" may aggregate over defined here:
 * AggregableTuple::Piece personAggregant(Person p) {
 *   result = AggregableTuple::initString(p.name)
 *            .appendInt(p.age)
 * }
 *
 * // A usage of that aggregation can be defined separately:
 * predicate useAggregation(AggregableTuple::Sum<two/0>::Sum aggregated) {
 *   exists(int counted, string names, int totalAge |
 *     counted = aggregated.getCountTotal() and
 *     names = aggregated.getAsJoinedString(0, ",") and
 *     totalAge = aggregated.getAsSummedInt(1) and
 *     // Use `counted`, `names`, and `totalAge` as needed
 *   )
 * }
 * ```
 */
module AggregableTuple {
  /**
   * Begin the construction of a new piece of an aggregable tuple with a `string` column.
   *
   * Sets the first column of this tuple to be the given `string` value. The `Piece`
   * returned by this predicate can have additional columns appended to it of any type.
   */
  bindingset[s]
  Piece initString(string s) { result = s }

  /**
   * Begin the construction of a new piece of an aggregable tuple with an `int` column.
   *
   * Sets the first column of this tuple to be the given `int` value. The `Piece`
   * returned by this predicate can have additional columns appended to it of any type.
   */
  bindingset[i]
  Piece initInt(int i) { result = i.toString() }

  /**
   * A piece of an aggregable tuple, which can be used to aggregate multiple values at the same
   * time.
   *
   * This class can be built up one column at a time, beginning with one of the predicates `asInc`,
   * `asString`, or `asInt`. Additional columns can be appended to the piece using the `appendInc`,
   * `appendString`, or `appendInt` predicates.
   *
   * After all of the columns have been appended, the piece can be aggregated with
   * `concat(Piece p | p, ",")`. Then the result can be cast to `AggregableTuple::Sum` to access the
   * aggregated values of each column.
   */
  bindingset[this]
  class Piece extends InfInstance<StringTuple>::Type {
    bindingset[this, s]
    Piece appendString(string s) { result = inst().append(s) }

    bindingset[this, i]
    Piece appendInt(int i) { result = inst().append(i.toString()) }
  }

  module Sum<Nullary::Ret<int>::pred/0 columns> {
    bindingset[this]
    class Sum extends InfInstance<StringTuple>::Type {
      bindingset[this]
      int getCountTotal() { result = inst().size() / columns() }

      /**
       * Since the underlying representation is a comma-separated string, the ith value of
       * the nth column can be found at the index `i * columns() + n`.
       *
       * This predicate returns all such indexes for the nth column.
       */
      bindingset[this]
      int getARawColumnValueIndex(int colIdx) {
        colIdx in [0 .. columns()] and
        exists(int rowIdx |
          rowIdx = [0 .. getCountTotal() - 1] and
          result = rowIdx * columns() + colIdx
        )
      }

      /**
       * Get all of the raw string values for the nth column of aggregated tuples.
       */
      bindingset[this]
      string getARawColumn(int colIdx) {
        colIdx in [0 .. columns()] and
        result = inst().get(getARawColumnValueIndex(colIdx))
      }

      bindingset[this]
      int countColumn(int colIdx) {
        colIdx in [0 .. columns()] and
        result = count(string item | item = getARawColumn(colIdx))
      }

      /**
       * Get the nth column of aggregated tuples, treated as strings and joined with the given
       * separator.
       */
      bindingset[this, sep]
      string getAsJoinedString(int colIdx, string sep) {
        colIdx in [0 .. columns()] and
        result = concat(string item | item = getARawColumn(colIdx) | item, sep)
      }

      /**
       * Get the nth column of aggregated tuples, treated as integers and summed.
       */
      bindingset[this]
      int getAsSummedInt(int colIdx) {
        colIdx in [0 .. columns()] and
        result = sum(int item | item = getARawColumn(colIdx).toInt())
      }
    }
  }
}
