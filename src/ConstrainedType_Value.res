module Constraint = ConstrainedType_Constraint

type t<'value, 'id> = 'value
let make = (type value id, value: value, ~constraint_: Constraint.t<value, id>) => {
  switch constraint_->Constraint.isSatisfied(value) {
  | true => Some(value)
  | false => None
  }
}

exception ConstraintUnsatisfied
let makeExn = (value: 'value, ~constraint_: Constraint.t<'value, 'id>) =>
  switch make(value, ~constraint_) {
  | Some(value) => value
  | None => raise(ConstraintUnsatisfied)
  }

let makeUnsafe = (value: 'value, ~constraint_: Constraint.t<'value, 'id>) => {
  constraint_->ignore
  value
}

let value = value => value

exception AssertionFailure
let assertConstraint = (value, ~constraint_) => {
  switch constraint_->Constraint.isSatisfied(value) {
  | true => ()
  | false => raise(AssertionFailure)
  }
}

module All = {
  let make = value => value
}
