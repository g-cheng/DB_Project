-- Messages(messageID, content, sendAt, memberID)
CREATE TABLE message (
    messageID int not null primary key,
    content varchar(1000),
    sentAt timestamp,
    received timestamp,
    senderID int,
);
-- foreign key: memberID references Members(memberID)
ALTER TABLE message
ADD  FOREIGN KEY (senderID) REFERENCES member;

-- InstantMessages(imID, characterLength, messageID)
-- foreign key: messageID references Messages(messageID)
CREATE TABLE instantMessage (
    imID int not null primary key,
    characterLength int,
    messageID int
);
ALTER TABLE instantMessage 
ADD  FOREIGN KEY (messageID) REFERENCES message;


-- Emails(emailID, priority, messageID)
CREATE TABLE email(
    emailID int not null primary key,
    priority int,
    messageID int
);
-- foreign key: messageID references Messages(messageID)
ALTER TABLE email 
ADD  FOREIGN KEY (messageID) REFERENCES message;

-- Interests(interestID, name, detail)
CREATE TABLE interest(
    interestID int not null primary key,
    name varchar(30),
    detail varchar(255)    
);

-- Circles(circleID, creationDate)
CREATE TABLE circle (
    circleID int not null primary key,
    creationDate date
);

-- Groups(groupID, name, circleID)
-- foreign key: circleID references Circles(circleID)
CREATE TABLE group (
    groupID int not null primary key,
    name varchar(30),
    circleID int,
    FOREIGN KEY (circleID) REFERENCES circle
);

-- FriendLists(friendListID, firstAddDate, circleID, memberID)
CREATE TABLE friendList (
    friendListID int not null primary key,
    firstAddDate timestamp,
    circleID int,
    memberID int
);
-- foreign key: circleID references Circles(circleID)
ALTER TABLE friendList 
ADD FOREIGN KEY (circleID) REFERENCES circle;

-- foreign key: memberID references Members(memberID)
ALTER TABLE idea 
ADD FOREIGN KEY (memberID) REFERENCES member;

-- Services(serviceID, creationDate)
CREATE TABLE service (
    serviceID int not null primary key,
    creationDate timestamp
);


-- Ideas(ideaID, name, content, serviceID, memberID)
CREATE TABLE idea (
    ideaID int not null primary key,
    content varchar(1000),
    serviceID int,
    memberID int
);
-- foreign key: memberID references Members(memberID)
ALTER TABLE idea 
ADD FOREIGN KEY (memberID) REFERENCES member;
-- foreign key: serviceID references Services(serviceID)
ALTER TABLE idea 
ADD FOREIGN KEY serviceID REFERENCES Service(serviceID),

-- Pictures(pictureID, fileSize, serviceID, memberID)
CREATE TABLE picture (
    pictureID int not null primary key,
    fileSize int,
    serviceID int,
    memberID int
);
-- foreign key: serviceID references Services(serviceID)
ALTER TABLE picture
ADD FOREIGN KEY (serviceID) REFERENCES service;
-- foreign key: memberID references Members(memberID)
ALTER TABLE picture
ADD FOREIGN KEY (memberID) REFERENCES member;

-- Events(eventID, name, eventDate, detail, serviceID, memberID))
CREATE TABLE event (
    eventID int not null primary key,
    name varchar(30),
    eventDate date,
    detail varchar(100),
    serviceID int,
    memberID int,
);
-- foreign key: serviceID references Services(serviceID)
ALTER TABLE event
ADD FOREIGN KEY (serviceID) REFERENCES service;
-- foreign key: memberID references Members(memberID)
ALTER TABLE event
ADD FOREIGN KEY (memberID) REFERENCES member;

-- Videos(videoID, format, serviceID, memberID)
CREATE TABLE video (
    videoID int not null primary key,
    format varchar(30),
    serviceID int,
    memberID int,
);
-- foreign key: serviceID references Services(serviceID)
ALTER TABLE video
ADD FOREIGN KEY (serviceID) REFERENCES service;
-- foreign key: memberID references Members(memberID)
ALTER TABLE video 
ADD FOREIGN KEY (memberID) REFERENCES member;

-- Members(memberID, email, name, password)
CREATE TABLE member (
    memberID int not null primary key,
    name varchar(30) not null,
    email varchar(30) not null,
    password varchar(30) not null,
);


-- Posts(postID,circleID, memberID, serviceID, postDate)
-- foreign key: circleID references Circles(circleID)
-- foreign key: memberID references Members(memberID)
-- foreign key: serviceID references Services(serviceID)

-- receives(messageID, memberID, receivedAt)
-- foreign key: messageID references Messages(messageID)
-- foreign key: memberID references Members(memberID)

-- shares(interestID, memberID)
-- foreign key: interestID references Interests(interestID)
-- foreign key: memberID references Members(memberID)

-- livestreams to(circleID, memberID, startTime)
-- foreign key: circleID references Circles(circleID)
-- foreign key: memberID references Members(memberID)

-- is-part-of (groupID, memberID, joinDate)
-- foreign key: groupID references Groups(groupID)
-- foreign key: memberID references Members(memberID)

-- contains(friendListID, memberID)
-- foreign key: friendListID references FriendLists(friendListID)
-- foreign key: memberID references Members(memberID)

-- tagged-in(memberID, pictureID)
-- foreign key: memberID references Members(memberID)
-- foreign key: pictureID references Pictures(pictureID)

-- attends(memberID, eventID)
-- foreign key: memberID references Member(memberID)
-- foreign key: eventID references Events(eventID)

-- tagged-in(memberID, pictureID)
-- foreign key: memberID references Members(memberID)
-- foreign key: pictureID references Pictures(pictureID)







