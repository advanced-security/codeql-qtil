/**
 * A module to create queries that have a message format with parameters and placeholders, without
 * worrying about the placeholder ordering.
 *
 * Imagine implementing a query with the following types of results, where parenthesizes indicate
 * placeholders with links.
 *  - "Variable (foo) is passed to function (bar) with constant value (-1)."
 *  - "Constant value (-1) is passed to function (bar)."
 *  - "Variable (foo) is unused with constant value (-1)."
 *
 * In an ordinary "problem" query, this might be tedious and involve something like the following,
 * before you can even start writing the query:
 *
 * ```ql
 * abstract class TypeOfProblem extends ... {
 *   Element getElement();
 *   string getMessage();
 *   Element getPlacolderElement1();
 *   string getPlaceholderString1();
 *   Element getPlacolderElement2();
 *   string getPlaceholderString2();
 *   Element getPlacolderElement3();
 *   string getPlaceholderString3();
 * }
 * ...
 * from TypeOfProblem p where ...
 * select p.getElement(), p.getMessage(), p.getPlaceholderElement1(), p.getPlaceholderString1(),
 *   ...
 * ```
 *
 * By using this module, you can skip the boilerplate and go straight to defining the types of
 * results your query will report:
 *
 * ```
 * import qtil.cpp.format.QLFormat
 * predicate problem(Element elem, Template msg) {
 *   ... and
 *   msg = tpl("Variable {var} is passed to function {func} with constant value {val}.")
 *       .link("var", var)
 *       .link("func", func)
 *       .link("val", val)
 *   or ... and
 *   msg = tpl("Constant value {val} is passed to function {func}.")
 *      .link("func", func)
 *      .link("val", val)
 *   or ...
 * }
 *
 * import Problem<problem/2>::Query
 * ```
 */

private import qtil.inheritance.UnderlyingString
private import qtil.inheritance.Finitize
private import qtil.parameterization.Finalize
private import qtil.parameterization.SignaturePredicates
private import codeql.util.Location
private import qtil.locations.StringLocation
private import qtil.tuple.Pair
private import qtil.locations.OptionalLocation
private import qtil.locations.Locatable

/**
 * A module that offers a way of formatting CodeQL query messages in a consistent way, with varying
 * numbers of placeholders, via a template-like syntax. This module is useful for writing more
 * user-friendly messages for certain types of queries, with a cleaner query implementation.
 *
 * Typically, this module should not be instantiated by library consumers directly, but rather
 * should be imported from the language specific qtil pack, such as `qtil-cpp` or `qtil-java`.
 *
 * To add support for a new language, you can create a module that implements the `LocatableConfig`
 * module signature, that defines the `Locatable` class for that language.
 *
 * QlFormat can be used as follows:
 *
 * ```ql
 * import qtil.Cpp // or qtil.Java, etc.
 *
 * // Define a problem predicate for a Locatable and a Qtil::Template:
 * predicate problem(Locatable elem, Qtil::Template template) {
 *   exists(Variable var, FunctionCall fc |
 *     var = elem and
 *     fc = var.getInitializer().getAChild*() and
 *     template = Qtil::tpl("Initializer of variable '{name}' calls {fn}.")
 *       .text("name", var.getName())
 *       .link("fn", fc.getFunction().getName(), fc.getFunction())
 *   )
 * }
 *
 * // Import the Problem::Query module:
 * import Qtil::Problem<problem/2>::Query
 * ```
 *
 * The resulting query results will insert the variable name into the alert message, and insert a
 * placeholder link from the function name to the function itself.
 */
module QlFormat<LocationSig Location, LocatableConfig<Location> LocConfig> {
  private class Locatable = LocConfig::Locatable;

  bindingset[elem]
  pragma[inline]
  private StringLocation stringLocation(Locatable elem) {
    result = LocationToString<Location>::stringLocation(elem.getLocation())
  }

  /**
   * A function to create a template string with the given format.
   *
   * A template is a string that contains placeholders in the form of `{key}`. These placeholders
   * can be replaced with actual values using the `link` and `text` member predicates:
   * - `link("key", elem, "text")` will replace `{key}` with `text` and link it to `elem`.
   * - `link("key", elem)` will replace `{key}` with a link to `elem` using `elem.toString()`.
   * - `text("key", "text")` will replace `{key}` with `text` without linking it to any element.
   */
  bindingset[format]
  Template tpl(string format) { result = format }

  /**
   * A template class that allows for creating formatted strings with links and text replacements.
   *
   * To "create" a template, use the `tpl` function with a format string. A template string is a
   * string that contains placeholders in the form of `{key}`. To "use" the resulting template, bind
   * text and/or placeholder links to the keys via the `link` and `text` member predicates:
   * - `link("key", elem, "text")` will replace `{key}` with `text` and link it to `elem`.
   * - `link("key", elem)` will replace `{key}` with a link to `elem` using `elem.toString()`.
   * - `text("key", "text")` will replace `{key}` with `text` without linking it to any element.
   */
  bindingset[this]
  class Template extends Final<UnderlyingString>::Type {
    /**
     * Replaces a placeholder in the form of `{key}` with a link to the given element using the
     * given text.
     *
     * To automatically infer the text from the element's `toString()` method, use the
     * `link(string key, Locatable elem)` predicate instead.
     *
     * To bind text directly without linking it to an element, use the predicate
     * `text(string key, string text)`.
     */
    bindingset[this, key, text, elem]
    Template link(string key, Locatable elem, string text) {
      // TODO: use escaping to ensure no conflicts with the template syntax.
      result = this + "$" + key + "$" + text + "$" + stringLocation(elem) + "$"
    }

    /**
     * Replaces a placeholder in the form of `{key}` with a link to the given element using the
     * element's `toString()` method as the text.
     *
     * To use a custom text, use the `link(string key, Locatable elem, string text)` predicate.
     *
     * To bind text directly without linking it to an element, use the predicate
     * `text(string key, string text)`.
     */
    bindingset[this, key, elem]
    Template link(string key, Locatable elem) { result = link(key, elem, elem.toString()) }

    /**
     * Replaces a placeholder in the form of `{key}` with the given text without linking it to any
     * element.
     *
     * To replace the placeholder with a link to an element, use one of the `link` predicates:
     * - `link(string key, Locatable elem, string text)` will replace `{key}` with `text` and link it
     *   to `elem`.
     * - `link(string key, Locatable elem)` will replace `{key}` with a link to `elem` using
     *   `elem.toString()`.
     */
    bindingset[this, key, text]
    pragma[inline_late]
    Template text(string key, string text) { result = str().replaceAll("{" + key + "}", text) }

    /**
     * A predicate to find the index of a link in a template string, used to rewrite the template
     * with ordered `$@` placeholders.
     *
     * Generally only intended for internal use.
     */
    bindingset[this, idx]
    predicate hasLink(string key, string text, string stringLocation, int idx) {
      exists(int dlridx |
        dlridx = idx * 4 and
        key = str().splitAt("$", dlridx + 1) and
        text = str().splitAt("$", dlridx + 2) and
        stringLocation = str().splitAt("$", dlridx + 3)
      )
    }

    /**
     * A predicate to get the 'message' of the template string, which may still have placeholders in
     * the form of `{key}`.
     *
     * Generally only intended for internal use.
     */
    bindingset[this]
    string getMessage() { result = str().substring(0, str().indexOf("$", 0, 0)) }
  }

  /**
   * A module that allows the creation of "problems" with Template strings, and exposes a submodule
   * `Query` to turn those problems into query results.
   *
   * To use this module, create a predicate that matches `Locatable` elements to `Template`s, and
   * use that query to instantiate this module.
   *
   * ```ql
   * predicate problem(Locatable elem, Template msg) {
   *   msg = tpl("Variable named {var}").text("var", elem.(Variable).getName())
   * }
   *
   * // Create a query for these elements with the above template:
   * import Problem<problem/2>::Query
   *
   * // or, import the `Problem` class directly (for query reusability):
   * import Problem<problem/2>
   * ```
   */
  module Problem<Binary<Locatable, Template>::pred/2 problem> {
    /** A private predicate used to finitize the infinite class `Template`. */
    private predicate templateExists(Template str) { problem(_, str) }

    /**
     * A performance related class to prevent CodeQL from splitting template strings multiple times.
     * At this point, there are a finite set of templates, so using a finite type is generally
     * preferable and more performant.
     */
    private class FiniteTemplate extends Final<Finitize<Template, templateExists/1>::Type>::Type {
      /**
       * A predicate to find the index of a link in a template string, used to rewrite the template
       * with ordered `$@` placeholders.
       *
       * Generally only intended for internal use.
       */
      pragma[nomagic]
      predicate linkIdx(string key, int index, string text, string location) {
        // Perform the same concretization trick. There is a finite set of parameters within each
        // template, so we can use a finite type and get a large performance boost.
        "{" + key + "}" = this.str().regexpFind("\\{[a-zA-Z0-9_]+\\}", index, _) and
        super.hasLink(key, text, location, index)
      }
    }

    /**
     * A problem class containing the results identified by the `problem/2` predicate.
     *
     * Exposes the following useful member predicates:
     * - `getLocatable()` to get the `Locatable` element associated with the problem.
     * - `getMessage()` to get the message of the problem, which may still contain `{key}`
     *    placeholders.
     * - `getTemplate()` to get the `Template` associated with the problem.
     * - `getFormattedMessage()` to get the message with all placeholders replaced with `$@`.
     * - `getExtra(idx, str, optionalLocation)` to get placeholder information, where `idx`
     *   indicates the `nth` placeholder.
     */
    class Problem extends Final<Pair<Locatable, Template, problem/2>::Pair>::Type {
      /**
       * Get the `Locatable` element associated with the problem.
       */
      Locatable getLocatable() { result = this.getFirst() }

      /**
       * Get the message of the problem, which may still contain placeholders in the form of `{key}`.
       *
       * To get the message with all placeholders replaced with `$@`, use the
       * `getFormattedMessage()` predicate instead.
       */
      string getMessage() { result = getTemplate().getMessage() }

      /**
       * Get the `Template` associated with the problem, which contains the format string and
       * placeholders.
       */
      FiniteTemplate getTemplate() { result = this.getSecond() }

      /**
       * Get the message with all placeholders replaced with `$@`, which is required for presenting
       * query results in a user-friendly way in CodeQL.
       *
       * To get the message with `{key}` placeholders still present, use `getMessage()`.
       */
      string getFormattedMessage() {
        result = getMessage().regexpReplaceAll("\\{[a-zA-Z0-9_]+\\}", "\\$@")
      }

      /**
       * A private predicate to check if the problem has an `nth` placeholder link.
       */
      private predicate hasLinkIndex(int idx) { getTemplate().linkIdx(_, idx, _, _) }

      /**
       * Get the text and string location of the `nth` placeholder link, if it exists.
       */
      private predicate hasFormattedLink(int idx, string str, string elem) {
        getTemplate().linkIdx(_, idx, str, elem)
      }

      /**
       * Get the `nth` placeholder link, if it exists, or a default value if it does not.
       *
       * The `idx` parameter indicates the `nth` placeholder link, starting from 0.
       * The `str` parameter is the text to replace the placeholder with, or "[unused]" if there is
       * no link at that index.
       * The `elem` parameter is an optional location that can be used to link to an element. If it
       * exists, `elem.asSome()` will return the location. Otherwise, `elem.isNone()` will hold.
       */
      bindingset[idx]
      predicate getExtra(int idx, string str, OptionalLocation elem) {
        if hasLinkIndex(idx)
        then
          exists(StringLocation loc |
            hasFormattedLink(idx, str, loc) and
            elem.asSome().toString() = loc
          )
        else (
          elem.isNone() and
          str = "[unused]"
        )
      }
    }

    /** A predicate for usage with the FinitizedStringLocation module, for performance. */
    private predicate existsStrLoc(StringLocation str) {
      exists(Problem p | p.getTemplate().linkIdx(_, _, _, str))
    }

    // The problem predicate is now fully known, and the set of locations is finite. Use a finite
    // type to hold the locations to avoid redundant string splitting. This makes a huge
    // difference in performance.
    private class FiniteLocation = FinitizeStringLocation<existsStrLoc/1>::Location;

    /**
     * A class representing a placeholder location that may or may not exist.
     *
     * If it exists, `.asSome()` will return the location, and if the location does not exist,
     * then `.isNone()` will hold.
     */
    class OptionalLocation = OptionalLocation<FiniteLocation>::Location;

    /**
     * A module that selects the `Problem` instances that match the given `Locatable` and
     * `Template` parameters, and provides a query to find problems with specific messages and
     * placeholder links.
     */
    module Query {
      /**
       * The query predicate that CodeQL uses to create alerts for the identified `Problem`s.
       */
      query predicate problems(
        Locatable loc, string msg, OptionalLocation elem1, string str1, OptionalLocation elem2,
        string str2
      ) {
        exists(Problem p |
          p.getLocatable() = loc and
          p.getFormattedMessage() = msg and
          p.getExtra(0, str1, elem1) and
          p.getExtra(1, str2, elem2)
        )
      }
    }
  }
}
