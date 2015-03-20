-- view 1

--description: temp1 is a view that groups entities of video relation based on the format and take their average file size
CREATE VIEW temp1 (format,avgFileSize) AS SELECT V.format, AVG(V.fileSize) as avgFileSize FROM video V GROUP BY V.format;

--db response:

 --format |     avgfilesize      
--------+----------------------
-- mp4    | 327.5000000000000000
-- avi    | 259.4545454545454545
-- mkv    | 302.6250000000000000
-- (3 rows)


-- query that uses view 1

-- we can then see what type of video format has the largest average file size

SELECT T.format, t.avgFileSize FROM temp1 T WHERE T.avgFileSize = (SELECT MAX(T2.avgFileSize) FROM temp1 T2);

-- db response:

-- format |     avgfilesize      
--------+----------------------
-- mp4    | 327.5000000000000000
--(1 row)



--view 2

-- description: temp2 is a view that joins the circle, post and service relation together (i truncate response using the where condition)

CREATE VIEW temp2 AS SELECT circle.circleID, res.postID, res.postDate, res.creationDate FROM circle inner join (SELECT * FROM post inner join service on service.serviceID=post.serviceID) as RES on circle.circleID=RES.circleID where circle.circleID<=10;


--db response:

-- circleid | postid |      postdate       |    creationdate     
----------+--------+---------------------+---------------------
--        1 |      1 | 2002-07-13 01:01:01 | 2005-08-06 16:19:01
--        2 |      2 | 2005-06-02 02:02:02 | 2010-02-04 09:35:01
--        3 |      3 | 2009-07-04 03:03:03 | 2009-06-25 08:14:01
--        4 |      4 | 2003-02-06 04:04:04 | 2009-06-13 15:25:01
--        5 |      5 | 2008-06-01 05:05:05 | 2008-02-13 03:38:01
--        6 |      6 | 2010-09-11 06:06:06 | 2006-12-01 19:39:01
--        7 |      7 | 2004-11-26 07:07:07 | 2010-02-04 09:35:01
--        8 |      8 | 2001-12-26 08:08:08 | 2008-09-07 18:58:01
--        9 |      9 | 2004-10-18 09:09:09 | 2014-09-14 18:42:01
--       10 |     10 | 2012-09-30 10:10:10 | 2005-10-02 18:17:01
--(10 rows)



-- query that uses view1

-- we can then see the post date, service creation date, and circleID of a particular post with the following query

SELECT postID,postDate, creationDate, circleID from Temp2

-- postid |      postdate       |    creationdate     | circleid 
--------+---------------------+---------------------+----------
--      1 | 2002-07-13 01:01:01 | 2005-08-06 16:19:01 |        1
--      2 | 2005-06-02 02:02:02 | 2010-02-04 09:35:01 |        2
--      3 | 2009-07-04 03:03:03 | 2009-06-25 08:14:01 |        3
--      4 | 2003-02-06 04:04:04 | 2009-06-13 15:25:01 |        4
--      5 | 2008-06-01 05:05:05 | 2008-02-13 03:38:01 |        5
--      6 | 2010-09-11 06:06:06 | 2006-12-01 19:39:01 |        6
--      7 | 2004-11-26 07:07:07 | 2010-02-04 09:35:01 |        7
--      8 | 2001-12-26 08:08:08 | 2008-09-07 18:58:01 |        8
--      9 | 2004-10-18 09:09:09 | 2014-09-14 18:42:01 |        9
--     10 | 2012-09-30 10:10:10 | 2005-10-02 18:17:01 |       10
--(10 rows)
