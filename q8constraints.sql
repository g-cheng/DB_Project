-- 1. 1st CONSTRAINT Event date cannot be earlier than current date

ALTER TABLE event ADD CHECK (eventDate > CURRENT_DATE);

-- This insert is successful

INSERT INTO event (eventDate, eventID, serviceID, memberID, name, detail)
	VALUES ('2018-03-10', 76, 25, 1, 'Unreal Hackathon', 'Build the next augmented reality hacks');

--   column1   | column2 | column3 | column4 |     column5      |                column6
-- ------------+---------+---------+---------+------------------+----------------------------------------
--  2018-03-10 |      76 |      25 |       1 | Unreal Hackathon | Build the next augmented reality hacks
-- (1 row)

-- This insert produces a violation due to the event date being in the past

INSERT INTO event (eventDate, eventID, serviceID, memberID, name, detail)
	VALUES ('2004-03-10', 77, 25, 1, 'Oldie Hackathon', 'Build the next generation of beta cassette');

-- ERROR:  new row for relation "event" violates check constraint "event_eventdate_check"
-- DETAIL:  Failing row contains (25, 77, 1, Oldie Hackathon, 2004-03-10, Build the next generation of beta cassette

-- New schema constraints

--                                   Table "public.event"
--   Column   |          Type           | Modifiers | Storage  | Stats target | Description
-- -----------+-------------------------+-----------+----------+--------------+-------------
--  serviceid | integer                 | not null  | plain    |              |
--  eventid   | integer                 | not null  | plain    |              |
--  memberid  | integer                 |           | plain    |              |
--  name      | character varying(50)   |           | extended |              |
--  eventdate | date                    |           | plain    |              |
--  detail    | character varying(1000) |           | extended |              |
-- Indexes:
--     "event_pkey" PRIMARY KEY, btree (serviceid)
--     "event_eventid_key" UNIQUE CONSTRAINT, btree (eventid)
-- Check constraints:
--     "event_eventdate_check" CHECK (eventdate > 'now'::text::date)
-- Foreign-key constraints:
--     "event_memberid_fkey" FOREIGN KEY (memberid) REFERENCES member(memberid)
--     "event_serviceid_fkey" FOREIGN KEY (serviceid) REFERENCES service(serviceid)
-- Referenced by:
--     TABLE "attends" CONSTRAINT "attends_eventid_fkey" FOREIGN KEY (eventid) REFERENCES event(eventid)

-- 2. 2nd CONSTRAINT Email has to contain a single @

ALTER TABLE event ADD CHECK (eventDate > CURRENT_DATE);