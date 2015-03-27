-- We wrote a complex stored procedure to broadcast an input message from a given user to all members on his friendlist.
CREATE OR REPLACE FUNCTION broadcastToAllFriends(inputUsername VARCHAR(70), inputMessage VARCHAR(300)) RETURNS void AS $$
    DECLARE
    	memberIDVar int;
		friendListRefVar refcursor;
		friendListIDVar int;
		messageIDVar int;
		friendIDVar int;
    BEGIN
    	SELECT memberid INTO memberIDVar FROM member WHERE name=inputUsername;
		SELECT friendlistid INTO friendListIDVar FROM FRIENDLIST f INNER JOIN (SELECT memberid FROM member WHERE name=inputUsername) m ON m.memberid=f.memberid;
		SELECT messageId INTO messageIDVar FROM message WHERE messageid = (SELECT MAX(messageid) FROM message);
		messageIDVar := messageIDVar + 1;
		OPEN friendListRefVar FOR SELECT m.memberid FROM member m INNER JOIN (SELECT memberid FROM contains WHERE friendlistid = friendListIDVar) f ON m.memberid = f.memberid;
		LOOP
		    FETCH NEXT FROM friendListRefVar INTO friendIDVar;
		    EXIT WHEN friendIDVar IS NULL;
		    messageIDVar := messageIDVar + 1;
		    INSERT INTO message (messageID, senderID, content) VALUES (messageIDVar, memberIDVar, inputMessage);
		    INSERT INTO receive (messageID, memberID) VALUES (messageIDVar, friendIDVar);
		END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Query George's friendlist
SELECT m.memberid, m.name FROM member m INNER JOIN (SELECT memberid FROM contains WHERE friendlistid = (SELECT friendlistid FROM friendlist WHERE memberid = 44)) f ON m.memberid = f.memberid;

-- Query all messages sent by George
SELECT mem.name, mem.email, m.memberid, m.messageid, m.content, m.sentat FROM member mem INNER JOIN (SELECT rcv.memberid, msg.messageid, msg.content, msg.sentat FROM receive rcv INNER JOIN (SELECT messageid, content, sentat, senderid FROM message WHERE senderid=44) msg ON msg.messageid = rcv.messageid) m ON m.memberid=mem.memberid;

-- Called the stored procedure
SELECT broadcastToAllFriends('George', 'Hello all! Lets chat!');

-- Query all messages sent by George
SELECT mem.name, mem.email, m.memberid, m.messageid, m.content, m.sentat FROM member mem INNER JOIN (SELECT rcv.memberid, msg.messageid, msg.content, msg.sentat FROM receive rcv INNER JOIN (SELECT messageid, content, sentat, senderid FROM message WHERE senderid=44) msg ON msg.messageid = rcv.messageid) m ON m.memberid=mem.memberid;
