type makeError<'key, 'value, 'cmpId> = InvalidEntries(Belt.Map.t<'key, 'value, 'cmpId>)
exception InvalidEntriesException

/**
@param M
@param ~keyConstraint
@param ~valueConstraint
@return 
  Let G = { (k, v)∈M | keyConstraint(k) && valueConstraint(v) }
  Let B = M - G
  If G == M, Ok(M)
  Otherwise, Error(InvalidEntries(B))
@throws Any exception thrown by keyConstraint or valueConstraint
*/
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
/**
@param M
@param ~keyConstraint
@param ~valueConstraint
@return 
  Let G = { (k, v)∈M | keyConstraint(k) && valueConstraint(v) }
  Let B = M - G
  If G == M, M
@throws InvalidEntriesException if G != M (see @return)
@throws Any exception thrown by keyConstraint or valueConstraint
*/
let makeExn: (
  Belt.Map.t<'key, 'value, 'cmpId>,
  ~keyConstraint: ConstrainedType_Constraint.t<'key, 'keyCntId>,
  ~valueConstraint: ConstrainedType_Constraint.t<'value, 'valueCntId>,
) => Belt.Map.t<
  ConstrainedType_Value.t<'key, 'keyCntId>,
  ConstrainedType_Value.t<'value, 'valueCntId>,
  'cmpId,
>
/**
@param M
@param ~keyConstraint
@param ~valueConstraint
@return M
@property Does not execute keyConstraint or valueConstraint on any element of M
*/
let makeUnsafe: (
  Belt.Map.t<'key, 'value, 'cmpId>,
  ~keyConstraint: ConstrainedType_Constraint.t<'key, 'keyCntId>,
  ~valueConstraint: ConstrainedType_Constraint.t<'value, 'valueCntId>,
) => Belt.Map.t<
  ConstrainedType_Value.t<'key, 'keyCntId>,
  ConstrainedType_Value.t<'value, 'valueCntId>,
  'cmpId,
>
/**
@param constrainedMap
@return The argument, as an unconstrained map
*/
let value: Belt.Map.t<
  ConstrainedType_Value.t<'key, 'keyCntId>,
  ConstrainedType_Value.t<'value, 'valueCntId>,
  'cmpId,
> => Belt.Map.t<'key, 'value, 'cmpId>

module KeyOnly: {
  /**
  @param M
  @param ~keyConstraint
  @return 
    Let G = { (k, v)∈M | keyConstraint(k)}
    Let B = M - G
    If G == M, Ok(M)
    Otherwise, Error(InvalidEntries(B))
  @throws Any exception thrown by keyConstraint
  */
  let make: (
    Belt.Map.t<'key, 'value, 'cmpId>,
    ConstrainedType_Constraint.t<'key, 'keyCntId>,
  ) => result<
    Belt.Map.t<ConstrainedType_Value.t<'key, 'keyCntId>, 'value, 'cmpId>,
    makeError<'key, 'value, 'cmpId>,
  >
  /**
  @param M
  @param ~keyConstraint
  @return 
    Let G = { (k, v)∈M | keyConstraint(k)}
    Let B = M - G
    If G == M, M
  @throws InvalidEntriesException if G != M (see @return)
  @throws Any exception thrown by keyConstraint
  */
  let makeExn: (
    Belt.Map.t<'key, 'value, 'cmpId>,
    ConstrainedType_Constraint.t<'key, 'keyCntId>,
  ) => Belt.Map.t<ConstrainedType_Value.t<'key, 'keyCntId>, 'value, 'cmpId>

  /**
  @param M
  @param ~keyConstraint
  @return M
  @property Does not execute keyConstraint on any element of M
  */
  let makeUnsafe: (
    Belt.Map.t<'key, 'value, 'cmpId>,
    ConstrainedType_Constraint.t<'key, 'keyCntId>,
  ) => Belt.Map.t<ConstrainedType_Value.t<'key, 'keyCntId>, 'value, 'cmpId>
  /**
  @param constrainedMap
  @return The argument, as an unconstrained map
  */
  let value: Belt.Map.t<ConstrainedType_Value.t<'key, 'keyCntId>, 'value, 'cmpId> => Belt.Map.t<
    'key,
    'value,
    'cmpId,
  >
}

module ValueOnly: {
  /**
  @param M
  @param ~valueConstraint
  @return 
    Let G = { (k, v)∈M | valueConstraint(k)}
    Let B = M - G
    If G == M, Ok(M)
    Otherwise, Error(InvalidEntries(B))
  @throws Any exception thrown by valueConstraint
  */
  let make: (
    Belt.Map.t<'key, 'value, 'cmpId>,
    ConstrainedType_Constraint.t<'value, 'valueCntId>,
  ) => result<
    Belt.Map.t<'key, ConstrainedType_Value.t<'value, 'valueCntId>, 'cmpId>,
    makeError<'key, 'value, 'cmpId>,
  >
  /**
  @param M
  @param ~valueConstraint
  @return 
    Let G = { (k, v)∈M | valueConstraint(k)}
    Let B = M - G
    If G == M, M
  @throws InvalidEntriesException if G != M (see @return)
  @throws Any exception thrown by valueConstraint
  */
  let makeExn: (
    Belt.Map.t<'key, 'value, 'cmpId>,
    ConstrainedType_Constraint.t<'value, 'valueCntId>,
  ) => Belt.Map.t<'key, ConstrainedType_Value.t<'value, 'valueCntId>, 'cmpId>

  /**
  @param M
  @param ~valueConstraint
  @return M
  @property Does not execute valueConstraint on any element of M
  */
  let makeUnsafe: (
    Belt.Map.t<'key, 'value, 'cmpId>,
    ConstrainedType_Constraint.t<'value, 'valueCntId>,
  ) => Belt.Map.t<'key, ConstrainedType_Value.t<'value, 'valueCntId>, 'cmpId>

  /**
  @param constrainedMap
  @return The argument, as an unconstrained map
  */
  let value: Belt.Map.t<'key, ConstrainedType_Value.t<'value, 'valueCntId>, 'cmpId> => Belt.Map.t<
    'key,
    'value,
    'cmpId,
  >
}

module NonEmpty: ConstrainedType_Generic.ThreeTypes.Module
  with type underlying<'key, 'value, 'keyCmp> = Belt.Map.t<'key, 'value, 'keyCmp>
