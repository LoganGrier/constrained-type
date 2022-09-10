open Jest
open Expect
open FastCheck
open Arbitrary
open Property.SyncUnit
open ConstrainedType

let isEven = (. value) => mod(value, 2) == 0
module EvenInteger = Constraint.MakeU({
  type t = int
  let isSatisfied = isEven
})
let isOdd = value => mod(value, 2) == 1
module OddInteger = Constraint.Make({
  type t = int
  let isSatisfied = isOdd
})
module AllInteger = Constraint.All.Make({
  type t = int
})

module Tests = (
  Parameters: {
    module Constraint: Constraint.Type with type t = int
    let isSatisfied: int => bool
    let name: string
  },
) => {
  describe(Parameters.name, () => {
    describe("isSatisfied", () => {
      test(
        "isSatisfied function matches isSatisfied parameter",
        () => {
          assert_(
            property1(
              integer(),
              int => {
                let actual = module(Parameters.Constraint)->Constraint.isSatisfied(int)
                let expected = Parameters.isSatisfied(int)
                expect(actual)->toBe(expected)->affirm
              },
            ),
          )
          pass
        },
      )
    })
  })
}

// We test both OddInteger and EvenInteger so that we cover
module OddTests = Tests({
  module Constraint = OddInteger
  let isSatisfied = isOdd
  let name = "OddInteger"
})
module EvenTests = Tests({
  module Constraint = EvenInteger
  let isSatisfied = val => isEven(. val)
  let name = "EvenInteger"
})
module AllTests = Tests({
  module Constraint = AllInteger
  let isSatisfied = _ => true
  let name = "AllInteger"
})
