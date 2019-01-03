explore: orders {}
view: orders {
  sql_table_name: demo_db.orders ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: dynamic_case{
    type: string
    sql:

    {% assign start_index =  _view._name.size | plus: 1 %}
    {% assign diff =  start_index | plus: 3 %}
    {% assign string_len =  _field._name.size | minus: diff  %}
    CASE
    WHEN ${id} like '1%' THEN ${TABLE}.{{ _field._name | slice: start_index, string_len | append: 'ca_es' }}
    ;;
  }


  dimension: case_2 {
    case: {
      when: {
        label: "{{ id._name }}"
        sql: ${id} ;;
    }
  }}

  dimension:  order_items_copy{
    type: string
    sql: ${order_items.inventory_item_id}  ;;
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
      year,
      day_of_month,
      month_num
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: test_date_end {
    sql: {% date_end created_date %} ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
#     html: <p> {{'now' | date: '%Y' |}} </p>;;
    label:   "{{ 'now' | date: '%y' | prepend: 'SS'}} "
  }

  dimension: truth {
    type: yesno
    sql: 1=1 ;;
  }

  parameter: first_param {
    type: string
    allowed_value: {
      label: "Today"
      value: "today"
    }
    allowed_value: {
      label: "MTD"
      value: "mtd"
    }
    allowed_value: {
      label: "YOY"
      value: "yoy"
    }
  }
  parameter: compare_to {
    type: string
    allowed_value: {
      label: "Today"
      value: "today"
    }
    allowed_value: {
      label: "MTD"
      value: "mtd"
    }
    allowed_value: {
      label: "YOY"
      value: "yoy"
    }
  }
  measure: today {
    type: count
    drill_fields: [id, users.last_name, users.first_name, users.id, order_items.count]
  }
  measure: mtd {
    type: count_distinct
    sql: ${user_id} ;;
  }
  measure: target {
    type: number
    sql: ${today} + 10 ;;
  }
  measure: yoy {
    type: sum
    sql: ${user_id} ;;
  }

  measure: dynamic_measure{
    type: number
    label_from_parameter: first_param
    sql: case when {% parameter first_param %} = 'today' then ${today}
    when {% parameter first_param %} = 'mtd' then ${mtd}
    else ${yoy} end;;
  }
  measure: dynamic_measure_compare_to{
    type: number
    label_from_parameter: compare_to
    sql: case when {% parameter compare_to %} = 'today' then ${today}
          when {% parameter compare_to %} = 'mtd' then ${mtd}
          else ${yoy} end;;
  }

  dimension: string {
    type: string
    sql: 'a  b      c' ;;
    html: <div style="white-space:pre;"> {{value}} </div> ;;
  }

  dimension: test_sub {
    type: number
    sql: 10-${test_character} ;;
  }
#    █
#     {% for i in (1..{{orders.test_sub._value}}) %}
#       <a style="color:gray;background:gray"> | </a>
#     {% endfor %}
  dimension: test_character {
    type: number
    sql: mod(cast(${id} as SIGNED),10) ;;
      html:
      {% for i in (1..{{value}}) %}
      <a style="color:green;background:green"> | </a>
      {% endfor %}
     {% for i in (1..{{orders.test_sub._value}}) %}
    <a style="color:gray;background:gray"> | </a>
    {% endfor %}
    <a> &nbsp; {{value | times: 10 | append:'%'}} </a>

    ;;
    required_fields: [test_sub]
    }
# <a> &nbsp; {{value | times: 10 | append:'%'}} </a>
#     required_fields: [test_sub]
#     html:
#
#     {% for i in (1..{{value}}) %}
#      <a style="color:green;background:green"> | </a>
#     {% endfor %}
#
#     <a> &nbsp; 25% </a>
#     ;;
#   }

    measure: test_sum {
      type: sum
      sql: (select t.metric from ${correlated_sub.SQL_TABLE_NAME} t where t.id = orders.id) ;;
    }

  set: limitfields{
    fields: [status, user_id, id]
  }
}
  explore: correlated_sub  {}
  view: correlated_sub {
    derived_table: {
      sql: select id, count(*) as metric
            from orders
            group by id
            ;;
    }

  }
