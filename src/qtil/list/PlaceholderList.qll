/**
 * A module for combining multiple placeholder results into a single alert message, when
 * there may be a variable number of placeholder values per element.
 *
 * When a query finds multiple related elements (placeholders) for a single alert element,
 * this module combines them into a single alert with a formatted list message.
 *
 * For example, given a predicate:
 * ```ql
 * predicate problems(Element e, string msg, Placeholder p, string pStr) {
 *   e.meetsSomeCondition() and
 *   p.meetsSomeOtherCondition() and
 *   e.isSomehowRelatedTo(p) and
 *   msg = e.toString() + " is related to $@." and
 *   pStr = p.toString()
 * }
 * ```
 *
 * If element `e` is related to a single placeholder, the message will be:
 *   "foo is related to $@."
 * If element `e` is related to two placeholders, the message will be:
 *   "foo is related to $@ and $@."
 * If element `e` is related to three placeholders, the message will be:
 *   "foo is related to $@, $@, and $@."
 * If element `e` is related to more than `maxResults()` placeholders, the message will be:
 *   "foo is related to $@, $@, $@, $@, $@, and N more."
 *
 * To use this module, define a configuration module that implements `PlaceholderListSig`:
 * ```ql
 * module MyConfig implements PlaceholderListSig<MyElement, MyPlaceholder> {
 *   predicate problems(MyElement e, string msg, MyPlaceholder p, string pStr) { ... }
 *   int maxResults() { result = 5 }
 *   string orderBy(MyPlaceholder p) { result = p.toString() }
 * }
 *
 * import PlaceholderList<MyElement, MyPlaceholder, MyConfig>
 * ```
 */

private import qtil.parameterization.SignatureTypes

/**
 * A signature module for `PlaceholderList` configuration.
 *
 * Implement this module to provide the `problems` predicate and optional configuration.
 *
 * The `problems` predicate should associate each element with a message template (containing
 * exactly one `$@` placeholder) and zero or more `(placeholder, string)` pairs.
 *
 * The `maxResults` predicate controls how many placeholders are shown per alert.
 * If there are more placeholders than `maxResults()`, the remaining count is included in the
 * message as plain text: "and N more".
 *
 * The `orderBy` predicate controls the order in which placeholders are presented.
 *
 * Example:
 * ```ql
 * module MyConfig implements PlaceholderListSig<Function, Variable> {
 *   predicate problems(Function f, string msg, Variable v, string vStr) {
 *     v = f.getAParameter() and
 *     msg = f.getName() + " has parameter $@." and
 *     vStr = v.getName()
 *   }
 *   int maxResults() { result = 5 }
 *   string orderBy(Variable v) { result = v.getName() }
 * }
 * ```
 */
signature module PlaceholderListSig<FiniteStringableType Element, FiniteStringableType Placeholder> {
  /**
   * Defines problems as a set of (element, message, placeholder, placeholderString) tuples.
   *
   * For a given `(element, message)` pair, there may be multiple `(placeholder, placeholderString)`
   * results — one for each related element. The message should contain exactly one `$@` placeholder,
   * which will be expanded by the `PlaceholderList` module into the appropriate list format.
   */
  predicate problems(Element e, string msg, Placeholder p, string pStr);

  /**
   * The maximum number of placeholders to show per alert. When there are more placeholders than
   * this limit, the message will include "and N more" as plain text.
   *
   * The effective maximum is capped at 5, which is the number of placeholder pairs in the output
   * query predicate.
   *
   * Defaults to 5.
   */
  default int maxResults() { result = 5 }

  /**
   * An ordering key used to sort placeholders within each alert. Placeholders are shown in
   * ascending order by this key.
   *
   * Defaults to the string representation of the placeholder.
   */
  default string orderBy(Placeholder p) { result = p.toString() }
}

/**
 * A module for combining multiple placeholder results into a single alert message.
 *
 * This module takes a `problems` predicate that may have multiple `(placeholder, string)` pairs
 * for a single `(element, message)` pair, and combines them into a single output row with an
 * expanded message. Up to five placeholder pairs are shown; additional placeholders are
 * represented as "and N more" in the message text.
 *
 * The output `query predicate problems` always has exactly 5 placeholder pairs. When there are
 * fewer than 5 actual placeholders, the remaining slots are filled with the first placeholder
 * and an empty string (so they are not highlighted in the UI).
 *
 * See `PlaceholderListSig` for configuration options.
 */
module PlaceholderList<
  FiniteStringableType Element, FiniteStringableType Placeholder,
  PlaceholderListSig<Element, Placeholder> Config>
{
  /**
   * Count the number of distinct placeholder values for a given `(element, message)` pair.
   */
  private int countPlaceholders(Element e, string msg) {
    Config::problems(e, msg, _, _) and
    result = count(Placeholder p | Config::problems(e, msg, p, _))
  }

  /**
   * Get the `n`th (1-based) placeholder for a given `(element, message)` pair, ordered
   * ascending by `Config::orderBy`, with the placeholder's `toString()` as a secondary sort key.
   */
  private Placeholder getNthPlaceholder(Element e, string msg, int n) {
    result =
      rank[n](Placeholder p | Config::problems(e, msg, p, _) |
        p order by Config::orderBy(p), p.toString()
      )
  }

  /**
   * Get the string representation of the `n`th placeholder for a given `(element, message)` pair.
   *
   * If the same placeholder has multiple string representations in the input predicate, the
   * lexicographically smallest one is used.
   */
  private string getNthPlaceholderStr(Element e, string msg, int n) {
    Config::problems(e, msg, _, _) and
    result =
      min(string pStr |
        Config::problems(e, msg, getNthPlaceholder(e, msg, n), pStr)
      |
        pStr
      )
  }

  /**
   * Build the placeholder part of the expansion string (without "and N more" suffix).
   *
   * Returns the comma-separated (with Oxford comma) list of `$@` placeholders for `n` items.
   */
  bindingset[n]
  private string placeholderExpansion(int n) {
    n = 1 and result = "$@"
    or
    n = 2 and result = "$@ and $@"
    or
    n = 3 and result = "$@, $@, and $@"
    or
    n = 4 and result = "$@, $@, $@, and $@"
    or
    n = 5 and result = "$@, $@, $@, $@, and $@"
  }

  /**
   * Build the overflow suffix for the expansion string.
   *
   * Returns `""` when `moreCount = 0` (no overflow), or `" and N more"` when there are
   * additional placeholders beyond the visible maximum.
   */
  bindingset[moreCount]
  private string moreString(int moreCount) {
    moreCount = 0 and result = ""
    or
    moreCount > 0 and result = " and " + moreCount + " more"
  }

  /**
   * Build the full expansion string that replaces the single `$@` placeholder in the original
   * message.
   *
   * `showCount` is the number of `$@` placeholders to include (1–5), and `moreCount` is the
   * number of additional placeholders not shown (0 or more).
   */
  bindingset[showCount, moreCount]
  private string expansion(int showCount, int moreCount) {
    result = placeholderExpansion(showCount) + moreString(moreCount)
  }

  /**
   * Get the effective number of placeholders to show for a given `(element, message)` pair.
   *
   * This is the minimum of the total placeholder count and `Config::maxResults()`, capped at 5
   * (the number of placeholder pairs in the output query predicate).
   */
  private int showCount(Element e, string msg) {
    exists(int total, int maxR, int cappedMax |
      total = countPlaceholders(e, msg) and
      maxR = Config::maxResults() and
      (maxR <= 5 and cappedMax = maxR or maxR > 5 and cappedMax = 5) and
      (total <= cappedMax and result = total or total > cappedMax and result = cappedMax)
    )
  }

  /**
   * Get the expanded message for a given `(element, message)` pair, with the single `$@`
   * in the original message replaced by the appropriate comma-separated list of `$@` placeholders
   * and optional "and N more" suffix.
   */
  private string expandedMsg(Element e, string origMsg) {
    exists(int total, int sc, int mc |
      total = countPlaceholders(e, origMsg) and
      sc = showCount(e, origMsg) and
      (total > sc and mc = total - sc or total <= sc and mc = 0) and
      result = origMsg.replaceAll("$@", expansion(sc, mc))
    )
  }

  /**
   * The combined problems query predicate.
   *
   * For each `(element, message)` pair in the input `Config::problems` predicate, this produces
   * a single output row with an expanded message and up to 5 placeholder pairs.
   *
   * The message is expanded from the single `$@` in the input to a comma-separated list of `$@`
   * placeholders (up to `Config::maxResults()`, capped at 5), with "and N more" appended if there
   * are additional placeholders beyond the maximum.
   *
   * Placeholder pairs beyond the number of actual placeholders are filled with the first
   * placeholder value and an empty string, so they are not highlighted in the UI.
   */
  query predicate problems(
    Element e, string outMsg,
    Placeholder p1, string str1,
    Placeholder p2, string str2,
    Placeholder p3, string str3,
    Placeholder p4, string str4,
    Placeholder p5, string str5
  ) {
    exists(string origMsg, int sc |
      Config::problems(e, origMsg, _, _) and
      outMsg = expandedMsg(e, origMsg) and
      sc = showCount(e, origMsg) and
      p1 = getNthPlaceholder(e, origMsg, 1) and
      str1 = getNthPlaceholderStr(e, origMsg, 1) and
      (
        sc >= 2 and
        p2 = getNthPlaceholder(e, origMsg, 2) and
        str2 = getNthPlaceholderStr(e, origMsg, 2)
        or
        sc < 2 and p2 = p1 and str2 = ""
      ) and
      (
        sc >= 3 and
        p3 = getNthPlaceholder(e, origMsg, 3) and
        str3 = getNthPlaceholderStr(e, origMsg, 3)
        or
        sc < 3 and p3 = p1 and str3 = ""
      ) and
      (
        sc >= 4 and
        p4 = getNthPlaceholder(e, origMsg, 4) and
        str4 = getNthPlaceholderStr(e, origMsg, 4)
        or
        sc < 4 and p4 = p1 and str4 = ""
      ) and
      (
        sc >= 5 and
        p5 = getNthPlaceholder(e, origMsg, 5) and
        str5 = getNthPlaceholderStr(e, origMsg, 5)
        or
        sc < 5 and p5 = p1 and str5 = ""
      )
    )
  }
}

