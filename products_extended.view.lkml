

include: "products.view"
view: products_extended {
  extends: [products]

dimension: retail_price {
  description: "this is a description"
  sql: ${EXTENDED}/5 ;;

}
measure: count {
  filters: {
    field: brand
    value: "Allegra K"
  }
}

}
