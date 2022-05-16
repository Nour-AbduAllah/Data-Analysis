
--	- 'Top Competitors' -

/*
Julia just finished conducting a coding contest,
and she needs your help assembling the leaderboard!
Write a query to print the respective hacker_id and name
of hackers who achieved full scores for more than one challenge.
Order your output in descending order by the total number
of challenges in which the hacker earned a full score.
If more than one hacker received full scores in same number
of challenges, then sort them by ascending hacker_id.
*/
With FullScores As
(
	Select S.hacker_id, H.[name],
	Count(S.score) [Score_count]
		From Submissions S
		Inner Join Hackers H
		On S.hacker_id = H.hacker_id
		Inner Join Challenges C
			Inner Join Difficulty D
			On D.difficulty_level = C.difficulty_level
			On C.challenge_id = S.challenge_id
		Where S.score = D.score
		Group By S.hacker_id, H.[name]
)
Select hacker_id, [name]
	From FullScores
	Where Score_count > 1
	Order By Score_count Desc, hacker_id