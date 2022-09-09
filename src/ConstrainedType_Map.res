module Value = ConstrainedType_Value
module Constraint = ConstrainedType_Constraint

// Warning: castMap is only safe because Map is immutable, Value.t<'key, 'id> = 'key, and Value.t<'value, 'id> = 'value
external castMap: Belt.Map.t<'key, 'value, 'cmpId> => Belt.Map.t<
  Value.t<'key, 'keyCntId>,
  Value.t<'value, 'valueCntId>,
  'cmpId,
> = "%identity"
type makeError<'key, 'value, 'cmpId> = InvalidEntries(Belt.Map.t<'key, 'value, 'cmpId>)
let make = (
  arg,
  ~keyConstraint: Constraint.t<'key, 'keyCntId>,
  ~valueConstraint: Constraint.t<'value, 'valueCntId>,
) => {
  let invalidEntries =
    arg->Belt.Map.keepU((. key, value) =>
      !(keyConstraint->Constraint.isSatisfied(key)) ||
      !(valueConstraint->Constraint.isSatisfied(value))
    )
  if invalidEntries->Belt.Map.size > 0 {
    Error(InvalidEntries(invalidEntries))
  } else {
    Ok(castMap(arg))
  }
}
exception InvalidEntriesException
let makeExn = (
  arg,
  ~keyConstraint: Constraint.t<'key, 'keyCntId>,
  ~valueConstraint: Constraint.t<'value, 'valueCntId>,
) => {
  switch make(arg, ~keyConstraint, ~valueConstraint) {
  | Ok(val) => val
  | Error(InvalidEntries(_entries)) => raise(InvalidEntriesException)
  }
}

let makeUnsafe = (
  arg,
  ~keyConstraint: Constraint.t<'key, 'keyCntId>,
  ~valueConstraint: Constraint.t<'value, 'valueCntId>,
) => {
  keyConstraint->ignore
  valueConstraint->ignore
  castMap(arg)
}

// This is just the inverse of castSet
external value: Belt.Map.t<
  Value.t<'key, 'keyCntId>,
  Value.t<'value, 'valueCntId>,
  'cmpId,
> => Belt.Map.t<'key, 'value, 'cmpId> = "%identity"

module KeyOnly = {
  // Warning: castMap is only safe because Map is immutable, Value.t<'key, 'id> = 'key, and Value.t<'value, 'id> = 'value
  external castMap: Belt.Map.t<'key, 'value, 'cmpId> => Belt.Map.t<
    Value.t<'key, 'keyCntId>,
    'value,
    'cmpId,
  > = "%identity"
  let make = (arg: Belt.Map.t<'key, 'value, 'cmpId>, keyConstraint) => {
    let invalidEntries =
      arg->Belt.Map.keepU((. key, _value) => !(keyConstraint->Constraint.isSatisfied(key)))
    if invalidEntries->Belt.Map.size > 0 {
      Error(InvalidEntries(invalidEntries))
    } else {
      Ok(castMap(arg))
    }
  }
  let makeExn = (arg, keyConstraint) => {
    switch make(arg, keyConstraint) {
    | Ok(val) => val
    | Error(InvalidEntries(_entries)) => raise(InvalidEntriesException)
    }
  }

  let makeUnsafe = (arg, keyConstraint) => {
    keyConstraint->ignore
    castMap(arg)
  }

  // This is just the inverse of castSet
  external value: Belt.Map.t<Value.t<'key, 'keyCntId>, 'value, 'cmpId> => Belt.Map.t<
    'key,
    'value,
    'cmpId,
  > = "%identity"
}

module ValueOnly = {
  // Warning: castMap is only safe because Map is immutable, Value.t<'key, 'id> = 'key, and Value.t<'value, 'id> = 'value
  external castMap: Belt.Map.t<'key, 'value, 'cmpId> => Belt.Map.t<
    'key,
    Value.t<'value, 'valueCntId>,
    'cmpId,
  > = "%identity"
  let make = (arg, valueConstraint) => {
    let invalidEntries =
      arg->Belt.Map.keepU((. _key, value) => !(valueConstraint->Constraint.isSatisfied(value)))
    if invalidEntries->Belt.Map.size > 0 {
      Error(InvalidEntries(invalidEntries))
    } else {
      Ok(castMap(arg))
    }
  }
  let makeExn = (arg, valueConstraint) => {
    switch make(arg, valueConstraint) {
    | Ok(val) => val
    | Error(InvalidEntries(_entries)) => raise(InvalidEntriesException)
    }
  }

  let makeUnsafe = (arg, valueConstraint) => {
    valueConstraint->ignore
    castMap(arg)
  }

  // This is just the inverse of castSet
  external value: Belt.Map.t<'key, Value.t<'value, 'valueCntId>, 'cmpId> => Belt.Map.t<
    'key,
    'value,
    'cmpId,
  > = "%identity"
}
