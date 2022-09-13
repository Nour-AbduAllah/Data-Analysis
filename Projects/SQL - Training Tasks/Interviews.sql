--	'Interviews'
/*
Samantha interviews many candidates from different colleges using coding challenges and contests.
Write a query to print the contest_id, hacker_id, name, and the sums of total_submissions,
total_accepted_submissions, total_views, and total_unique_views for each contest 
sorted by contest_id. Exclude the contest from the result if all four sums are 0.

Note: A specific contest can be used to screen candidates at more than one college, but each college only holds 1 screening contest.
*/

With contest_views As
(
    Select cont.contest_id, cont.hacker_id, cont.[name],
        Sum(vs.total_views) [TV],
        Sum(vs.total_unique_views) [TUV]
    From Contests cont
        Inner Join Colleges col
            On cont.contest_id = col.contest_id
        Inner Join Challenges ch
            On ch.college_id = col.college_id
        Inner Join View_Stats vs
            On vs.challenge_id = ch.challenge_id
    Group By cont.contest_id, cont.hacker_id, cont.[name]
), contest_submissions As
(
    Select cont.contest_id, cont.hacker_id, cont.[name],
        Sum(ss.total_submissions) [TS],
        Sum(ss.total_accepted_submissions) [TAS]
    From Contests cont
        Inner Join Colleges col
            On cont.contest_id = col.contest_id
        Inner Join Challenges ch
            On ch.college_id = col.college_id
        Inner Join Submission_Stats ss
            On ss.challenge_id = ch.challenge_id
    Group By cont.contest_id, cont.hacker_id, cont.[name]
)
Select cv.contest_id, cv.hacker_id, cv.[name], cs.TS, cs.TAS, cv.TV, cv.TUV
    From contest_views cv
        Inner Join contest_submissions cs
            On cv.contest_id = cs.contest_id
            and cv.hacker_id = cs.hacker_id
    Order By contest_id
	/*cont.contest_id, cont.hacker_id, cont.[name], vs.total_unique_views, vs.total_views,
	vs.total_unique_views, ss.total_accepted_submissions, ss.total_submissions*/