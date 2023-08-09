{% macro margin_percent(turnover, purchase_cost, precision=2) %}
    round(
        safe_divide(({{ turnover }} - {{ purchase_cost }}), {{ turnover }}),
        {{ precision }}
    )
{% endmacro %}
