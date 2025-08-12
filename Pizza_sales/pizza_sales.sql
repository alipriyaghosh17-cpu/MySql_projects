
/* 1--  creating new database namining pizza_sales */
Create database pizza_sales;

/* 2--  creating new table by importing CSV file  */

/* 3--  solving Beginner level query  */

-- qstn 1: Retrieve the total number of orders placed.
select count(*) as total_orders
from  orders;

-- qstn 2: Calculate the total revenue generated from pizza sales.
#method 1
Select  round((sum(p.price * od.quantity))) as total_revenue 
 from pizzas p 
join order_details od Using(pizza_id);

#Method 2
with revenue as  (
select p.price as price , od.quantity , ( p.price * od.quantity) AS revenue
from pizzas p 
join order_details od Using(pizza_id)
) 
select  round( sum(revenue) )as total_revenue 
from revenue ;

-- qstn 3: Identify the highest-priced pizza.

Select pt.name as pizza_name, p.price as highest_price
from pizzas p join pizza_types pt using (pizza_type_id)
Order by price desc 
Limit 1;

-- qstn 4: Identify the most common pizza size ordered.

Select p.size as size , count(od.order_id) as order_count
from order_details od join pizzas p using(pizza_id)
group by p.size
 order by  order_count desc
 limit 1 ;

-- qstn 5: List the top 5 most ordered pizza types along with their quantities.

with pz as 
(Select  pt.name AS pizza_type , sum(o.quantity) as quantity_ordered , dense_rank() over( order by sum(o.quantity) desc ) as rnk
         from order_details o join pizzas using( pizza_id)
         join pizza_types pt using(pizza_type_id)
         group by pizza_type
         ) select pizza_type , quantity_ordered
           from pz 
           where rnk<=5 ;
           
#Intermediate:
# qstn 5: Join the necessary tables to find the total quantity of each pizza category ordered.

Select  pt.category as category  , sum(od.quantity) as total_quantity
from order_details od  join pizzas using (pizza_id)
join pizza_types pt using(pizza_type_id)
group by category
order by total_quantity desc;

## qstn 6: Determine the distribution of orders by hour of the day.

Select Hour(time) as hour_of_the_day, count(order_id) as orders
from orders 
group by  hour_of_the_day;

# qstn 7: Join relevant tables to find the category-wise distribution of pizzas.

Select category  , count(name) as distribution
from pizza_types 
group by category 
order by distribution desc;

## qstn 8: Group the orders by date and calculate the average number of pizzas ordered per day.

Select o.date as date ,avg(od.quantity) as Avg_ordered
from order_details od
join orders  o using(order_id)
group by date
order by Avg_ordered desc;

## qstn 9: Determine the top 3 most ordered pizza types based on revenue.

Select temp.pizzaz,
       temp.total_revenue
from (Select p.pizza_type_id as pizzaz , sum(od.quantity* p.price) as total_revenue , dense_rank() over(order by sum(od.quantity* p.price) desc)as rnk 
from order_details od 
join pizzas p using(pizza_id) 
group by pizza_type_id ) as temp
where rnk<=3 ;


#Advanced:
## qstn 10: #Calculate the percentage contribution of each pizza type category to total revenue.
          
     with revenue_per_pizza as
      (  
                -- calculating revenue per pizza
                 Select pt.category AS pizza_type,
                 round(SUM(od.quantity * p.price)) AS revenue
				 from  order_details od 
                 join  pizzas p using(pizza_id)
				JOIN pizza_types pt USING (pizza_type_id)
                GROUP BY pt.category),
        
        -- calculate total revenue 
        total_revenue as ( 
        select sum(revenue) as T_revenue
        from  revenue_per_pizza ) ,
           -- Calculate percentage contribution per pizza type category .
        percentage_calc AS (
 
                    SELECT  pizza_type,  revenue ,
                   round(( revenue/ T_revenue)*100 ,2) as percentage_rev
                    from revenue_per_pizza, total_revenue )
                    
                    select * from percentage_calc
                    order by revenue desc ;
        
        ## qstn 11: Analyze the cumulative revenue generated over time.
        Select o.date  as order_date ,
		round(SUM(od.quantity * p.price)) AS revenue,
		round(Sum(SUM(od.quantity * p.price)) over(order by o.date)) as cumulative_revenue
		FROM orders o
		JOIN order_details od USING (order_id)
		JOIN pizzas p USING (pizza_id)
		group by o.date;


## qstn 12: Determine the top 3 most ordered pizza types based on revenue for each pizza category.

Select  pt.name as name , pt.category as category ,round(SUM(od.quantity * p.price)) AS revenue
from order_details od join pizzas p using(pizza_id)
join pizza_types pt using(pizza_type_id)
group by category , name
order by revenue desc 
limit 3;


           
         
         
         











