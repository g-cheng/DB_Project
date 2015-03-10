-- Members(memberID, email, name, password)
CREATE TABLE member (
    memberID int not null PRIMARY KEY,
    name varchar(50) not null,
    email varchar(50) not null,
    password varchar(50) not null
);

-- Messages(messageID, content, sendAt, memberID)
-- foreign key: memberID references Members(memberID)
CREATE TABLE message (
    messageID int not null PRIMARY KEY,
    FOREIGN KEY (senderID) REFERENCES member(memberID),
    senderID int not null,
    content varchar(1000),
    sentAt timestamp DEFAULT CURRENT_TIMESTAMP,
    receivedAt timestamp
);

-- InstantMessages(imID, characterLength, messageID)
-- foreign key: messageID references Messages(messageID)
CREATE TABLE instantMessage (
    messageID int not null PRIMARY KEY,
    imID int not null,
    FOREIGN KEY (messageID) REFERENCES message,
    characterLength int
);

-- Emails(emailID, priority, messageID)
-- foreign key: messageID references Messages(messageID)
CREATE TABLE email (
    messageID int not null PRIMARY KEY,
    emailID int not null,
    FOREIGN KEY (messageID) REFERENCES message,
    priority int
);

-- Interests(interestID, name, detail)
CREATE TABLE interest (
    interestID int not null PRIMARY KEY,
    name varchar(50),
    detail varchar(255)    
);

-- Circles(circleID, creationDate)
CREATE TABLE circle (
    circleID int not null PRIMARY KEY,
    creationDate date DEFAULT CURRENT_TIMESTAMP
);

-- Groups(groupID, name, circleID)
-- foreign key: circleID references Circles(circleID)
CREATE TABLE friendGroup (
    circleID int not null PRIMARY KEY,
    groupID int not null UNIQUE,
    FOREIGN KEY (circleID) REFERENCES circle,
    name varchar(50)
);

-- FriendLists(friendListID, firstAddDate, circleID, memberID)
-- foreign key: circleID references Circles(circleID)
-- foreign key: memberID references Members(memberID)
CREATE TABLE friendList (
    circleID int not null PRIMARY KEY,
    friendListID int not null UNIQUE,
    FOREIGN KEY (circleID) REFERENCES circle,
    FOREIGN KEY (memberID) REFERENCES member,
    memberID int not null,
    firstAddDate timestamp DEFAULT CURRENT_TIMESTAMP
);

-- Services(serviceID, creationDate)
CREATE TABLE service (
    serviceID int not null PRIMARY KEY,
    creationDate timestamp DEFAULT CURRENT_TIMESTAMP
);

-- Ideas(ideaID, name, content, serviceID, memberID)
-- foreign key: memberID references Members(memberID)
-- foreign key: serviceID references Services(serviceID)
CREATE TABLE idea (
    serviceID int not null PRIMARY KEY,
    ideaID int not null,
    FOREIGN KEY (memberID) REFERENCES member,
    FOREIGN KEY (serviceID) REFERENCES service,
    memberID int not null,
    content varchar(1000)
);

-- Pictures(pictureID, fileSize, serviceID, memberID)
-- foreign key: serviceID references Services(serviceID)
-- foreign key: memberID references Members(memberID)
CREATE TABLE picture (
    serviceID int not null PRIMARY KEY,
    pictureID int not null UNIQUE,
    FOREIGN KEY (serviceID) REFERENCES service,
    FOREIGN KEY (memberID) REFERENCES member,
    memberID int,
    fileSize int,
    url varchar(150)
);

-- Events(eventID, name, eventDate, detail, serviceID, memberID))
-- foreign key: serviceID references Services(serviceID)
-- foreign key: memberID references Members(memberID)
CREATE TABLE event (
    serviceID int not null PRIMARY KEY,
    eventID int not null UNIQUE,
    FOREIGN KEY (serviceID) REFERENCES service,
    FOREIGN KEY (memberID) REFERENCES member,
    memberID int,
    name varchar(50),
    eventDate date,
    detail varchar(1000)
);

-- Videos(videoID, format, serviceID, memberID)
-- foreign key: serviceID references Services(serviceID)
-- foreign key: memberID references Members(memberID)
CREATE TABLE video (
    serviceID int not null PRIMARY KEY,
    videoID int not null,
    FOREIGN KEY (serviceID) REFERENCES service,
    FOREIGN KEY (memberID) REFERENCES member,
    memberID int,
    fileSize int,
    format varchar(50)
);

-- Posts(postID,circleID, memberID, serviceID, postDate)
-- foreign key: circleID references Circles(circleID)
-- foreign key: memberID references Members(memberID)
-- foreign key: serviceID references Services(serviceID)
CREATE TABLE post (
    postID int not null PRIMARY KEY,
    FOREIGN KEY (circleID) REFERENCES circle,
    FOREIGN KEY (memberID) REFERENCES member,
    FOREIGN KEY (serviceID) REFERENCES service,
    circleID int not null,
    memberID int not null,
    serviceID int not null,
    postDate timestamp DEFAULT CURRENT_TIMESTAMP
);
    
-- receives(messageID, memberID, receivedAt)
-- foreign key: messageID references Messages(messageID)
-- foreign key: memberID references Members(memberID)
CREATE TABLE receive (
    PRIMARY KEY (messageID, memberID),
    FOREIGN KEY (messageID) REFERENCES message,
    FOREIGN KEY (memberID) REFERENCES member,
    messageID int not null,
    memberID int not null,
    receivedAt timestamp DEFAULT CURRENT_TIMESTAMP
);

-- shares(interestID, memberID)
-- foreign key: interestID references Interests(interestID)
-- foreign key: memberID references Members(memberID)
CREATE TABLE share (
    PRIMARY KEY (interestID, memberID),
    FOREIGN KEY (interestID) REFERENCES interest,
    FOREIGN KEY (memberID) REFERENCES member,
    interestID int not null,
    memberID int not null
);

-- livestreams to(circleID, memberID, startTime)
-- foreign key: circleID references Circles(circleID)
-- foreign key: memberID references Members(memberID)
CREATE TABLE livestream (
    PRIMARY KEY (circleID, memberID),
    FOREIGN KEY (circleID) REFERENCES circle,
    FOREIGN KEY (memberID) REFERENCES member,
    circleID int not null,
    memberID int not null,
    startTime timestamp
);

-- is-part-of (groupID, memberID, joinDate)
-- foreign key: groupID references Groups(groupID)
-- foreign key: memberID references Members(memberID)
CREATE TABLE partOf (
    PRIMARY KEY (groupID, memberID),
    FOREIGN KEY (groupID) REFERENCES friendGroup(groupID),
    FOREIGN KEY (memberID) REFERENCES member(memberID),
    groupID int not null,
    memberID int not null,
    joinDate timestamp DEFAULT CURRENT_TIMESTAMP
);

-- contains(friendListID, memberID)
-- foreign key: friendListID references FriendLists(friendListID)
-- foreign key: memberID references Members(memberID)
CREATE TABLE contains (
    PRIMARY KEY (friendListID, memberID),   
    friendListID int not null,
    memberID int not null,
    FOREIGN KEY (friendListID) REFERENCES friendList(friendListID),
    FOREIGN KEY (memberID) REFERENCES member(memberID)
);

-- tagged-in(memberID, pictureID)
-- foreign key: memberID references Members(memberID)
-- foreign key: pictureID references Pictures(pictureID)
CREATE TABLE taggedIn (
    pictureID int not null,
    memberID int not null,
    FOREIGN KEY (memberID) REFERENCES member(memberID),
    FOREIGN KEY (pictureID) REFERENCES picture(pictureID),
    PRIMARY KEY (memberID, pictureID)
);

-- attends(memberID, eventID)
-- foreign key: memberID references Member(memberID)
-- foreign key: eventID references Events(eventID)
CREATE TABLE attends (
    PRIMARY KEY (memberID, eventID), 
    FOREIGN KEY (memberID) REFERENCES member(memberID),
    FOREIGN KEY (eventID) REFERENCES event(eventID),
    memberID int not null,
    eventID int not null
);

-- all the tables
-- --------+----------------+-------+----------
--  public | attends        | table | postgres
--  public | circle         | table | postgres
--  public | contains       | table | postgres
--  public | email          | table | postgres
--  public | event          | table | postgres
--  public | friendgroup    | table | postgres
--  public | friendlist     | table | postgres
--  public | idea           | table | postgres
--  public | instantmessage | table | postgres
--  public | interest       | table | postgres
--  public | livestream     | table | postgres
--  public | member         | table | postgres
--  public | message        | table | postgres
--  public | partof         | table | postgres
--  public | picture        | table | postgres
--  public | post           | table | postgres
--  public | receive        | table | postgres
--  public | service        | table | postgres
--  public | share          | table | postgres
--  public | taggedin       | table | postgres
--  public | video          | table | postgres
-- (21 rows)

-- Member Table
-- project=# \d+ member
--                                 Table "public.member"
--   Column  |         Type          | Modifiers | Storage  | Stats target | Description 
-- ----------+-----------------------+-----------+----------+--------------+-------------
--  memberid | integer               | not null  | plain    |              | 
--  name     | character varying(50) | not null  | extended |              | 
--  email    | character varying(50) | not null  | extended |              | 
--  password | character varying(50) | not null  | extended |              | 
-- Indexes:
--     "member_pkey" PRIMARY KEY, btree (memberid)
-- Referenced by:
--     TABLE "attends" CONSTRAINT "attends_memberid_fkey" FOREIGN KEY (memberid) REFERENCES member(memberid)
--     TABLE "contains" CONSTRAINT "contains_memberid_fkey" FOREIGN KEY (memberid) REFERENCES member(memberid)
--     TABLE "event" CONSTRAINT "event_memberid_fkey" FOREIGN KEY (memberid) REFERENCES member(memberid)
--     TABLE "friendlist" CONSTRAINT "friendlist_memberid_fkey" FOREIGN KEY (memberid) REFERENCES member(memberid)
--     TABLE "idea" CONSTRAINT "idea_memberid_fkey" FOREIGN KEY (memberid) REFERENCES member(memberid)
--     TABLE "livestream" CONSTRAINT "livestream_memberid_fkey" FOREIGN KEY (memberid) REFERENCES member(memberid)
--     TABLE "message" CONSTRAINT "message_senderid_fkey" FOREIGN KEY (senderid) REFERENCES member(memberid)
--     TABLE "partof" CONSTRAINT "partof_memberid_fkey" FOREIGN KEY (memberid) REFERENCES member(memberid)
--     TABLE "picture" CONSTRAINT "picture_memberid_fkey" FOREIGN KEY (memberid) REFERENCES member(memberid)
--     TABLE "post" CONSTRAINT "post_memberid_fkey" FOREIGN KEY (memberid) REFERENCES member(memberid)
--     TABLE "receive" CONSTRAINT "receive_memberid_fkey" FOREIGN KEY (memberid) REFERENCES member(memberid)
--     TABLE "share" CONSTRAINT "share_memberid_fkey" FOREIGN KEY (memberid) REFERENCES member(memberid)
--     TABLE "taggedin" CONSTRAINT "taggedin_memberid_fkey" FOREIGN KEY (memberid) REFERENCES member(memberid)
--     TABLE "video" CONSTRAINT "video_memberid_fkey" FOREIGN KEY (memberid) REFERENCES member(memberid)

-- Message Table
-- project=# project=# \d+ message
--                                       Table "public.message"
--    Column   |            Type             |   Modifiers   | Storage  | Stats target | Description 
-- ------------+-----------------------------+---------------+----------+--------------+-------------
--  messageid  | integer                     | not null      | plain    |              | 
--  senderid   | integer                     | not null      | plain    |              | 
--  content    | character varying(1000)     |               | extended |              | 
--  sentat     | timestamp without time zone | default now() | plain    |              | 
--  receivedat | timestamp without time zone |               | plain    |              | 
-- Indexes:
--     "message_pkey" PRIMARY KEY, btree (messageid)
-- Foreign-key constraints:
--     "message_senderid_fkey" FOREIGN KEY (senderid) REFERENCES member(memberid)
-- Referenced by:
--     TABLE "email" CONSTRAINT "email_messageid_fkey" FOREIGN KEY (messageid) REFERENCES message(messageid)
--     TABLE "instantmessage" CONSTRAINT "instantmessage_messageid_fkey" FOREIGN KEY (messageid) REFERENCES message(messageid)
--     TABLE "receive" CONSTRAINT "receive_messageid_fkey" FOREIGN KEY (messageid) REFERENCES message(messageid)

-- instantmessage Table
-- project=# \d+ instantMessage
--                         Table "public.instantmessage"
--      Column      |  Type   | Modifiers | Storage | Stats target | Description 
-- -----------------+---------+-----------+---------+--------------+-------------
--  messageid       | integer | not null  | plain   |              | 
--  imid            | integer | not null  | plain   |              | 
--  characterlength | integer |           | plain   |              | 
-- Indexes:
--     "instantmessage_pkey" PRIMARY KEY, btree (messageid)
-- Foreign-key constraints:
--     "instantmessage_messageid_fkey" FOREIGN KEY (messageid) REFERENCES message(messageid)

-- email table
-- project=# \d+ email
--                           Table "public.email"
--   Column   |  Type   | Modifiers | Storage | Stats target | Description 
-- -----------+---------+-----------+---------+--------------+-------------
--  messageid | integer | not null  | plain   |              | 
--  emailid   | integer | not null  | plain   |              | 
--  priority  | integer |           | plain   |              | 
-- Indexes:
--     "email_pkey" PRIMARY KEY, btree (messageid)
-- Foreign-key constraints:
--     "email_messageid_fkey" FOREIGN KEY (messageid) REFERENCES message(messageid)

-- interest table
-- project=# \d+ interest
--                                  Table "public.interest"
--    Column   |          Type          | Modifiers | Storage  | Stats target | Description 
-- ------------+------------------------+-----------+----------+--------------+-------------
--  interestid | integer                | not null  | plain    |              | 
--  name       | character varying(50)  |           | extended |              | 
--  detail     | character varying(255) |           | extended |              | 
-- Indexes:
--     "interest_pkey" PRIMARY KEY, btree (interestid)
-- Referenced by:
--     TABLE "share" CONSTRAINT "share_interestid_fkey" FOREIGN KEY (interestid) REFERENCES interest(interestid)

-- circle table
-- project=# \d+ circle
--                              Table "public.circle"
--     Column    |  Type   |   Modifiers   | Storage | Stats target | Description 
-- --------------+---------+---------------+---------+--------------+-------------
--  circleid     | integer | not null      | plain   |              | 
--  creationdate | date    | default now() | plain   |              | 
-- Indexes:
--     "circle_pkey" PRIMARY KEY, btree (circleid)
-- Referenced by:
--     TABLE "friendgroup" CONSTRAINT "friendgroup_circleid_fkey" FOREIGN KEY (circleid) REFERENCES circle(circleid)
--     TABLE "friendlist" CONSTRAINT "friendlist_circleid_fkey" FOREIGN KEY (circleid) REFERENCES circle(circleid)
--     TABLE "livestream" CONSTRAINT "livestream_circleid_fkey" FOREIGN KEY (circleid) REFERENCES circle(circleid)
--     TABLE "post" CONSTRAINT "post_circleid_fkey" FOREIGN KEY (circleid) REFERENCES circle(circleid)

-- friendGroup table
-- project=# \d+ friendGroup
--                               Table "public.friendgroup"
--   Column  |         Type          | Modifiers | Storage  | Stats target | Description 
-- ----------+-----------------------+-----------+----------+--------------+-------------
--  circleid | integer               | not null  | plain    |              | 
--  groupid  | integer               | not null  | plain    |              | 
--  name     | character varying(50) |           | extended |              | 
-- Indexes:
--     "friendgroup_pkey" PRIMARY KEY, btree (circleid)
--     "friendgroup_groupid_key" UNIQUE CONSTRAINT, btree (groupid)
-- Foreign-key constraints:
--     "friendgroup_circleid_fkey" FOREIGN KEY (circleid) REFERENCES circle(circleid)
-- Referenced by:
--     TABLE "partof" CONSTRAINT "partof_groupid_fkey" FOREIGN KEY (groupid) REFERENCES friendgroup(groupid)

-- friendList table
-- project=# \d+ friendList
--                                      Table "public.friendlist"
--     Column    |            Type             |   Modifiers   | Storage | Stats target | Description 
-- --------------+-----------------------------+---------------+---------+--------------+-------------
--  circleid     | integer                     | not null      | plain   |              | 
--  friendlistid | integer                     | not null      | plain   |              | 
--  memberid     | integer                     | not null      | plain   |              | 
--  firstadddate | timestamp without time zone | default now() | plain   |              | 
-- Indexes:
--     "friendlist_pkey" PRIMARY KEY, btree (circleid)
--     "friendlist_friendlistid_key" UNIQUE CONSTRAINT, btree (friendlistid)
-- Foreign-key constraints:
--     "friendlist_circleid_fkey" FOREIGN KEY (circleid) REFERENCES circle(circleid)
--     "friendlist_memberid_fkey" FOREIGN KEY (memberid) REFERENCES member(memberid)
-- Referenced by:
--     TABLE "contains" CONSTRAINT "contains_friendlistid_fkey" FOREIGN KEY (friendlistid) REFERENCES friendlist(friendlistid)

-- service table
-- project=# \d+ service
--                                       Table "public.service"
--     Column    |            Type             |   Modifiers   | Storage | Stats target | Description 
-- --------------+-----------------------------+---------------+---------+--------------+-------------
--  serviceid    | integer                     | not null      | plain   |              | 
--  creationdate | timestamp without time zone | default now() | plain   |              | 
-- Indexes:
--     "service_pkey" PRIMARY KEY, btree (serviceid)
-- Referenced by:
--     TABLE "event" CONSTRAINT "event_serviceid_fkey" FOREIGN KEY (serviceid) REFERENCES service(serviceid)
--     TABLE "idea" CONSTRAINT "idea_serviceid_fkey" FOREIGN KEY (serviceid) REFERENCES service(serviceid)
--     TABLE "picture" CONSTRAINT "picture_serviceid_fkey" FOREIGN KEY (serviceid) REFERENCES service(serviceid)
--     TABLE "post" CONSTRAINT "post_serviceid_fkey" FOREIGN KEY (serviceid) REFERENCES service(serviceid)
--     TABLE "video" CONSTRAINT "video_serviceid_fkey" FOREIGN KEY (serviceid) REFERENCES service(serviceid)

-- idea table
-- project=# \d+ idea
--                                    Table "public.idea"
--   Column   |          Type           | Modifiers | Storage  | Stats target | Description 
-- -----------+-------------------------+-----------+----------+--------------+-------------
--  serviceid | integer                 | not null  | plain    |              | 
--  ideaid    | integer                 | not null  | plain    |              | 
--  memberid  | integer                 | not null  | plain    |              | 
--  content   | character varying(1000) |           | extended |              | 
-- Indexes:
--     "idea_pkey" PRIMARY KEY, btree (serviceid)
-- Foreign-key constraints:
--     "idea_memberid_fkey" FOREIGN KEY (memberid) REFERENCES member(memberid)
--     "idea_serviceid_fkey" FOREIGN KEY (serviceid) REFERENCES service(serviceid)


-- project=# \d+ picture
--                                  Table "public.picture"
--   Column   |          Type          | Modifiers | Storage  | Stats target | Description 
-- -----------+------------------------+-----------+----------+--------------+-------------
--  serviceid | integer                | not null  | plain    |              | 
--  pictureid | integer                | not null  | plain    |              | 
--  memberid  | integer                |           | plain    |              | 
--  filesize  | integer                |           | plain    |              | 
--  url       | character varying(150) |           | extended |              | 
-- Indexes:
--     "picture_pkey" PRIMARY KEY, btree (serviceid)
--     "picture_pictureid_key" UNIQUE CONSTRAINT, btree (pictureid)
-- Foreign-key constraints:
--     "picture_memberid_fkey" FOREIGN KEY (memberid) REFERENCES member(memberid)
--     "picture_serviceid_fkey" FOREIGN KEY (serviceid) REFERENCES service(serviceid)
-- Referenced by:
--     TABLE "taggedin" CONSTRAINT "taggedin_pictureid_fkey" FOREIGN KEY (pictureid) REFERENCES picture(pictureid)

-- project=# \d+ event
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
-- Foreign-key constraints:
--     "event_memberid_fkey" FOREIGN KEY (memberid) REFERENCES member(memberid)
--     "event_serviceid_fkey" FOREIGN KEY (serviceid) REFERENCES service(serviceid)
-- Referenced by:
--     TABLE "attends" CONSTRAINT "attends_eventid_fkey" FOREIGN KEY (eventid) REFERENCES event(eventid)

-- project=# \d+ video
--                                  Table "public.video"
--   Column   |         Type          | Modifiers | Storage  | Stats target | Description 
-- -----------+-----------------------+-----------+----------+--------------+-------------
--  serviceid | integer               | not null  | plain    |              | 
--  videoid   | integer               | not null  | plain    |              | 
--  memberid  | integer               |           | plain    |              | 
--  format    | character varying(50) |           | extended |              | 
-- Indexes:
--     "video_pkey" PRIMARY KEY, btree (serviceid)
-- Foreign-key constraints:
--     "video_memberid_fkey" FOREIGN KEY (memberid) REFERENCES member(memberid)
--     "video_serviceid_fkey" FOREIGN KEY (serviceid) REFERENCES service(serviceid)

-- project=# \d+ post
--                                       Table "public.post"
--   Column   |            Type             |   Modifiers   | Storage | Stats target | Description 
-- -----------+-----------------------------+---------------+---------+--------------+-------------
--  postid    | integer                     | not null      | plain   |              | 
--  circleid  | integer                     | not null      | plain   |              | 
--  memberid  | integer                     | not null      | plain   |              | 
--  serviceid | integer                     | not null      | plain   |              | 
--  postdate  | timestamp without time zone | default now() | plain   |              | 
-- Indexes:
--     "post_pkey" PRIMARY KEY, btree (postid)
-- Foreign-key constraints:
--     "post_circleid_fkey" FOREIGN KEY (circleid) REFERENCES circle(circleid)
--     "post_memberid_fkey" FOREIGN KEY (memberid) REFERENCES member(memberid)
--     "post_serviceid_fkey" FOREIGN KEY (serviceid) REFERENCES service(serviceid)

-- project=# \d+ receive
--                                      Table "public.receive"
--    Column   |            Type             |   Modifiers   | Storage | Stats target | Description 
-- ------------+-----------------------------+---------------+---------+--------------+-------------
--  messageid  | integer                     | not null      | plain   |              | 
--  memberid   | integer                     | not null      | plain   |              | 
--  receivedat | timestamp without time zone | default now() | plain   |              | 
-- Indexes:
--     "receive_pkey" PRIMARY KEY, btree (messageid, memberid)
-- Foreign-key constraints:
--     "receive_memberid_fkey" FOREIGN KEY (memberid) REFERENCES member(memberid)
--     "receive_messageid_fkey" FOREIGN KEY (messageid) REFERENCES message(messageid)

-- project=# \d+ share
--                           Table "public.share"
--    Column   |  Type   | Modifiers | Storage | Stats target | Description 
-- ------------+---------+-----------+---------+--------------+-------------
--  interestid | integer | not null  | plain   |              | 
--  memberid   | integer | not null  | plain   |              | 
-- Indexes:
--     "share_pkey" PRIMARY KEY, btree (interestid, memberid)
-- Foreign-key constraints:
--     "share_interestid_fkey" FOREIGN KEY (interestid) REFERENCES interest(interestid)
--     "share_memberid_fkey" FOREIGN KEY (memberid) REFERENCES member(memberid)


-- project=# \d+ livestream;
--                                  Table "public.livestream"
--   Column   |            Type             | Modifiers | Storage | Stats target | Description 
-- -----------+-----------------------------+-----------+---------+--------------+-------------
--  circleid  | integer                     | not null  | plain   |              | 
--  memberid  | integer                     | not null  | plain   |              | 
--  starttime | timestamp without time zone |           | plain   |              | 
-- Indexes:
--     "livestream_pkey" PRIMARY KEY, btree (circleid, memberid)
-- Foreign-key constraints:
--     "livestream_circleid_fkey" FOREIGN KEY (circleid) REFERENCES circle(circleid)
--     "livestream_memberid_fkey" FOREIGN KEY (memberid) REFERENCES member(memberid)

-- project=# \d+ partof;
--                                      Table "public.partof"
--   Column  |            Type             |   Modifiers   | Storage | Stats target | Description 
-- ----------+-----------------------------+---------------+---------+--------------+-------------
--  groupid  | integer                     | not null      | plain   |              | 
--  memberid | integer                     | not null      | plain   |              | 
--  joindate | timestamp without time zone | default now() | plain   |              | 
-- Indexes:
--     "partof_pkey" PRIMARY KEY, btree (groupid, memberid)
-- Foreign-key constraints:
--     "partof_groupid_fkey" FOREIGN KEY (groupid) REFERENCES friendgroup(groupid)
--     "partof_memberid_fkey" FOREIGN KEY (memberid) REFERENCES member(memberid)


-- project=# \d+ contains;
--                           Table "public.contains"
--     Column    |  Type   | Modifiers | Storage | Stats target | Description 
-- --------------+---------+-----------+---------+--------------+-------------
--  friendlistid | integer | not null  | plain   |              | 
--  memberid     | integer | not null  | plain   |              | 
-- Indexes:
--     "contains_pkey" PRIMARY KEY, btree (friendlistid, memberid)
-- Foreign-key constraints:
--     "contains_friendlistid_fkey" FOREIGN KEY (friendlistid) REFERENCES friendlist(friendlistid)
--     "contains_memberid_fkey" FOREIGN KEY (memberid) REFERENCES member(memberid)

-- project=# \d+ taggedIn;
--                         Table "public.taggedin"
--   Column   |  Type   | Modifiers | Storage | Stats target | Description 
-- -----------+---------+-----------+---------+--------------+-------------
--  pictureid | integer | not null  | plain   |              | 
--  memberid  | integer | not null  | plain   |              | 
-- Indexes:
--     "taggedin_pkey" PRIMARY KEY, btree (memberid, pictureid)
-- Foreign-key constraints:
--     "taggedin_memberid_fkey" FOREIGN KEY (memberid) REFERENCES member(memberid)
--     "taggedin_pictureid_fkey" FOREIGN KEY (pictureid) REFERENCES picture(pictureid)

-- project=# \d+ attends;
--                         Table "public.attends"
--   Column  |  Type   | Modifiers | Storage | Stats target | Description 
-- ----------+---------+-----------+---------+--------------+-------------
--  memberid | integer | not null  | plain   |              | 
--  eventid  | integer | not null  | plain   |              | 
-- Indexes:
--     "attends_pkey" PRIMARY KEY, btree (memberid, eventid)
-- Foreign-key constraints:
--     "attends_eventid_fkey" FOREIGN KEY (eventid) REFERENCES event(eventid)
--     "attends_memberid_fkey" FOREIGN KEY (memberid) REFERENCES member(memberid)

