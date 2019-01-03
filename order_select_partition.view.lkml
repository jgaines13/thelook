explore: order_select_partition {}
view: order_select_partition {
sql_table_name: ${ _user_attributes['name'].SQL_TABLE_NAME} ;;
#   sql_table_name: (select id, concat(
#   {% assign fields = field_name._parameter_value | replace: "'", "" | split: ","  %}
#   {% assign partition_list = '' %}
#   {% for field in fields %}
#             {% if forloop.last == true %}
#             {{ partition_list | append: field   }}
#             {% else %}
#             {{ partition_list | append: field | append: ','  }}
#             {% endif %}
#         {% endfor %}
#
#   ) as partition_key from orders);;


  dimension: id {
    sql: ${TABLE}.id ;;
  }
  dimension: url_link {
#     sql: 1 ;;
#     sql:{% assign url_split_at_f = filter_link._link | split: '&amp;f' %}
#       {% assign user_filters = '' %}
#       {% assign continue_loop = true %}
#
#       {% for url_part in url_split_at_f offset:1 %}
#         {% if continue_loop %}
#           {% if url_part contains '&amp;sorts' %}
#             {% assign part_split_at_sorts = url_part | split: '&amp;sorts' %}
#             {% assign last_filter = part_split_at_sorts | first %}
#             {% assign user_filters = user_filters | append:'&f' %}
#             {% assign user_filters = user_filters | append:last_filter %}
#             {% assign continue_loop = false %}
#           {% else %}
#             {% assign user_filters = user_filters | append:'&amp;f' %}
#             {% assign user_filters = user_filters | append:url_part %}
#           {% endif %}
#         {% endif %}
#       {% endfor %}
#       {{ user_filters }};;
  }

  measure: filter_link {
    type: count
  }
  measure: _link {
    type: string
#     hidden: yes
    drill_fields: []
    sql:{{ filter_link._link }};;
  }



  parameter: field_name {
    type: yesno
     default_value: "Yes"
  }

  measure: test_parameter {
    type: yesno
    sql: {% parameter field_name %};;
  }

  dimension: dynamic_field_name{
    sql: {% if order_select_partition.field_name._in_query %}

    ;;
  }
  }
