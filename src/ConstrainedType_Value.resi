type t<'value, 'id>
let make: (
  'value,
  ~constraint_: ConstrainedType_Constraint.t<'value, 'id>,
) => option<t<'value, 'id>>

exception ConstraintUnsatisfied
let makeExn: ('value, ~constraint_: ConstrainedType_Constraint.t<'value, 'id>) => t<'value, 'id>

let makeUnsafe: ('value, ~constraint_: ConstrainedType_Constraint.t<'value, 'id>) => t<'value, 'id>

let value: t<'value, 'id> => 'value

module All: {
  let make: 'value => t<'value, ConstrainedType_Constraint.All.identity>
}
