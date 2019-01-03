

view: orders_pdt_trigger_value {

  derived_table: {
    sql: select * from demo.orders ;;
    sql_trigger_value:  SELECT HOUR(CURTIME());;
  }

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }
  }
