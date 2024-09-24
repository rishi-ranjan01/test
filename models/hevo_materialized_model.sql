{{ config (
    materialized="table"
)}}

with
    customers as (
        select id as customer_id, first_name, last_name
        from pc_hevodata_db.public.raw_customers
    ),
    orders as (
        select id as order_id, user_id as customer_id, order_date, status
        from pc_hevodata_db.public.raw_orders
    ),
    payments as (select order_id, amount from pc_hevodata_db.public.raw_payments),
    customer as (
        select
            c.customer_id,
            c.first_name,
            c.last_name,
            min(o.order_date) as first_order,
            max(o.order_date) as most_recent_order,
            count(o.order_id) as number_of_orders,
            coalesce(sum(p.amount), 0) as customer_lifetime_value
        from customers c
        left join orders o using (customer_id)
        left join payments p using (order_id)
        group by c.customer_id, c.first_name, c.last_name
        order by c.customer_id
    )

select *
from customer
