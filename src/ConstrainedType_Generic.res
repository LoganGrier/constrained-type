module OneType = {
  module type Parameters = {
    type t<'a1>
    let isSatisfied: t<'a1> => bool
  }
  module type Module = {
    type underlying<'a1>
    module Constraint: {
      type identity
      type t<'a1> = ConstrainedType_Constraint.t<underlying<'a1>, identity>
    }
    module Value: {
      type t<'a1> = ConstrainedType_Value.t<underlying<'a1>, Constraint.identity>
      /**
      @param value
      @return Some(value) if isSatisfied(value). None otherwise.
      */
      let make: underlying<'a1> => option<t<'a1>>
      /**
      @param value
      @return value if isSatisfied(value)
      @throws ConstrainedType_Value.ConstraintUnsatisfied if !isSatisfied(value)
      */
      let makeExn: underlying<'a1> => t<'a1>
      /**
      @param value
      @return value
      */
      let makeUnsafe: underlying<'a1> => t<'a1>
    }
  }

  module Make = (P: Parameters) => {
    type underlying<'a1> = P.t<'a1>
    module Constraint = {
      type identity = unit
      type t<'a1> = ConstrainedType_Constraint.t<P.t<'a1>, identity>
    }
    module Value = {
      type t<'a1> = ConstrainedType_Value.t<P.t<'a1>, Constraint.identity>

      let constraint_ = (type a1, _value: P.t<a1>): module(ConstrainedType_Constraint.Type with
        type identity = Constraint.identity
        and type t = P.t<a1>
      ) => {
        module Result = {
          type identity = Constraint.identity
          type t = P.t<a1>
          let isSatisfied = ConstrainedType_Constraint.makeIsSatisfiedInternal(.(. value) =>
            P.isSatisfied(value)
          )
        }
        module(Result)
      }

      let make = (type a1, value: P.t<a1>) =>
        ConstrainedType_Value.make(value, ~constraint_=constraint_(value))
      let makeExn = (type a1, value: P.t<a1>) =>
        ConstrainedType_Value.makeExn(value, ~constraint_=constraint_(value))
      let makeUnsafe = (type a1, value: P.t<a1>) =>
        ConstrainedType_Value.makeUnsafe(value, ~constraint_=constraint_(value))
    }
  }
}
