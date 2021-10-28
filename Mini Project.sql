use ipl;
select * from ipl_bidder_details;
select * from ipl_bidder_points;
select * from ipl_bidding_details;
select * from ipl_match;
select * from ipl_match_schedule;
select * from ipl_player;
select * from ipl_stadium;
select * from ipl_team;
select * from ipl_team_players;
select * from ipl_team_standings;
select * from ipl_tournament;
select * from ipl_user;

#1.	Show the percentage of wins of each bidder in the order of highest to lowest percentage.
select bd.bidder_id ,count(ibd.bid_status) , (sum(if(ibd.bid_status='Won',1,0))/count(ibd.bid_status))*100 as 'Percentage of Wins'
from ipl_bidder_details bd left join ipl_bidding_details ibd using(bidder_id)
group by bd.bidder_id
order by (sum(if(ibd.bid_status='Won',1,0))/count(ibd.bid_status))*100 desc;

#2.	Display the number of matches conducted at each stadium with stadium name, city from the database.
select ist.stadium_name, ist.city, count(stadium_id) as 'Number of matches conducted'
from ipl_match_schedule ims join ipl_stadium ist using(stadium_id)
group by stadium_id;

#3.	In a given stadium, what is the percentage of wins by a team which has won the toss?
select ips.stadium_name, (sum(if(im.toss_winner=im.match_winner,1,0))/count(*))*100 as 'Win % after winning Toss'
from ipl_match im join ipl_match_schedule ims using(match_id)
join ipl_stadium ips using(stadium_id)
group by ips.stadium_name
order by (sum(if(im.toss_winner=im.match_winner,1,0))/count(*))*100 desc;

#4.	Show the total bids along with bid team and team name.
select ibd.bid_team, it.team_name, count(*) as 'Total Bids'
from IPL_Bidding_Details ibd join IPL_Team it on it.team_id=ibd.bid_team
group by team_name;

#5.	Show the team id who won the match as per the win details.
select it.team_id, it.team_name, it.remarks, im.win_details
from ipl_match im cross join ipl_team it
where it.remarks like concat('%',substr(im.win_details, 6, 3),'%') and instr(im.win_details, 'won') <> 0
group by it.team_id;

#6.	Display total matches played, total matches won and total matches lost by team along with its team name.
select sum(its.matches_played) as "Total Matches Played" ,
sum(its.matches_won) as "Matches Won", sum(its.matches_lost) as "Matches Lost" , it.team_name as "Team Name"
from ipl_team_standings its join ipl_team it using(team_id) 
group by its.team_id;

#7.	Display the bowlers for Mumbai Indians team.
select ip.Player_id, Player_name, Player_role, Team_name
from ipl_team_players itp join ipl_team it using(team_id)
join ipl_player ip on itp.player_id=ip.player_id
where itp.player_role='Bowler' and it.team_name='Mumbai Indians';

#8.	How many all-rounders are there in each team, Display the teams with more than 4 all-rounder in descending order.
select Team_Id, Team_Name, count(*) as 'No. of all rounders'
from ipl_team_players itp join ipl_team it using(team_id)
where player_role = 'All-Rounder'
group by team_id
having count(*)>4
order by count(*) desc;
