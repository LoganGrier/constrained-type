type t<'value, 'id>

/**
@param value
@param ~constraint_
@return Some(value) if ~constraint_(value) returns true. None otherwise
@throws Any exception thrown by constraint_
*/
let make: (
  'value,
  ~constraint_: ConstrainedType_Constraint.t<'value, 'id>,
) => option<t<'value, 'id>>

exception ConstraintUnsatisfied

/**
@param value
@param ~constraint_
@return value if ~constraint_(value) returns true
@throws ConstraintUnsatisfied if ~constraint_(value) returns false
@throws Any exception thrown by constraint_
*/
let makeExn: ('value, ~constraint_: ConstrainedType_Constraint.t<'value, 'id>) => t<'value, 'id>

/**
@param value
@param ~constraint_
@return value
@property Does not execute constraint_ on value
*/
let makeUnsafe: ('value, ~constraint_: ConstrainedType_Constraint.t<'value, 'id>) => t<'value, 'id>

/**
@param constrainedValue
@return The argument, as an unconstrained value
*/
let value: t<'value, 'id> => 'value

module All: {
  /**
  @param value
  @return value, constrained with the "All" constraint
  */
  let make: 'value => t<'value, ConstrainedType_Constraint.All.identity>
}
