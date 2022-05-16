
--	'Ollivander's Inventory' 

/*
Harry Potter and his friends are at Ollivander's with Ron,
finally replacing Charlie's old broken wand.

Hermione decides the best way to choose is by determining the minimum
number of gold galleons needed to buy each non-evil wand of high power and age.

Write a query to print the id, age, coins_needed,
and power of the wands that Ron's interested in,
sorted in order of descending power. If more than one wand has same power,
sort the result in order of descending age.
*/

With Min_coins As
(
    Select [id], age, coins_needed, [power], W.code,
        ROW_NUMBER() Over
        (
            Partition By [power], age Order By [power] Desc, age Desc, coins_needed
        ) [Row_num]
        From Wands W
        Inner Join Wands_Property Wp
        On W.code = Wp.code
        Where is_evil = 0
)
Select id, age, coins_needed, [power] From Min_coins
Where Row_num = 1
Order by [power] Desc, age Desc