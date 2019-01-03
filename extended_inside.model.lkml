connection: "connection_name"

include: "*.view.lkml"         # include all views in this project
include: "*.dashboard.lookml"  # include all dashboards in this project
include: "let_s_break.model.lkml"

explore: order_items {
  view_name: order_items
  extends: [order_items_base]
#   join: column_names{
#     sql: (select concat('order_items.hello',t.order_id) as column_name, t.order_id from order_items t) as get_column_name on get_column_name .order_id = order_items.order_id
#  ;;
#   }
}

explore: extended_too {
  extends: [order_items_tbe]
  join: products_extended {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products_extended.id} ;;
    relationship: many_to_one
  }
}
