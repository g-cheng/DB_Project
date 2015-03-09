-- 1. Harry posts a picture (inserting the result of a query)
insert into service (serviceid, creationDate) VALUES (101, CURRENT_TIMESTAMP);
insert into picture (serviceID,pictureID,memberID,fileSize,url) VALUES (101, 51, (select memberid from member where name='''Harry'''), 200, 'img1.png');
-- 2. Scott added Jacqueline as a friend
select friendlistid from friendlist where memberid=(select memberid from member where name='''Jacqueline''');
select friendlistid from friendlist where memberid=(select memberid from member where name='''Scott''');


insert into contains (friendListID, memberID) values ((select friendlistid from friendlist where memberid=(select memberid from member where name='''Jacqueline''')), (select memberid from member where name='''Scott'''));

-- 3. Scott tagged Harry in a picture
-- 4. Jacqueline sends a message to Harry