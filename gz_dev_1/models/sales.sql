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
    sales as (select * from {{ ref('stg_product') }}),
    product as (select * from {{ ref('stg_sales') }})

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
    s.revenue - (s.quantity * cast(p.purchse_price as float64)) as margin,
    -- Margin Percent using macro --
    round(
        safe_divide(
            (s.revenue - s.quantity * cast(p.purchse_price as float64)), s.revenue
        ),
        2
    ) as margin_percent
from sales s
inner join product p on s.pdt_id = p.products_id
