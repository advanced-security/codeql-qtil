/**
 * A module for limiting the number of results reported per finding to at most `N`, while appending
 * an "and M more" suffix to the message when there are additional results beyond the limit.
 *
 * This is useful for queries that find multiple related entities per finding (such as fields,
 * parameters, or call sites) but where listing all of them would be too noisy. Instead, only the
 * top `N` entities are reported (ordered by `placeholderString()`), and the message notes how many
 * were omitted.
 *
 * ## Usage
 *
 * Implement the `LimitResultsConfigSig` signature and instantiate the `LimitResults` module. Only
 * `problem` and `message` are required — `placeholderString` and `maxResults` have sensible
 * defaults:
 *
 * ```ql
 * module MyConfig implements LimitResultsConfigSig<MyFinding, MyEntity> {
 *   predicate problem(MyFinding finding, MyEntity entity) {
 *     entity = finding.getAnEntity()
 *   }
 *
 *   bindingset[remaining]
 *   string message(MyFinding finding, MyEntity entity, string remaining) {
 *     result = "Finding $@ has entity $@" + remaining + "."
 *   }
 * }
 *
 * module Results = LimitResults<MyFinding, MyEntity, MyConfig>;
 * ```
 *
 * The instantiated module exposes a `problems` query predicate that can be used directly as
 * the output of a query without any `from`/`where`/`select` boilerplate:
 *
 * ```ql
 * module Results = LimitResults<MyFinding, MyEntity, MyConfig>;
 * // The query predicate Results::problems(...) is automatically part of the query output.
 * ```
 */

private import qtil.parameterization.SignatureTypes

/**
 * A signature for configuring the `LimitResults` module.
 *
 * Only `problem` and `message` must be implemented. The predicates `placeholderString` and
 * `maxResults` have defaults and may be overridden.
 */
signature module LimitResultsConfigSig<FiniteStringableType Finding, FiniteStringableType Entity> {
  /**
   * The relationship between findings and their associated entities.
   *
   * Defines which entities are relevant to a given finding. All entities satisfying this predicate
   * will be counted, but only the top `maxResults()` (ordered by `placeholderString()`) will be
   * reported.
   */
  predicate problem(Finding finding, Entity entity);

  /**
   * Builds the message for the finding, incorporating the "and N more" remaining string.
   *
   * The `remaining` parameter is either an empty string (when all entities are shown) or a string
   * like `" (and 2 more)"` when some entities are omitted. The message should embed `remaining`
   * appropriately, for example: `result = "Foo is broken" + remaining + "."`.
   */
  bindingset[remaining]
  string message(Finding finding, Entity entity, string remaining);

  /**
   * The display string for an entity, also used as the ordering key (ascending).
   *
   * Entities with smaller placeholder strings are reported first. When the total count exceeds
   * `maxResults()`, only the first `maxResults()` entities by this ordering are reported.
   *
   * Defaults to `entity.toString()`.
   */
  default string placeholderString(Entity entity) { result = entity.toString() }

  /**
   * The maximum number of entities to report per finding.
   *
   * When the total number of entities for a finding exceeds this value, only the first
   * `maxResults()` entities (by `placeholderString()`) are reported, and the message includes a
   * `" (and N more)"` suffix indicating the number of omitted entities.
   *
   * Defaults to `3`.
   */
  default int maxResults() { result = 3 }
}

/**
 * A module that limits the number of results reported per finding, appending an "and N more"
 * suffix when additional entities exist beyond the configured maximum.
 *
 * The `problems` query predicate is the main entry point for use in a query. When this module is
 * instantiated as `module Results = LimitResults<...>`, the predicate `Results::problems` is
 * automatically part of the query output — no `from`/`where`/`select` boilerplate is needed.
 *
 * See `LimitResultsConfigSig` for configuration details.
 */
module LimitResults<FiniteStringableType Finding, FiniteStringableType Entity, LimitResultsConfigSig<Finding, Entity> Config> {
  /**
   * A query predicate that reports findings alongside one of their top-ranked entities and a
   * formatted message. This is the primary way to use this module in a query.
   *
   * Each result tuple `(finding, msg, entity, entityStr)` corresponds to one of the top-ranked
   * entities for a finding. `entityStr` is `Config::placeholderString(entity)`, suitable for use
   * as the placeholder text in a `select` column alongside `entity`.
   *
   * At most `Config::maxResults()` entities are reported per finding.
   */
  query predicate problems(Finding finding, string msg, Entity entity, string entityStr) {
    hasLimitedResult(finding, entity, msg) and
    entityStr = Config::placeholderString(entity)
  }

  /**
   * Holds for each finding and one of its top-ranked entities, providing the formatted message.
   *
   * At most `Config::maxResults()` entities are reported per finding. They are selected by ranking
   * all entities satisfying `Config::problem(finding, entity)` in ascending order of
   * `Config::placeholderString(entity)`, and taking those with rank <= `Config::maxResults()`.
   *
   * The `message` is produced by `Config::message(finding, entity, remaining)`, where `remaining`
   * is `" (and N more)"` if the total exceeds `Config::maxResults()`, or `""` otherwise.
   */
  predicate hasLimitedResult(Finding finding, Entity entity, string message) {
    exists(int total, int ranked, string remaining |
      total = count(Entity e | Config::problem(finding, e)) and
      entity =
        rank[ranked](Entity e | Config::problem(finding, e) |
          e order by Config::placeholderString(e)
        ) and
      ranked <= Config::maxResults() and
      (
        total > Config::maxResults() and
        remaining = " (and " + (total - Config::maxResults()) + " more)"
        or
        total <= Config::maxResults() and remaining = ""
      ) and
      message = Config::message(finding, entity, remaining)
    )
  }
}
