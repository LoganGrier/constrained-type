module Comparable = Belt.Id.MakeComparableU({
  type t = int
  let cmp = (. x: int, y: int) => {
    // At first glance, it may seem that it would be better to return x-y, but this overflows
    // when x and y are sufficiently far apart.
    if x < y {
      -1
    } else if x > y {
      1
    } else {
      0
    }
  }
})

module Impl = ConstrainedType_Inequality.Make({
  type t = int
  module Comparable = Comparable
  let zero = 0
})
