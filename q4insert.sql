-- Sample inserts

INSERT INTO message (messageID, senderID, content)
	VALUES (1, 1, 'Hey, how are you doing?');
INSERT INTO message (messageID, senderID, content)
	VALUES (2, 1, 'What`s up?');
INSERT INTO message (messageID, senderID, content)
	VALUES (3, 1, 'This is an e-mail...');

INSERT INTO instantMessage (imID, messageID, characterLength)
	VALUES (1, 2, 50);

INSERT INTO email (emailID, messageID, priority)
	VALUES (1, 3, 5);

INSERT INTO interest (interestID, name, detail)
	VALUES (1, 'Hacking', 'Make the world a better place with code');

INSERT INTO circle (circleID)
	VALUES (1);

INSERT INTO friendGroup (groupID, circleID, name)
	VALUES (1, 1, 'Hackathon hackers');

INSERT INTO friendList (friendListID, circleID, memberID)
	VALUES (1, 1, 1);

INSERT INTO service (serviceID)
	VALUES (1);

INSERT INTO idea (ideaID, memberID, serviceID, content)
	VALUES (1, 1, 1, 'A new matrix augmented reality');

INSERT INTO picture (pictureID, serviceID, memberID, fileSize, url)
	VALUES (1, 1, 1, 120, 'http://instagram.com/neo/matrix');

INSERT INTO event (eventID, serviceID, memberID, name, detail)
	VALUES (1, 1, 1, 'Unreal Hackathon', 'Build the next augmented reality hacks');

INSERT INTO video (videoID, serviceID, memberID, format)
	VALUES (1, 1, 1, 'MOV');

INSERT INTO post (postID, circleID, memberID, serviceID)
	VALUES (1, 1, 1, 1);

INSERT INTO share (interestID, memberID)
	VALUES (1, 1);

INSERT INTO livestream (circleID, memberID)
	VALUES (1, 1);

INSERT INTO partOf (groupID, memberID)
	VALUES (1, 1);

INSERT INTO contains (friendListID, memberID)
	VALUES (1, 1);

INSERT INTO taggedIn (memberID, pictureID)
	VALUES (1, 1);

INSERT INTO attends (memberID, eventID) 
	VALUES (1, 1);

-- project=# select * from member limit 5;
--  memberid |   name   |           email           |   password    
-- ----------+----------+---------------------------+---------------
--         1 | 'Jerry'  | 'jbutler0@squidoo.com'    | 'R3yUz1Q'
--         2 | 'Joyce'  | 'jallen1@elpais.com'      | 'wGYf1ez'
--         3 | 'Brenda' | 'bgutierrez2@answers.com' | 'MxoASzcFe'
--         4 | 'Jean'   | 'jlane3@va.gov'           | 'jaxTQbXX'
--         5 | 'Irene'  | 'iwillis4@cloudflare.com' | 'Fn1LYbqDhFx'
-- (5 rows)

-- project=# select * from message limit 5;
--  messageid | senderid |                                                                          content                                                                           |       sentat        |     receivedat      
-- -----------+----------+------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------+---------------------
--          1 |       83 | 'Nunc purus. Phasellus in felis. Donec semper sapien a libero.'                                                                                            | 2002-07-21 15:50:01 | 2010-12-07 05:34:01
--          2 |       10 | 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue.' | 2009-11-01 08:04:01 | 2011-08-25 18:43:01
--          3 |       84 | 'Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue.'                                                    | 2007-06-29 00:10:01 | 2009-10-20 09:18:01
--          4 |        4 | 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.'                                                                       | 2012-05-12 16:48:01 | 2007-06-09 13:46:01
--          5 |       44 | 'Donec semper sapien a libero. Nam dui.'                                                                                                                   | 2010-10-31 19:13:01 | 2012-12-27 01:28:01
-- (5 rows)



