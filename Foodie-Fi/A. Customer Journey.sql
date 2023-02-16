USE foodie_fi;

SELECT * FROM plans;
SELECT * FROM subscriptions;

/*  A. Customer Journey
Based off the 8 sample customers provided in the sample from the subscriptions table, write a brief description 
about each customer’s onboarding journey.
Try to keep it as short as possible - you may also want to run some sort of join to make your explanations a bit 
easier! */

# Distinct Customer_id in the Data-Set

SELECT 
    COUNT(DISTINCT (customer_id)) AS 'Unique Customers'
FROM
    subscriptions;

# Customer 1

SELECT customer_id, 
    plan_id, 
    plan_name, 
    start_date
FROM subscriptions
JOIN plans USING (plan_id)
WHERE customer_id = 1;
/* > Customer 1 started the trial on 1st August 2020
   > The customer subscribed to the basic monthly plan after the seven day trial period and 
   continued the subscription.
*/

# Customer 2

SELECT customer_id, 
    plan_id, 
    plan_name, 
    start_date
FROM subscriptions
JOIN plans USING (plan_id)
WHERE customer_id = 2;
/* Customer started the trial on 20th september 2020
The customer then subscribed to pro annual subscription after the free trial.
*/

# Customer 11
SELECT customer_id, 
    plan_id, 
    plan_name, 
    start_date
FROM subscriptions
JOIN plans USING (plan_id)
WHERE customer_id = 11;
/* Customer started the trial on 19th November 2020
 The Customer then Cancelled and churned on 26th November 2020 
 */
 
# Customer 13
SELECT customer_id, 
    plan_id, 
    plan_name, 
    start_date
FROM subscriptions
JOIN plans USING (plan_id)
WHERE customer_id = 13;
/* Customer started the trial on 15th December 2020
 The Customer then subscribed to basic monthly subscription after free trial 
 and  then upgraded to the pro monthly plan after 3 months.
 */
 
# Customer 15
SELECT customer_id, 
    plan_id, 
    plan_name, 
    start_date
FROM subscriptions
JOIN plans USING (plan_id)
WHERE customer_id = 15;
/* Customer started the trial on 17th March 2020
 The Customer then subscribed to pro monthly subscriotion after the free trial
 and churned after that month on 29th April 2020 
 */

# Customer 16
SELECT customer_id, 
    plan_id, 
    plan_name, 
    start_date
FROM subscriptions
JOIN plans USING (plan_id)
WHERE customer_id = 16;

# Customer 18
SELECT customer_id, 
    plan_id, 
    plan_name, 
    start_date
FROM subscriptions
JOIN plans USING (plan_id)
WHERE customer_id = 18;

# Customer 19
SELECT customer_id, 
    plan_id, 
    plan_name, 
    start_date
FROM subscriptions
JOIN plans USING (plan_id)
WHERE customer_id = 19;

