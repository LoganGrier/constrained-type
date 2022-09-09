module NonEmpty: {
  type id
  type t<'element> = ConstrainedType_Constraint.t<array<'element>, id>
  module Value: {
    type t<'element> = ConstrainedType_Value.t<array<'element>, id>
    let make: array<'element> => option<t<'element>>
    let makeExn: array<'element> => t<'element>
    let makeUnsafe: array<'element> => t<'element>
  }
}
