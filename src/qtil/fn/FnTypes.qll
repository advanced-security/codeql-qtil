/**
 * A module that defines the the same predicate signature types of `SignaturePredicates.qll`, but
 * under the following definitions:
 * - `TpX<A, B, C>` - a "Tuple predicate" with three bound arguments.
 * - `FnX<R, A, B, C>` - a "Function predicate" with three unbound arguments and a result.
 * - `RelX<R, A, B, C>` - a "Relation predicate" with three bound arguments and a finite result.
 * - `PropX<A, B, C>` - a "Property predicate" with three unbound arguments and no result.
 * 
 * See documentation of the fn module for more details on what these types mean.
 */
import qtil.fn.generated.Types