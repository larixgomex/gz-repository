select 
 products_id
,CAST(purchSE_PRICE as float64) as purchase_price
 from `gz_raw_data.raw_gz_product`