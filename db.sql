-- Messages(messageID, content, sendAt, memberID)
-- foreign key: memberID references Members(memberID)

-- InstantMessages(imID, characterLength, messageID)
-- foreign key: messageID references Messages(messageID)

-- Emails(emailID, priority, messageID)
-- foreign key: messageID references Messages(messageID)

-- Interests(interestID, name, detail)

-- Circles(circleID, creationDate)


-- Groups(groupID, name, circleID)
-- foreign key: circleID references Circles(circleID)
CREATE TABLE group (
    groupID int not null primary key,
    name varchar(30),
    circleID int,
    FOREIGN KEY (circleID) REFERENCES Circles(circleID)
);



-- FriendLists(friendListID, firstAddDate, circleID, memberID)
-- foreign key: circleID references Circles(circleID)
-- foreign key: memberID references Members(memberID)

-- Services(serviceID, creationDate)

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






