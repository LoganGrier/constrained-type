type makeError<'key, 'value, 'cmpId> = InvalidEntries(Belt.Map.t<'key, 'value, 'cmpId>)
exception InvalidEntriesException

// Returns error if a constraint is violated on any entry
let make: (
  Belt.Map.t<'key, 'value, 'cmpId>,
  ~keyConstraint: ConstrainedType_Constraint.t<'key, 'keyCntId>,
  ~valueConstraint: ConstrainedType_Constraint.t<'value, 'valueCntId>,
) => result<
  Belt.Map.t<
    ConstrainedType_Value.t<'key, 'keyCntId>,
    ConstrainedType_Value.t<'value, 'valueCntId>,
    'cmpId,
  >,
  makeError<'key, 'value, 'cmpId>,
>
// Throws InvalidEntriesException if a constraint is violated on any entry
let makeExn: (
  Belt.Map.t<'key, 'value, 'cmpId>,
  ~keyConstraint: ConstrainedType_Constraint.t<'key, 'keyCntId>,
  ~valueConstraint: ConstrainedType_Constraint.t<'value, 'valueCntId>,
) => Belt.Map.t<
  ConstrainedType_Value.t<'key, 'keyCntId>,
  ConstrainedType_Value.t<'value, 'valueCntId>,
  'cmpId,
>
let makeUnsafe: (
  Belt.Map.t<'key, 'value, 'cmpId>,
  ~keyConstraint: ConstrainedType_Constraint.t<'key, 'keyCntId>,
  ~valueConstraint: ConstrainedType_Constraint.t<'value, 'valueCntId>,
) => Belt.Map.t<
  ConstrainedType_Value.t<'key, 'keyCntId>,
  ConstrainedType_Value.t<'value, 'valueCntId>,
  'cmpId,
>

let value: Belt.Map.t<
  ConstrainedType_Value.t<'key, 'keyCntId>,
  ConstrainedType_Value.t<'value, 'valueCntId>,
  'cmpId,
> => Belt.Map.t<'key, 'value, 'cmpId>

module KeyOnly: {
  // Returns error if the constraint is violated on any entry
  let make: (
    Belt.Map.t<'key, 'value, 'cmpId>,
    ConstrainedType_Constraint.t<'key, 'keyCntId>,
  ) => result<
    Belt.Map.t<ConstrainedType_Value.t<'key, 'keyCntId>, 'value, 'cmpId>,
    makeError<'key, 'value, 'cmpId>,
  >
  // Throws InvalidEntriesException if the constraint is violated on any entry
  let makeExn: (
    Belt.Map.t<'key, 'value, 'cmpId>,
    ConstrainedType_Constraint.t<'key, 'keyCntId>,
  ) => Belt.Map.t<ConstrainedType_Value.t<'key, 'keyCntId>, 'value, 'cmpId>

  let makeUnsafe: (
    Belt.Map.t<'key, 'value, 'cmpId>,
    ConstrainedType_Constraint.t<'key, 'keyCntId>,
  ) => Belt.Map.t<ConstrainedType_Value.t<'key, 'keyCntId>, 'value, 'cmpId>

  let value: Belt.Map.t<ConstrainedType_Value.t<'key, 'keyCntId>, 'value, 'cmpId> => Belt.Map.t<
    'key,
    'value,
    'cmpId,
  >
}

module ValueOnly: {
  // Returns error if the constraint is violated on any entry
  let make: (
    Belt.Map.t<'key, 'value, 'cmpId>,
    ConstrainedType_Constraint.t<'value, 'valueCntId>,
  ) => result<
    Belt.Map.t<'key, ConstrainedType_Value.t<'value, 'valueCntId>, 'cmpId>,
    makeError<'key, 'value, 'cmpId>,
  >
  // Throws InvalidEntriesException if the constraint is violated on any entry
  let makeExn: (
    Belt.Map.t<'key, 'value, 'cmpId>,
    ConstrainedType_Constraint.t<'value, 'valueCntId>,
  ) => Belt.Map.t<'key, ConstrainedType_Value.t<'value, 'valueCntId>, 'cmpId>

  let makeUnsafe: (
    Belt.Map.t<'key, 'value, 'cmpId>,
    ConstrainedType_Constraint.t<'value, 'valueCntId>,
  ) => Belt.Map.t<'key, ConstrainedType_Value.t<'value, 'valueCntId>, 'cmpId>

  let value: Belt.Map.t<'key, ConstrainedType_Value.t<'value, 'valueCntId>, 'cmpId> => Belt.Map.t<
    'key,
    'value,
    'cmpId,
  >
}
