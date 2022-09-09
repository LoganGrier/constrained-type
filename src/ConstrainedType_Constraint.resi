type isSatisfied<'value, 'id>
let makeIsSatisfiedInternal: (. (. 'value) => bool) => isSatisfied<'value, 'id>
module type Type = {
  type identity
  type t
  let isSatisfied: isSatisfied<t, identity>
}
type t<'value, 'id> = module(Type with type identity = 'id and type t = 'value)

let isSatisfied: (t<'value, 'id>, 'value) => bool

module Make: (
  P: {
    type t
    let isSatisfied: t => bool
  },
) => (Type with type t = P.t)

module MakeU: (
  P: {
    type t
    let isSatisfied: (. t) => bool
  },
) => (Type with type t = P.t)

module All: {
  type identity
  type t<'element> = t<'element, identity>

  module Make: (
    P: {
      type t
    },
  ) => (Type with type t = P.t and type identity = identity)
}
