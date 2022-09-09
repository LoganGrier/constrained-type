module Array = ConstrainedType_Array
module Constraint = ConstrainedType_Constraint
module Inequality = ConstrainedType_Inequality
module Integer = {
  module Comparable = ConstrainedType_Integer.Comparable
  include ConstrainedType_Integer.Impl
}
module Map = ConstrainedType_Map
module Set = ConstrainedType_Set
module Value = ConstrainedType_Value
