{{ config(schema="transaction") }}


with
    sales as (select * from {{ ref('stg_sales') }}),
    product as (select * from {{ ref('stg_product') }})

select
    s.date_date,
    -- Key --
    s.orders_id,
    s.products_id,
    -- Quantity --
    s.quantity as qty,
    -- Revenue --
    s.revenue as turnover,
    -- Cost --
    cast(p.purchse_price as float64) as purchase_price,
    round(s.quantity * cast(p.purchse_price as float64), 2) as purchase_cost,
    -- Margin with  macro --
    s.revenue - (s.quantity * cast(p.purchse_price as float64)) as margin,
    -- Margin Percent with macro --
    round(
        safe_divide(
            (s.revenue - s.quantity * cast(p.purchse_price as float64)), s.revenue
        ),
        2
    ) as margin_percent
from sales s
inner join product p on s.products_id = p.products_id
