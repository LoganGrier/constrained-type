type isSatisfied<'value, 'id> = (. 'value) => bool
let makeIsSatisfiedInternal = (. f) => f
module type Type = {
  type identity
  type t
  let isSatisfied: isSatisfied<t, identity>
}
type t<'value, 'id> = module(Type with type identity = 'id and type t = 'value)

let isSatisfied = (type value id, constraint_: t<value, id>, value) => {
  module Constraint_ = unpack(constraint_)
  Constraint_.isSatisfied(. value)
}

module Make = (
  P: {
    type t
    let isSatisfied: t => bool
  },
) => {
  type identity = unit
  type t = P.t
  let isSatisfied = (. value) => P.isSatisfied(value)
}

module MakeU = (
  P: {
    type t
    let isSatisfied: (. t) => bool
  },
) => {
  type identity = unit
  type t = P.t
  let isSatisfied = P.isSatisfied
}

module All = {
  let isSatisfied = (. _) => true
  type identity = unit
  type t<'element> = t<'element, identity>

  module Make = (
    P: {
      type t
    },
  ) => {
    type identity = unit
    type t = P.t
    let isSatisfied = isSatisfied
  }
}
