CREATE DATABASE ZEPTO_PROJECT;

USE ZEPTO_PROJECT;

DROP TABLE IF EXISTS ZEPTO;

CREATE TABLE ZEPTO(
SKU_ID SERIAL PRIMARY KEY,
Category VARCHAR(255),
name VARCHAR(255) NOT NULL ,
mrp NUMERIC(8,2) ,
discountPercent numeric (8,2),
availableQuantity int ,
discountedSellingPrice numeric (8,2 ),
weightInGms int,
outOfStock boolean ,
quantity int
);



-- data exploration

-- count rows 
select count(*) as Total_Rows from ZEPTO;

-- sample data view
select * from Zepto 
limit 10 ;

-- null values
select * from ZEPTO 
where name is null
or 
Category is null
or
mrp is null 
or 
discountPercent is null
or
availableQuantity is null
or
discountedSellingPrice is null
or
weightInGms is null
or
outOfStock is null
or
quantity is null;

-- different product by category
select distinct category from ZEPTO 
order by category;

-- product stock in and stock out
select outOfStock , count(sku_id) from ZEPTO 
group by outOfStock;

-- product name present multiple time
select name , count(SKU_ID) as "Number of SKU" from ZEPTO 
group by name
having count(SKU_ID)>1
order by count(SKU_ID) DESC;



-- data cleaning

-- product with price zero
select * from ZEPTO 
where mrp = 0 or discountedSellingPrice = 0;

SET SQL_SAFE_UPDATES =0;

delete from ZEPTO 
where mrp = 0;

-- convert paise to rupee
update ZEPTO
set mrp = mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0;

select mrp , discountedSellingPrice from ZEPTO;




-- Q1. Find the top 10 best-value products based on the discount percentage.
select distinct name , mrp , discountPercent from ZEPTO 
order by discountPercent DESC
limit 10 ;



-- Q2. What are the Products with High MRP but Out of Stock
select distinct name , mrp from ZEPTO 
where outOfStock = 1 and mrp > 300
order by mrp DESC;



-- Q3. Calculate Estimated Revenue for each category
select Category , sum(discountedSellingPrice *availableQuantity) as Revenue From ZEPTO 
group by Category
order by Revenue; 



-- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.
Select distinct name , mrp , discountPercent from ZEPTO 
where mrp > 500 and discountPercent < 10 
order by mrp DESC , discountPercent DESC;



-- Q5. Identify the top 5 categories offering the highest average discount percentage.
Select Category ,round(avg(discountPercent),2) as "Avg Discount" from ZEPTO 
group by Category 
order by "Avg Discount" DESC
limit 5; 



-- Q6. Find the price per gram for products above 100g and sort by best value.
select distinct name , weightInGms ,discountedSellingPrice , round(discountedSellingPrice /weightInGms,2) AS Price_per_Gram from ZEPTO 
where weightInGms > 100 
order by Price_per_Gram ;



-- Q7. Group the products into categories like Low, Medium, Bulk.
select distinct name , weightInGms , 
case when weightInGms < 1000 then 'low'
when weightInGms < 5000 then 'medium'
else 'bulk'
end as weight_category from ZEPTO;




-- Q8. What is the Total Inventory Weight Per Category
select category , sum(weightInGms * availableQuantity) as total_weight from ZEPTO 
group by category
order by total_weight ;












