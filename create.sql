-- Members(memberID, email, name, password)
CREATE TABLE member (
    memberID int not null PRIMARY KEY,
    name varchar(30) not null,
    email varchar(30) not null,
    password varchar(30) not null
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
    imID int not null PRIMARY KEY,
    FOREIGN KEY (messageID) REFERENCES message,
    messageID int not null,
    characterLength int
);

-- Emails(emailID, priority, messageID)
-- foreign key: messageID references Messages(messageID)
CREATE TABLE email (
    emailID int not null PRIMARY KEY,
    FOREIGN KEY (messageID) REFERENCES message,
    messageID int not null,
    priority int
);

-- Interests(interestID, name, detail)
CREATE TABLE interest (
    interestID int not null PRIMARY KEY,
    name varchar(30),
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
    groupID int not null PRIMARY KEY,
    FOREIGN KEY (circleID) REFERENCES circle,
    circleID int not null,
    name varchar(30)
);

-- FriendLists(friendListID, firstAddDate, circleID, memberID)
-- foreign key: circleID references Circles(circleID)
-- foreign key: memberID references Members(memberID)
CREATE TABLE friendList (
    friendListID int not null PRIMARY KEY,
    FOREIGN KEY (circleID) REFERENCES circle,
    FOREIGN KEY (memberID) REFERENCES member,
    circleID int not null,
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
    ideaID int not null PRIMARY KEY,
    FOREIGN KEY (memberID) REFERENCES member,
    FOREIGN KEY (serviceID) REFERENCES service,
    memberID int not null,
    serviceID int not null,
    content varchar(1000)
);

-- Pictures(pictureID, fileSize, serviceID, memberID)
-- foreign key: serviceID references Services(serviceID)
-- foreign key: memberID references Members(memberID)
CREATE TABLE picture (
    pictureID int not null PRIMARY KEY,
    FOREIGN KEY (serviceID) REFERENCES service,
    FOREIGN KEY (memberID) REFERENCES member,
    serviceID int,
    memberID int,
    fileSize int,
    url varchar(150)
);

-- Events(eventID, name, eventDate, detail, serviceID, memberID))
-- foreign key: serviceID references Services(serviceID)
-- foreign key: memberID references Members(memberID)
CREATE TABLE event (
    eventID int not null PRIMARY KEY,
    FOREIGN KEY (serviceID) REFERENCES service,
    FOREIGN KEY (memberID) REFERENCES member,
    serviceID int,
    memberID int,
    name varchar(30),
    eventDate date,
    detail varchar(100)
);

-- Videos(videoID, format, serviceID, memberID)
-- foreign key: serviceID references Services(serviceID)
-- foreign key: memberID references Members(memberID)
CREATE TABLE video (
    videoID int not null PRIMARY KEY,
    FOREIGN KEY (serviceID) REFERENCES service,
    FOREIGN KEY (memberID) REFERENCES member,
    serviceID int,
    memberID int,
    format varchar(30)
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
    FOREIGN KEY (groupID) REFERENCES friendGroup,
    FOREIGN KEY (memberID) REFERENCES member,
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
    PRIMARY KEY (memberID, pictureID),   
    FOREIGN KEY (memberID) REFERENCES member,
    FOREIGN KEY (pictureID) REFERENCES picture,
    memberID int not null,
    pictureID int not null
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









