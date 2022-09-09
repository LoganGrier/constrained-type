module Value = ConstrainedType_Value
module Constraint = ConstrainedType_Constraint

module type Parameters = {
  type t
  module Comparable: Belt.Id.Comparable with type t = t
  let zero: t
}

module type Module = {
  type underlying
  module Positive: Constraint.Type with type t = underlying
  module NonPositive: Constraint.Type with type t = underlying
  module Negative: Constraint.Type with type t = underlying
  module NonNegative: Constraint.Type with type t = underlying
  module Value: {
    type positive = ConstrainedType_Value.t<underlying, Positive.identity>
    let positive: underlying => option<positive>
    let positiveExn: underlying => positive
    let positiveUnsafe: underlying => positive

    type nonPositive = ConstrainedType_Value.t<underlying, NonPositive.identity>
    let nonPositive: underlying => option<nonPositive>
    let nonPositiveExn: underlying => nonPositive
    let nonPositiveUnsafe: underlying => nonPositive

    type negative = ConstrainedType_Value.t<underlying, Negative.identity>
    let negative: underlying => option<negative>
    let negativeExn: underlying => negative
    let negativeUnsafe: underlying => negative

    type nonNegative = ConstrainedType_Value.t<underlying, NonNegative.identity>
    let nonNegative: underlying => option<nonNegative>
    let nonNegativeExn: underlying => nonNegative
    let nonNegativeUnsafe: underlying => nonNegative
  }
}

module Make = (Parameters: Parameters) => {
  type underlying = Parameters.t
  module NonNegative = Constraint.Make({
    type t = underlying
    let isSatisfied = (i: t) =>
      Belt.Id.getCmpInternal(Parameters.Comparable.cmp)(. i, Parameters.zero) >= 0
  })
  module Positive = Constraint.Make({
    type t = underlying
    let isSatisfied = (i: t) =>
      Belt.Id.getCmpInternal(Parameters.Comparable.cmp)(. i, Parameters.zero) > 0
  })
  module NonPositive = Constraint.Make({
    type t = underlying
    let isSatisfied = (i: t) =>
      Belt.Id.getCmpInternal(Parameters.Comparable.cmp)(. i, Parameters.zero) <= 0
  })
  module Negative = Constraint.Make({
    type t = underlying
    let isSatisfied = (i: t) =>
      Belt.Id.getCmpInternal(Parameters.Comparable.cmp)(. i, Parameters.zero) < 0
  })
  module Value = {
    type positive = ConstrainedType_Value.t<underlying, Positive.identity>
    let positive = val => Value.make(val, ~constraint_=module(Positive))
    let positiveExn = val => Value.makeExn(val, ~constraint_=module(Positive))
    let positiveUnsafe = val => Value.makeUnsafe(val, ~constraint_=module(Positive))

    type nonPositive = ConstrainedType_Value.t<underlying, NonPositive.identity>
    let nonPositive = val => Value.make(val, ~constraint_=module(NonPositive))
    let nonPositiveExn = val => Value.makeExn(val, ~constraint_=module(NonPositive))
    let nonPositiveUnsafe = val => Value.makeUnsafe(val, ~constraint_=module(NonPositive))

    type negative = ConstrainedType_Value.t<underlying, Negative.identity>
    let negative = val => Value.make(val, ~constraint_=module(Negative))
    let negativeExn = val => Value.makeExn(val, ~constraint_=module(Negative))
    let negativeUnsafe = val => Value.makeUnsafe(val, ~constraint_=module(Negative))

    type nonNegative = ConstrainedType_Value.t<underlying, NonNegative.identity>
    let nonNegative = val => Value.make(val, ~constraint_=module(NonNegative))
    let nonNegativeExn = val => Value.makeExn(val, ~constraint_=module(NonNegative))
    let nonNegativeUnsafe = val => Value.makeUnsafe(val, ~constraint_=module(NonNegative))
  }
}
