module OneType: {
  module type Parameters = {
    type t<'a1>
    let isSatisfied: t<'a1> => bool
  }
  module type Module = {
    type underlying<'a1>
    module Constraint: {
      type identity
      type t<'a1> = ConstrainedType_Constraint.t<underlying<'a1>, identity>
      module Make: (
        P: {
          type a1
        },
      ) =>
      (ConstrainedType_Constraint.Type with type t = underlying<P.a1> and type identity = identity)
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
  module Make: (P: Parameters) => (Module with type underlying<'a1> = P.t<'a1>)
}

module TwoTypes: {
  module type Parameters = {
    type t<'a1, 'a2>
    let isSatisfied: t<'a1, 'a2> => bool
  }
  module type Module = {
    type underlying<'a1, 'a2>
    module Constraint: {
      type identity
      type t<'a1, 'a2> = ConstrainedType_Constraint.t<underlying<'a1, 'a2>, identity>
      module Make: (
        P: {
          type a1
          type a2
        },
      ) =>
      (
        ConstrainedType_Constraint.Type
          with type t = underlying<P.a1, P.a2>
          and type identity = identity
      )
    }
    module Value: {
      type t<'a1, 'a2> = ConstrainedType_Value.t<underlying<'a1, 'a2>, Constraint.identity>
      /**
      @param value
      @return Some(value) if isSatisfied(value). None otherwise.
      */
      let make: underlying<'a1, 'a2> => option<t<'a1, 'a2>>
      /**
      @param value
      @return value if isSatisfied(value)
      @throws ConstrainedType_Value.ConstraintUnsatisfied if !isSatisfied(value)
      */
      let makeExn: underlying<'a1, 'a2> => t<'a1, 'a2>
      /**
      @param value
      @return value
      */
      let makeUnsafe: underlying<'a1, 'a2> => t<'a1, 'a2>
    }
  }
  module Make: (P: Parameters) => (Module with type underlying<'a1, 'a2> = P.t<'a1, 'a2>)
}

module ThreeTypes: {
  module type Parameters = {
    type t<'a1, 'a2, 'a3>
    let isSatisfied: t<'a1, 'a2, 'a3> => bool
  }
  module type Module = {
    type underlying<'a1, 'a2, 'a3>
    module Constraint: {
      type identity
      type t<'a1, 'a2, 'a3> = ConstrainedType_Constraint.t<underlying<'a1, 'a2, 'a3>, identity>
      module Make: (
        P: {
          type a1
          type a2
          type a3
        },
      ) =>
      (
        ConstrainedType_Constraint.Type
          with type t = underlying<P.a1, P.a2, P.a3>
          and type identity = identity
      )
    }
    module Value: {
      type t<'a1, 'a2, 'a3> = ConstrainedType_Value.t<
        underlying<'a1, 'a2, 'a3>,
        Constraint.identity,
      >
      /**
      @param value
      @return Some(value) if isSatisfied(value). None otherwise.
      */
      let make: underlying<'a1, 'a2, 'a3> => option<t<'a1, 'a2, 'a3>>
      /**
      @param value
      @return value if isSatisfied(value)
      @throws ConstrainedType_Value.ConstraintUnsatisfied if !isSatisfied(value)
      */
      let makeExn: underlying<'a1, 'a2, 'a3> => t<'a1, 'a2, 'a3>
      /**
      @param value
      @return value
      */
      let makeUnsafe: underlying<'a1, 'a2, 'a3> => t<'a1, 'a2, 'a3>
    }
  }
  module Make: (P: Parameters) => (Module with type underlying<'a1, 'a2, 'a3> = P.t<'a1, 'a2, 'a3>)
}
