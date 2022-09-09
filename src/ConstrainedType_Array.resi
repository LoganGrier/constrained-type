module NonEmpty: {
  type id
  /**
  A constraint which is satisfied if and only if it has at least one element
  */
  type t<'element> = ConstrainedType_Constraint.t<array<'element>, id>
  module Value: {
    type t<'element> = ConstrainedType_Value.t<array<'element>, id>
    /**
    @param value
    @return Some(value) if value is non-empty, None otherwise
    */
    let make: array<'element> => option<t<'element>>
    /**
    @param value
    @return value if value is non-empty
    @throws ConstrainedType_Value.ConstraintUnsatisfied if value is empty
    */
    let makeExn: array<'element> => t<'element>
    /**
    @param value
    @return value
    */
    let makeUnsafe: array<'element> => t<'element>
  }
}
