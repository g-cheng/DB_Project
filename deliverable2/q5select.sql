-- 1. Which members has the most friends?

SELECT member.memberid, name, count
	FROM member INNER JOIN (SELECT memberID, COUNT (memberID) 
		FROM contains GROUP BY memberID) c ON (member.memberID = c.memberID) WHERE COUNT=(SELECT MAX(count) 
FROM (SELECT * 
	FROM member INNER JOIN (SELECT memberID, COUNT (memberID) 
		FROM contains GROUP BY memberID) c ON (member.memberID = c.memberID)) max);

--  memberid |   name    | count
-- ----------+-----------+-------
--        28 | 'Laura'   |     3
--        30 | 'Judith'  |     3
--        61 | 'Lisa'    |     3
--        70 | 'Brenda'  |     3
--        72 | 'Julie'   |     3
--        82 | 'Michael' |     3
--        96 | 'Brandon' |     3
-- (7 rows)

-- 2. Which members sent at least one message to Gerald?

SELECT m.senderID, member.name FROM member INNER JOIN (select senderid from message as m where messageid in (select messageid from receive as r where r.memberid = (select memberid from member as m where m.name = '''Gerald'''))) m ON (member.memberID = m.senderID);

--  senderid |   name
-- ----------+-----------
--        55 | 'Paula'
--        67 | 'Robert'
--        53 | 'Jeffrey'
-- (3 rows)

-- 3. Which members is tagged in Michael's pictures?

SELECT member.memberid, member.name, m.pictureid FROM member INNER JOIN (select t.memberid, t.pictureid from taggedin as t where t.pictureid in (select p.pictureid from picture as p where memberid in (select memberid from member as m where m.name='''Michael'''))) m ON (member.memberID = m.memberID);

--  memberid |   name    | pictureid
-- ----------+-----------+-----------
--        39 | 'Ann'     |        19
--        53 | 'Jeffrey' |        19
--        32 | 'Peter'   |        19
--        51 | 'Kathy'   |        19
-- (4 rows)

-- 4. Which members are part of Linkbridge group? 

SELECT member.memberid, name
	FROM member INNER JOIN (select memberid from partOf where partOf.groupid in (select groupid from friendgroup where name='''Linkbridge''')) m ON (member.memberID = m.memberID);

--  memberid |   name
-- ----------+-----------
--        97 | 'Rebecca'
--        71 | 'Nancy'
-- (2 rows)

-- 5. What is the largest group (with the most members)?

select friendgroup.groupid, count from friendGroup INNER JOIN (select groupid, count(*) from partOf group by groupid) c ON (friendGroup.groupID = c.groupID) where count=(select max(count) from (select * from friendGroup INNER JOIN (select groupid, count(*) from partOf group by groupid) c ON (friendGroup.groupID = c.groupID)) as tmp);

--  groupid | count
-- ---------+-------
--       28 |    11
-- (1 row)