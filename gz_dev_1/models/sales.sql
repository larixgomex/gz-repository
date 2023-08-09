{{ config(schema="transaction") }}



with
    sales AS (SELECT * FROM {{ ref('stg_sales') }}) ,
    product as (select * from {{ ref('stg_product') }})

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
