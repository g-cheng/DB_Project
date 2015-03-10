-- 1. Which members has the most friends?
SELECT * 
	FROM member INNER JOIN (SELECT memberID, COUNT (memberID) 
		FROM contains GROUP BY memberID) c ON (member.memberID = c.memberID) WHERE COUNT=(SELECT MAX(count) 
FROM (SELECT * 
	FROM member INNER JOIN (SELECT memberID, COUNT (memberID) 
		FROM contains GROUP BY memberID) c ON (member.memberID = c.memberID)) max);

-- 2. Which members sent at least one message to Gerald? 3
select * from message as m where messageid in (select messageid from receive as r where r.memberid = (select memberid from member as m where m.name = '''Gerald'''));
-- 3. Which members is tagged in Michael's pictures?
select t.memberid from taggedin as t where t.pictureid in (select p.pictureid from picture as p where memberid in (select memberid from member as m where m.name='''Michael'''));
-- 4. Which members are part of Linkbridge group? 
select memberid from partOf where partOf.groupid in (select groupid from friendgroup where name='''Linkbridge''');
-- 5. What is the largest group (with the most members)?
select friendgroup.groupid, count from friendGroup INNER JOIN (select groupid, count(*) from partOf group by groupid) c ON (friendGroup.groupID = c.groupID) where count=(select max(count) from (select * from friendGroup INNER JOIN (select groupid, count(*) from partOf group by groupid) c ON (friendGroup.groupID = c.groupID)) as tmp);