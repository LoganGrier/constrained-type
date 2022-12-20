type makeError<'value, 'cmpId> = InvalidEntries(Belt.Set.t<'value, 'cmpId>)

/**
@param S
@param ~constraint_
@return 
Let G = { e∈S | constraint_(e) }
Let B = S - G

If G == S, Ok(S)
Otherwise, Error(InvalidEntries(B))
@throws Any exception thrown by constraint_
*/
let make: (
  Belt.Set.t<'value, 'cmpId>,
  ~constraint_: ConstrainedType_Constraint.t<'value, 'cntId>,
) => result<Belt.Set.t<ConstrainedType_Value.t<'value, 'cntId>, 'cmpId>, makeError<'value, 'cmpId>>

// Since Rescript doesn't support generic exceptions, we can't include the failing entries InvalidEntriesException
exception InvalidEntriesException
/**
@param S
@param ~constraint_
@return 
Let G = { e∈S | constraint_(e) }
Let B = S - G

If G == S, S
@throws InvalidEntriesException if G != S (see @return)
@throws Throws any exception thrown by constraint_
*/
let makeExn: (
  Belt.Set.t<'value, 'cmpId>,
  ~constraint_: ConstrainedType_Constraint.t<'value, 'cntId>,
) => Belt.Set.t<ConstrainedType_Value.t<'value, 'cntId>, 'cmpId>

/**
@param S
@param ~constraint_
@return S
@property Does not execute constraint_ on S
*/
let makeUnsafe: (
  Belt.Set.t<'value, 'cmpId>,
  ~constraint_: ConstrainedType_Constraint.t<'value, 'cntId>,
) => Belt.Set.t<ConstrainedType_Value.t<'value, 'cntId>, 'cmpId>

/**
@param constrainedSet
@return The argument, as an unconstrained set
*/
let value: Belt.Set.t<ConstrainedType_Value.t<'value, 'cntId>, 'cmpId> => Belt.Set.t<'value, 'cmpId>

module NonEmpty: ConstrainedType_Generic.TwoTypes.Module
  with type underlying<'element, 'elementCmp> = Belt.Set.t<'element, 'elementCmp>
