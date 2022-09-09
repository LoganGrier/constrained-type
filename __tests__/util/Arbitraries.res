open FastCheck.Arbitrary
open ConstrainedType
let positiveInt = () => integerRange(1, 2147483647)
let negativeInt = () => integerRange(-2147483648, -1)
let map = (arbKey, arbValue) =>
  Combinators.array(Combinators.tuple2(arbKey, arbValue))->Derive.map(
    Belt.Map.fromArray(~id=module(Integer.Comparable)),
  )
let set = arbElement =>
  Combinators.array(arbElement)->Derive.map(Belt.Set.fromArray(~id=module(Integer.Comparable)))
