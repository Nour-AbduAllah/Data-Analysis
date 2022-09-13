-- 'Challenges'
/*Julia asked her students to create some coding challenges.
Write a query to print the hacker_id, name,
and the total number of challenges created by each student.
Sort your results by the total number of challenges in descending order.
If more than one student created the same number of challenges,
then sort the result by hacker_id.
If more than one student created the same number of challenges
and the count is less than the maximum number of challenges created,
then exclude those students from the result.
*/
Declare @Max_Challenges Int;
Select @Max_Challenges = Max(challenges_created) From(
	Select h.hacker_id, h.[name], count(1) [challenges_created] From Hackers h
	Inner Join Challenges c
	On h.hacker_id = c.hacker_id
	Group By h.hacker_id, h.[name]
) Temp;

with total_challenges As(
	Select h.hacker_id, h.[name], count(1) [challenges_created] From Hackers h
	Inner Join Challenges c
	On h.hacker_id = c.hacker_id
	Group By h.hacker_id, h.[name]
)
, challenges_level_count As(
	Select challenges_created, Count(*) [repeatations] from total_challenges group by challenges_created
)
, rank_total As(
	Select tc.hacker_id, tc.[name], tc.challenges_created, clc.repeatations
		From total_challenges tc
		Inner Join challenges_level_count clc
		On tc.challenges_created = clc.challenges_created
)
Select hacker_id, [name], challenges_created From rank_total
	Where challenges_created = @Max_Challenges Or (challenges_created < @Max_Challenges And repeatations = 1)
	Order By challenges_created Desc, hacker_id