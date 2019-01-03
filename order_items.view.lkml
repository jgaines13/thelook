


view: order_items {
  sql_table_name: demo_db.order_items ;;

  dimension: id {
    primary_key: yes
    type: string
    sql: ${TABLE}.id ;;
    suggest_dimension: suggestion
  }

  dimension: final {
    type: string
    sql: {{ ${order_id} | prepend: 'hello' }} ;;
  }

  dimension: suggestion {
    type: string
    sql: (select distinct ${id} from ${TABLE} where {% condition sale_price %} ${sale_price} {% endcondition %}) ;;
  }

  dimension: pass_through {
    sql: (select concat(${TABLE}."`hello_",order_items.order_id,"`") as column_name from order_items t  where t.order_id = order_items.order_id group by t.order_id)  ;;
  }
  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    type: string
    # hidden: yes
    sql: ${TABLE}.order_id ;;
  }

  dimension_group: returned {
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
    sql: ${TABLE}.returned_at ;;
  }

  dimension: default_filter{
  type: string
  sql:  concat('SS', substring(extract(year from current_date), 3,4)) ;;
  }
  dimension: truth {
    label: "{% if  _view._name == 'order_items' %} {{'hello'}} {% endif %} "
    type: yesno
    sql: (1=1);;
    html:
    {% assign bool = truth._sql }
     {% if truth._sql %}
    <p> 'heyoooo' </p>
    {% else %}
    <p> 'heyo' </p>
    {% endif %}  ;;
  }

  parameter: comparison_period_type {
    type: string
    default_value: "None"
    suggestions: ["None", "MoM", "YoY", "Last 12 Months"]
  }

  dimension: comparison_dim {
    type: string
    sql: {% parameter comparison_period_type %} ;;
  }

  dimension: comparison_output {
    type: string
    sql: if {% parameter comparison_period_type %}= 'None' then 'this' else 'that';;
#     html: {% if value == "None" %} {{'this'}} {% else %} {{'that'}} {% endif %} ;;
  }

  dimension: sale_price {
    type: string
    sql: ${TABLE}.sale_price ;;
  }

dimension: custom_dimension {
   type: string
   sql: REGEXP_EXTRACT('hello', r"{{ log_search._parameter_value  | slice: 0,-1  }}")  ;;
 }

 parameter: log_search {
   type: string
 }

  measure: count {
    type: count
    drill_fields: [id, inventory_items.id, orders.id]
  }



  filter: filter_to_top_8_days {
    type: yesno
    sql: exists (case when {% condition %} 'Yes' {% endcondition %} then  end  ;;
  }

  measure: total_sale_price {
    type: sum
    sql: ${sale_price} ;;
    html:
    {% if value > 20 %}
    <p style="color:green"> ▴ {{ value }}</p>
    {% else %}
    <p style="color:red">  ▴ {{ value }} </p>
    {% endif %};;
  }
}
