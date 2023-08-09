{{ config(schema="transaction") }}

with

    sales as (select * from `gz_raw_data.raw_gz_sales`),
    product as (select * from `gz_raw_data.raw_gz_product`)

select
    s.date_date,
    # ## Key ###
    s.orders_id,
    s.pdt_id as products_id,
    # ##########
    -- qty --
    s.quantity as qty,
    -- revenue --
    s.revenue as turnover,
    -- cost --
    cast(p.purchse_price as float64) as purchase_price,
    round(s.quantity * cast(p.purchse_price as float64), 2) as purchase_cost,
    -- margin --
    s.revenue - s.quantity * cast(p.purchse_price as float64) as margin,
    {{ margin_percent("s.revenue", "s.quantity*CAST(p.purchSE_PRICE AS FLOAT64)") }}
    as margin_percent
from sales s
inner join product p on s.pdt_id = p.products_id
