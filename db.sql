-- Messages(messageID, content, sendAt, memberID)
-- foreign key: memberID references Members(memberID)
CREATE TABLE messages (
    messageID int not null primary key,
    content varchar(1000),
    sendAt TIMESTAMP,
    messageID int,
    FOREIGN KEY (memberID) REFERENCES Member(memberID)
);

-- InstantMessages(imID, characterLength, messageID)
-- foreign key: messageID references Messages(messageID)
CREATE TABLE instantMessage (
    imID int not null primary key,
    characterLength int,
    messageID int,
    FOREIGN KEY (messageID) REFERENCES Messages(messageID)
);

-- Emails(emailID, priority, messageID)
-- foreign key: messageID references Messages(messageID)
CREATE TABLE email(
    emailID int not null primary key,
    priority int,
    messageID int,
    FOREIGN KEY (messageID) REFERENCES Messages(messageID)
);
-- Interests(interestID, name, detail)
CREATE TABLE interest(
    interestID int not null primary key,
    name varchar(30),
    detail varchar(255)    
);

-- Circles(circleID, creationDate)
CREATE TABLE Circle (
    circleID int not null primary key,
    creationDate date
);

-- Groups(groupID, name, circleID)
-- foreign key: circleID references Circles(circleID)
CREATE TABLE group (
    groupID int not null primary key,
    name varchar(30),
    circleID int,
    FOREIGN KEY (circleID) REFERENCES Circle(circleID)
);

-- FriendLists(friendListID, firstAddDate, circleID, memberID)
-- foreign key: circleID references Circles(circleID)
-- foreign key: memberID references Members(memberID)
CREATE TABLE friendList (
    friendListID int not null primary key,
    firstAddDate TIMESTAMP,
    circleID int,
    memberID int,
    FOREIGN KEY (circleID) REFERENCES Circle(circleID),
    FOREIGN KEY (memberID) REFERENCES Members(memberID)
);

-- Services(serviceID, creationDate)
CREATE TABLE service(
    serviceID int not null primary key,
    creationDate TIMESTAMP
);


-- Ideas(ideaID, name, content, serviceID, memberID)
-- foreign key: serviceID references Services(serviceID)
-- foreign key: memberID references Members(memberID)

-- Pictures(pictureID, fileSize, serviceID, memberID)
-- foreign key: serviceID references Services(serviceID)
-- foreign key: memberID references Members(memberID)

-- Events(eventID, name, eventDate, detail, serviceID, memberID))
-- foreign key: serviceID references Services(serviceID)
-- foreign key: memberID references Members(memberID)

-- Videos(videoID, format, serviceID, memberID)
CREATE TABLE video (
    videoID int not null primary key,
    format varchar(30)
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






