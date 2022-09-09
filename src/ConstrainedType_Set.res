module Value = ConstrainedType_Value
module Constraint = ConstrainedType_Constraint

type makeError<'value, 'cmpId> = InvalidEntries(Belt.Set.t<'value, 'cmpId>)
// Warning: castSet is only safe because Set is immutable and Value.t<'value, 'id> = 'value
external castSet: Belt.Set.t<'value, 'cmpId> => Belt.Set.t<Value.t<'value, 'cntId>, 'cmpId> =
  "%identity"
let make = (arg: Belt.Set.t<'value, 'cmpId>, ~constraint_: Constraint.t<'value, 'cntId>) => {
  let invalidEntries =
    arg->Belt.Set.keepU((. entry) => !(constraint_->Constraint.isSatisfied(entry)))
  if invalidEntries->Belt.Set.size > 0 {
    Error(InvalidEntries(invalidEntries))
  } else {
    Ok(castSet(arg))
  }
}
exception InvalidEntriesException
let makeExn = (arg, ~constraint_: Constraint.t<'value, 'cntId>) =>
  switch make(arg, ~constraint_) {
  | Ok(val) => val
  | Error(InvalidEntries(_)) => raise(InvalidEntriesException)
  }

let makeUnsafe = (arg, ~constraint_: Constraint.t<'value, 'cntId>) => {
  constraint_->ignore
  castSet(arg)
}

// This is just the inverse of castSet
external value: Belt.Set.t<Value.t<'value, 'cntId>, 'cmpId> => Belt.Set.t<'value, 'cmpId> =
  "%identity"
