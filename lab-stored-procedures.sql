use sakila;

-- In the previous lab we wrote a query to find first name, last name, and emails 
-- of all the customers who rented Action movies. Convert the query into a simple stored procedure.
DELIMITER //
create procedure customer_action_movies() 
begin
select first_name, last_name, email
  from customer
  join rental on customer.customer_id = rental.customer_id
  join inventory on rental.inventory_id = inventory.inventory_id
  join film on film.film_id = inventory.film_id
  join film_category on film_category.film_id = film.film_id
  join category on category.category_id = film_category.category_id
  where category.name = "Action"
  group by first_name, last_name, email;
end //
DELIMITER ;

call customer_action_movies();


-- Now keep working on the previous stored procedure to make it more dynamic. Update the stored procedure 
-- in a such manner that it can take a string argument for the category name and return the results for 
-- all customers that rented movie of that category/genre. For eg., it could be action, animation, children, classics, etc.
DELIMITER //
create procedure customer_category_movies(in category_ char(20)) -- out param1 char(100), out param2 char(100), out param3 char(100)) 
begin
select first_name, last_name, email -- into param1
  from customer
  join rental on customer.customer_id = rental.customer_id
  join inventory on rental.inventory_id = inventory.inventory_id
  join film on film.film_id = inventory.film_id
  join film_category on film_category.film_id = film.film_id
  join category on category.category_id = film_category.category_id
  where category.name = category_ 
  group by first_name, last_name, email;
end //
DELIMITER ;

call customer_category_movies('Classics');



-- Write a query to check the number of movies released in each movie category. Convert the query in to a stored procedure 
-- to filter only those categories that have movies released greater than a certain number. Pass that number as an argument 
-- in the stored procedure.
select c.name, count(fc.film_id) as total_movies
from category c
join film_category fc using(category_id) 
group by c.name;

DELIMITER //
create procedure n_movies_category(in n int) -- out param1 int) -- 
begin
select c.name, count(fc.film_id) as total_movies
from category c
join film_category fc using(category_id)
group by c.name
having count(fc.film_id) > n
order by total_movies desc;
end //
DELIMITER ;

call n_movies_category(60);






