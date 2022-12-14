module type Parameters = {
  type t
  module Comparable: Belt.Id.Comparable with type t = t
  let zero: t
}

module type Module = {
  type underlying
  module Positive: ConstrainedType_Constraint.Type with type t = underlying
  module NonPositive: ConstrainedType_Constraint.Type with type t = underlying
  module Negative: ConstrainedType_Constraint.Type with type t = underlying
  module NonNegative: ConstrainedType_Constraint.Type with type t = underlying
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

/**
@return An inequality module that defines positive, nonPositive, negative, and nonNegative
based on the Comparable and zero in parameters. In particular:
A value is positive if and only if Comparable.cmp(value, zero) > 0
A value is nonPositive if and only if  Comparable.cmp(value, zero) <= 0
A value is negative if and only if  Comparable.cmp(value, zero) < 0
A value is nonNegative if and only if  Comparable.cmp(value, zero) >= 0
*/
module Make: (Parameters: Parameters) => (Module with type underlying = Parameters.t)
