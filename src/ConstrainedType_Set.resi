type makeError<'value, 'cmpId> = InvalidEntries(Belt.Set.t<'value, 'cmpId>)
let make: (
  Belt.Set.t<'value, 'cmpId>,
  ~constraint_: ConstrainedType_Constraint.t<'value, 'cntId>,
) => result<Belt.Set.t<ConstrainedType_Value.t<'value, 'cntId>, 'cmpId>, makeError<'value, 'cmpId>>

// Since Rescript doesn't support generic exceptions, we can't include the failing entries InvalidEntriesException
exception InvalidEntriesException
let makeExn: (
  Belt.Set.t<'value, 'cmpId>,
  ~constraint_: ConstrainedType_Constraint.t<'value, 'cntId>,
) => Belt.Set.t<ConstrainedType_Value.t<'value, 'cntId>, 'cmpId>

let makeUnsafe: (
  Belt.Set.t<'value, 'cmpId>,
  ~constraint_: ConstrainedType_Constraint.t<'value, 'cntId>,
) => Belt.Set.t<ConstrainedType_Value.t<'value, 'cntId>, 'cmpId>

let value: Belt.Set.t<ConstrainedType_Value.t<'value, 'cntId>, 'cmpId> => Belt.Set.t<'value, 'cmpId>
