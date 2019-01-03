explore: generate_lookml_from_schema {}
view: generate_lookml_from_schema {
  derived_table: {
    sql: SELECT * FROM hive.INFORMATION_SCHEMA.columns
      WHERE table_schema = '{% parameter table_schema_input %}' and  table_name = '{% parameter table_name_input %}'
       ;;
  }

  parameter: table_schema_input {
    type: unquoted
  }

  parameter: table_name_input {
    type: unquoted
  }

  suggestions: no

  measure: lookml {
    type: string
    sql: CONCAT('view: {% parameter table_name_input %} {
      sql_table_name: {% parameter table_schema_input %}.{% parameter table_name_input %} ',';',';

      ',array_join(array_agg(${combined}),'
      '),'
      }');;
    html: {{value | newline_to_br }}  ;;
  }

  dimension: table_catalog {
    hidden: yes
    type: string
    sql: ${TABLE}.table_catalog ;;
  }

  dimension: table_schema {
    hidden: yes
    type: string
    sql: ${TABLE}.table_schema ;;
  }

  dimension: table_name {
    hidden: yes
    type: string
    sql: ${TABLE}.table_name ;;
  }

  dimension: column_name {
    hidden: yes
    type: string
    sql: ${TABLE}.column_name ;;
  }

  dimension: column_helper {
    hidden: yes
    type: string
    sql: lower(regexp_replace(${column_name}, '[^[:alnum:]]', '_')) ;;
  }

  dimension: data_type {
    hidden: yes
    type: string
    sql: ${TABLE}.data_type ;;
  }

  dimension: name {
    hidden: yes
    type: string
    sql: CONCAT('dimension: ',${column_helper},' {') ;;
  }

  dimension: sql {
    hidden: yes
    type: string
    sql: CONCAT('sql: $','{','TABLE}.',${column_name},' ;',';') ;;
  }

  dimension: type_convert {
    hidden: yes
    type: string
    sql:
      CASE WHEN ${data_type} IN ('integer','bigint','double') THEN 'number'
           WHEN SUBSTR(${data_type},1,7) = 'decimal' THEN 'number'
           WHEN ${data_type} = 'varchar' THEN 'string'
           WHEN ${data_type} = 'boolean' THEN 'yesno'
           ELSE CONCAT('string ## ',${data_type})
          END
    ;;
  }

  dimension: type {
    hidden: yes
    type: string
    sql: CONCAT('type: ',${type_convert})  ;;
  }

  dimension: combined {
    hidden: yes
    type: string
    sql: CONCAT(${name},'
          ',${sql},'
          ',${type},'
          ',${description},'
          ','}','
        ') ;;
    html: {{value | newline_to_br }} ;;
  }

  dimension: ordinal_position {
    hidden: yes
    type: number
    sql: ${TABLE}.ordinal_position ;;
  }

  dimension: column_default {
    hidden: yes
    type: string
    sql: ${TABLE}.column_default ;;
  }

  dimension: is_nullable {
    hidden: yes
    type: string
    sql: ${TABLE}.is_nullable ;;
  }

  dimension: comment {
    hidden: yes
    type: string
    sql: COALESCE(${TABLE}.comment,'') ;;
  }

  dimension: description {
    hidden: yes
    type: string
    sql: CONCAT('description: "',${comment},'"') ;;
  }

  dimension: extra_info {
    hidden: yes
    type: string
    sql: ${TABLE}.extra_info ;;
  }
}
