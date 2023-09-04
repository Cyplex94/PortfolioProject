-- Harry Potter and his friends are at Ollivander's with Ron, finally replacing Charlie's old broken wand. Hermione decides the best way to choose is by determining the minimum number of gold galleons needed to buy each non-evil wand of high power and age. 
-- Write a query to print the id, age, coins_needed, and power of the wands that Ron's interested in, sorted in order of descending power. If more than one wand has same power, sort the result in order of descending age.


SELECT id, wp.age, w.coins_needed, w.power
FROM wands AS w
JOIN wands_property AS wp
    ON w.code = wp.code
WHERE w.coins_needed = (SELECT MIN(coins_needed)
                         FROM wands AS w2 JOIN wands_property AS wp2
                         ON w2.code = wp2.code
                         WHERE wp2.is_evil = 0 and wp.age = wp2.age and
                         w.power = w2.power)
ORDER BY w.power DESC, wp.AGE DESC
