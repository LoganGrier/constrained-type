module NonEmpty = ConstrainedType_Generic.OneType.Make({
  type t<'element> = array<'element>
  let isSatisfied = array => array->Belt.Array.size > 0
})
