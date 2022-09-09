module NonEmpty = {
  type id = unit
  type t<'element> = ConstrainedType_Constraint.t<array<'element>, id>
  module Value = {
    type t<'element> = ConstrainedType_Value.t<array<'element>, id>
    let constraint_ = (
      type element,
      _val: array<element>,
    ): module(ConstrainedType_Constraint.Type with
      type identity = id
      and type t = array<element>
    ) => {
      module Result = {
        type identity = id
        type t = array<element>
        let isSatisfied = ConstrainedType_Constraint.makeIsSatisfiedInternal(.(. array) =>
          array->Belt.Array.size > 0
        )
      }
      module(Result)
    }
    let make = (type element, val: array<element>) =>
      ConstrainedType_Value.make(val, ~constraint_=constraint_(val))
    let makeExn = (type element, val: array<element>) =>
      ConstrainedType_Value.makeExn(val, ~constraint_=constraint_(val))
    let makeUnsafe = (type element, val: array<element>) =>
      ConstrainedType_Value.makeUnsafe(val, ~constraint_=constraint_(val))
  }
}
