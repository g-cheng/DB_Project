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



