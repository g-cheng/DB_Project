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
    friendListID int not null,
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
    eventID int not null,
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
    FOREIGN KEY (friendListID) REFERENCES friendList,
    FOREIGN KEY (memberID) REFERENCES member
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
    FOREIGN KEY (memberID) REFERENCES member,
    FOREIGN KEY (eventID) REFERENCES event,
    memberID int not null,
    eventID int not null
);

-- Also need to submit the result from postgreSQL









