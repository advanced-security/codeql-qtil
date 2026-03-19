/**
 * A module for limiting the number of results reported per finding to at most `N`, while appending
 * an "and M more" suffix to the message when there are additional results beyond the limit.
 *
 * This is useful for queries that find multiple related entities per finding (such as fields,
 * parameters, or call sites) but where listing all of them would be too noisy. Instead, only the
 * top `N` entities are reported (ordered by a configurable key), and the message notes how many
 * were omitted.
 *
 * ## Usage
 *
 * Implement the `LimitResultsConfigSig` signature and instantiate the `LimitResults` module:
 *
 * ```ql
 * module MyConfig implements LimitResultsConfigSig<MyFinding, MyEntity> {
 *   predicate problem(MyFinding finding, MyEntity entity) {
 *     entity = finding.getAnEntity()
 *   }
 *
 *   string message(MyFinding finding, MyEntity entity, string remaining) {
 *     result = "Finding $@ has entity $@" + remaining + "."
 *   }
 *
 *   string orderBy(MyEntity entity) { result = entity.getName() }
 *
 *   int maxResults() { result = 3 }
 * }
 *
 * module Results = LimitResults<MyFinding, MyEntity, MyConfig>;
 *
 * from MyFinding finding, MyEntity entity, string message
 * where Results::hasLimitedResult(finding, entity, message)
 * select finding, message, entity, entity.getName()
 * ```
 */

private import qtil.parameterization.SignatureTypes

/**
 * A signature for configuring the `LimitResults` module.
 *
 * Implement this signature in a module to define the relationship between findings and entities,
 * the message format, the ordering of entities, and the maximum number of results to show per
 * finding.
 */
signature module LimitResultsConfigSig<FiniteType Finding, FiniteType Entity> {
  /**
   * The relationship between findings and their associated entities.
   *
   * Defines which entities are relevant to a given finding. All entities satisfying this predicate
   * will be counted, but only the top `maxResults()` (ordered by `orderBy()`) will be reported.
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
   * The key to use when ordering entities within a finding (ascending).
   *
   * Entities with smaller order keys are reported first. When the total count exceeds
   * `maxResults()`, only the first `maxResults()` entities by this ordering are reported.
   */
  string orderBy(Entity entity);

  /**
   * The maximum number of entities to report per finding.
   *
   * When the total number of entities for a finding exceeds this value, only the first
   * `maxResults()` entities (by `orderBy()`) are reported, and the message includes a
   * `" (and N more)"` suffix indicating the number of omitted entities.
   */
  int maxResults();
}

/**
 * A module that limits the number of results reported per finding, appending an "and N more"
 * suffix when additional entities exist beyond the configured maximum.
 *
 * Use `hasLimitedResult` as the body of a `where` clause in a `select` statement. Each result
 * tuple corresponds to one of the top-ranked entities for a finding, together with the formatted
 * message that includes the remaining count suffix when applicable.
 *
 * See `LimitResultsConfigSig` for configuration details.
 */
module LimitResults<FiniteType Finding, FiniteType Entity, LimitResultsConfigSig<Finding, Entity> Config> {
  /**
   * Holds for each finding and one of its top-ranked entities, providing the formatted message.
   *
   * At most `Config::maxResults()` entities are reported per finding. They are selected by ranking
   * all entities satisfying `Config::problem(finding, entity)` in ascending order of
   * `Config::orderBy(entity)`, and taking those with rank <= `Config::maxResults()`.
   *
   * The `message` is produced by `Config::message(finding, entity, remaining)`, where `remaining`
   * is `" (and N more)"` if the total exceeds `Config::maxResults()`, or `""` otherwise.
   */
  predicate hasLimitedResult(Finding finding, Entity entity, string message) {
    exists(int total, int ranked, string remaining |
      total = count(Entity e | Config::problem(finding, e)) and
      entity =
        rank[ranked](Entity e | Config::problem(finding, e) | e order by Config::orderBy(e)) and
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
