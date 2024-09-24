with payments as (
select *
from pc_hevodata_db.public.raw_payments
)

select order_id, sum(amount) as total_amount
from payments group by 1
having total_amount < 0