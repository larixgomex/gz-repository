{{ config(schema="transaction") }}

{% macro margin(s, p) %}
    {{ s }}.revenue - ({{ s }}.quantity * cast({{ p }}.purchse_price as float64))
{% endmacro %}

{% macro margin_percent(turnover, purchase_cost, precision=2) %}
    round(
        safe_divide(({{ turnover }} - {{ purchase_cost }}), {{ turnover }}),
        {{ precision }}
    )
{% endmacro %}

with
    sales as (select * from `gz_raw_data.raw_gz_sales`),
    product as (select * from `gz_raw_data.raw_gz_product`)

select
    s.date_date,
    -- Key --
    s.orders_id,
    s.pdt_id as products_id,
    -- Quantity --
    s.quantity as qty,
    -- Revenue --
    s.revenue as turnover,
    -- Cost --
    cast(p.purchse_price as float64) as purchase_price,
    round(s.quantity * cast(p.purchse_price as float64), 2) as purchase_cost,
    -- Margin using macro --
    {{ margin("s", "p") }} as margin,
    -- Margin Percent using macro --
    {{ margin_percent("s.revenue", "s.quantity * CAST(p.purchse_price AS FLOAT64)") }}
    as margin_percent
from sales s
inner join product p on s.pdt_id = p.products_id
