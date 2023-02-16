# Creating Schema foodie_fi

CREATE SCHEMA foodie_fi;
USE foodie_fi;

# createing table plans
DROP TABLE plans;
CREATE TABLE plans (
    plan_id INTEGER,
    plan_name TEXT,
    price DECIMAL(10,2)
);

# Inserting Values in table plans

INSERT INTO plans
	( plan_id, plan_name, price)
VALUES 
	(0, 'trial', 0), 
	(1, 'basic monthly', 9.90), 
    (2, 'pro monthly', 19.90), 
    (3, 'pro annual', 199), 
    (4, 'churn', null);
    
#Creating table subscriptions
DROP TABLE SUBSCRIPTIONS;
CREATE TABLE subscriptions (
  customer_id INTEGER,
  plan_id INTEGER,
  start_date DATE
);

# Insereting values into subscriptions
INSERT INTO subscriptions
VALUES
    (1, 0, '2020-08-01'),
    (1, 1, '2020-08-08'),
    (2, 0, '2020-09-20'),
    (2, 3, '2020-09-27'),
    (11, 0, '2020-11-19'),
    (11, 4, '2020-11-26'),
    (13, 0, '2020-12-15'),
    (13, 1, '2020-12-22'),
    (13, 2, '2021-03-29'),
    (15, 0, '2020-03-17'),
    (15, 2, '2020-03-24'),
    (15, 4, '2020-04-29'),
    (16, 0, '2020-05-31'),
	(16, 1, '2020-06-07'),
	(16, 3, '2020-10-21'),
    (18, 0, '2020-07-06'),
    (18, 2, '2020-07-13'),
    (19, 0, '2020-06-22'),
    (19, 2, '2020-06-29'),
    (19, 3, '2020-08-29');
   
    