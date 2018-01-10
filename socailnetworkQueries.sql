use socialnetwork;

#1)	Select information of the female members.


SELECT * FROM socialnetwork.member
where membergender='f';

#2)	Select the information of the male members who don’t have friends yet.

select * 
from socialnetwork.member
where membergender='m' and 
memerid not in (select distinct friends.idmember 
from socialnetwork.friends)

#3)	Select all the friends of member “x” who are less than 35 years old.
#solution1 (faster)
select membername from socialnetwork.member
where TIMESTAMPDIFF(YEAR, memberdob, CURDATE())<35 and member.memerid in(
select distinct friends.idfriend 
from socialnetwork.friends where friends.idmember =(select member.memerid from socialnetwork.member where member.membername="amany")  
union select distinct friends.idfriend 
from socialnetwork.friends 
where friends.idmember =(select member.memerid from socialnetwork.member where member.membername="amany") );

#solution2
select  membername
from friends join member
on idfriend=memerid
where idmember =(select memerid from member where membername="amany")
and idfriend in
(select memerid 
from member 
where TIMESTAMPDIFF(YEAR, memberdob, CURDATE())<35);
   
#4) Select all the friends of member “x” who are married.

#solution1 (faster)
select membername from socialnetwork.member
where maritalstat=(select idmaritalstatus from maritalstatus where maritalstatus="married") and member.memerid in(
select distinct friends.idfriend 
from socialnetwork.friends where friends.idmember =(select member.memerid from socialnetwork.member where member.membername="amany")  
union select distinct friends.idfriend 
from socialnetwork.friends 
where friends.idmember =(select member.memerid from socialnetwork.member where member.membername="amany") );

#solution2
select  membername
from friends join member
on idfriend=memerid
where idmember =(select memerid from member where membername="amany")
and idfriend in
(select memerid 
from member 
where maritalstat=(select idmaritalstatus from maritalstatus where maritalstatus="married"))
 
#5)	Select the names of the recommended friends of member “x” who like sports and are recommended to member "x".

# solution1
 select membername
 from member
 where memerid in(
 Select idfriend
 from recommendedfriends 
 where idmember = (select memerid from member where membername = "amany")
 and idfriend in (select idmember from memberhobby where idhobby =(select idhobbies from hobbies where hobby="sports")))
 
 # solution2
 select membername
 from member
 where memerid in(
 Select idfriend
 from recommendedfriends 
 where idmember = (select memerid from member where membername = "amany")
 and idfriend in (select idmember from memberhobby join hobbies on  idhobby =idhobbies where hobby="sports"))
 
 # solution3
 select membername
 from member
 where memerid in(
 Select idfriend
 from recommendedfriends join member
 on idmember=memerid 
 where membername = "amany"
 and idfriend in (select idmember from memberhobby join hobbies on  idhobby =idhobbies where hobby="sports"))
 
 #solution4
 select * from socialnetwork.member
where hobby=11 and member.memerid in(
select distinct recommendedfriends.idmember
 from socialnetwork.recommendedfriends 
 where recommendedfriends.idfriend =(select member.memerid from socialnetwork.member where member.membername="amany") 
 union select distinct recommendedfriends.idfriend from socialnetwork.recommendedfriends where recommendedfriends.idmember =(select member.memerid from socialnetwork.member where member.membername="amany") );
 
 
#6) Select the names of the members who speak three languages.
select member.membername from socialnetwork.member where member.memerid= (select id 
from (select memberlanguage.idmember as id, count(idlanguage) as cc
from socialnetwork.memberlanguage
group by idmember) as gg
where cc=3);

 
#7)	Select the names of the members who posted more than 4 posts.
select * from socialnetwork.member 
 where member.memerid= (select id from (select memberposts.idmember as id, count(idmember) as pp
from socialnetwork.memberposts
group by idmember) as gg

where pp>=4);
 

 
 
 #8) Select the names of the members who didn’t post posts today.
 
select membername
from member
where memerid not in(
select distinct idmember
from memberposts
where DATE(datetime)= DATE(now())
 );
 
 
 
#9) Select the name of the members who made the most comments on his/her friends pictures.
 
 select membername from member where memerid in(
 select  id  from(
 select  postcomments.idmember as id, count(postcomments.idmember) as pp
 from postcomments
 group by idmember
 order by count(postcomments.idmember) desc limit 1) as gg
 )
 ;
 
#10)	Select the name(s) of the member(s) who posted a picture that got the most comments.

# solution1
 select membername
 from member where memerid in
 (select idmember
 from memberposts
 where postid in
 (
 select idpost
 from postcomments
 group by idpost
 having count(comment) =(
 select count(comment)
 from postcomments
 group by idpost
 order by count(comment) desc limit 1)));
 
 
 
 
#solution2
 select membername
 from member join memberposts 
 on memerid = idmember
 and postid in
 (
 select idpost
 from postcomments
 group by idpost
 having count(comment) =(
 select count(comment)
 from postcomments
 group by idpost
 order by count(comment) desc limit 1));
 
 #11)	Select the names of the friends of memeber “y”.
 
 
 # solution1
 select membername
 from member
 where memerid in(
 select idfriend
 from friends
 where idmember in(
 select idmember 
 from friends join member
 where idmember =memerid
 and membername ="amany")
);
 
 # solution2
 select membername
 from member join friends
 on memerid =idfriend
 where idmember in(
 select idmember 
 from friends join member
 where idmember =memerid
 and membername ="amany");
 
 
 #12)	Select the “teacher” members who have a friend that likes “acting” and speak “Spanish”.

select membername
from member
where occupation=(select idoccupation from occupation where occupation="teacher")
and memerid in
( 
select idfriend
from friends
where idfriend in 
 
(select idmember
from memberlanguage 
where idlanguage =(select idlanguage from language where language="spanich"))
and 
idfriend In (select idmember from memberhobby where idhobby =
(select idhobbies from hobbies where hobby="acting"))
);

#13) Select the count of posts posted by members of each of the occupation categories (ordered descending).

select occupation.occupation, count(postid) as number_of_members 
from  memberposts join  member right join occupation
on member.memerid=memberposts.idmember and 
member.occupation =occupation.idoccupation
group by occupation.occupation
order by count(postid) desc;



#14) Select the count of the members who speak each language (ordered ascending).

select language.language, count(*) as number_of_members 
from memberlanguage join language
on memberlanguage.idlanguage=language.idlanguage
group by language.language
order by count(*);


#15) Select the members that speak more than two languages.

select membername
from member where memerid in
(select idmember
from memberlanguage
group by idmember
having count(*)>2);

#16) Select the members that have the most number of friends.

select membername
from member 
where memerid in
( select idmember
 from friends
 group by idmember
 having count(*) =
(select count(*)
from friends
group by idmember
order by count(*) desc limit 1));

#17) Select the member(s) that has the second most number of friends.

select membername
from member 
where memerid in
( select idmember
 from friends
 group by idmember
 having count(*) =
 (select count(*)
from friends
group by idmember

having count(*) <> 
(select count(*)
from friends
group by idmember
order by count(*) desc limit 1)
order by count(*) desc limit 1)
);



#18) Select the “doctor” members and like “video games”
select membername
from member 
where occupation = (select idoccupation from occupation where occupation="doctor")
and memerid in
(select idmember
from memberhobby
where idhobby=(select idhobbies from hobbies where hobby="video games")
);


#19) Select the members who are married and who speak “Spanish”.

select membername
from member 
where maritalstat = (select idmaritalstatus from maritalstatus where maritalstatus="married")
and memerid in
(select idmember
from memberlanguage
where idlanguage=(select idlanguage from language where language="spanish")
);



#20) Delete the members recommended to “x” after she added them as friends.

Delete from recommendedfriends 
where idmember =(select memerid from member where membername="amany")
and idfriend in
(select idfriend 
from friends
where idmember =(select memerid from member where membername="amany")
);

#21) Select the count of posts posted by members of each gender (ordered descending).
select membergender, count(postid) as number_of_posts 
from member left join memberposts
on memerid=idmember
group by membergender
order by count(postid) desc; 

# 22) select the names of the members along with their calculated ages, ordered descending.


SELECT member.membername,DATE_FORMAT(NOW(), '%Y') - DATE_FORMAT(memberdob, '%Y') - (DATE_FORMAT(NOW(), '00-%m-%d') < DATE_FORMAT(memberdob, '00-%m-%d')) AS age
 from socialnetwork.member
 order by TIMESTAMPDIFF(YEAR, memberdob, CURDATE()) desc;