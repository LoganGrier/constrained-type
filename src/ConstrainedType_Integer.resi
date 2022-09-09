module Comparable: Belt.Id.Comparable with type t = int
module Impl: ConstrainedType_Inequality.Module with type underlying = int
