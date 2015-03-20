-- 1. Harry posts a picture (inserting the result of a query)
insert into service (serviceid, creationDate) VALUES (101, CURRENT_TIMESTAMP);
insert into picture (serviceID,pictureID,memberID,fileSize,url) VALUES (101, 51, (select memberid from member where name='''Harry'''), 200, 'img1.png');

-- 2. Scott added Jacqueline as a friend
insert into contains (friendListID, memberID) values ((select friendlistid from friendlist where memberid=(select memberid from member where name='''Jacqueline''')), (select memberid from member where name='''Scott'''));
insert into contains (friendListID, memberID) values ((select friendlistid from friendlist where memberid=(select memberid from member where name='''Scott''')), (select memberid from member where name='''Jacqueline'''));

-- 3. Scott tagged Harry in a picture
insert into taggedin (pictureID,memberID) VALUES (51, (select memberid from member where name='''Harry'''));

-- 4. Jacqueline sends a message to Harry
insert into message (messageID,senderID,content,sentAt,receivedAt) VALUES (101, (select memberid from member where name='''Jacqueline'''), 'hello Harry! how are you?', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
insert into instantmessage (messageID,imID,characterLength) VALUES (101, 51, 23);
insert into receive (messageID,memberID,receivedAt) VALUES (101, (select memberid from member where name='''Harry'''), CURRENT_TIMESTAMP);