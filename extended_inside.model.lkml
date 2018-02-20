connection: "connection_name"

include: "*.view.lkml"         # include all views in this project
include: "*.dashboard.lookml"  # include all dashboards in this project
include: "let_s_break.model.lkml"

explore: extend_inside {
  extends: [order_items]
  from: order_items
  view_name: order_items
}
