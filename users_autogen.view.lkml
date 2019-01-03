view: users_autogen {
sql_table_name: demo_db.order_items ;;

dimension: id {
  sql: ${TABLE}.id ;;
  type: string ## int
  description: ""
}

  
dimension: inventory_item_id {
  sql: ${TABLE}.inventory_item_id ;;
  type: string ## int
  description: ""
}

  
dimension: order_id {
  sql: ${TABLE}.order_id ;;
  type: string ## int
  description: ""
}

  
dimension_group: returned_at {
  timeframes: [raw
  ,year
  ,quarter
  ,month
  ,week
  ,date
  ,day_of_week
  ,month_name]
  type: time
  sql: ${TABLE}.returned_at ;;
  description: ""
}

  
dimension: sale_price {
  sql: ${TABLE}.sale_price ;;
  type: number
  description: ""
}

}
