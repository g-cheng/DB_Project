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
		RAISE NOTICE '% and % and %', memberIDVar, friendListIDVar, messageIDVar;
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
		    

		    

		    



