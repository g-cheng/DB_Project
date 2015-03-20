INSERT INTO member (memberID, name, email, password)
    VALUES (1, 'Bob', 'bobby@alibaba.com', 'hellohello');
INSERT INTO member (memberID, name, email, password)
    VALUES (2, 'George', 'insta@yahoo.com', 'pwpwpw');
INSERT INTO member (memberID, name, email, password)
    VALUES (3, 'Heather', 'heatherdunbar@houseofcards.com', 'iamtheprez');
INSERT INTO member (memberID, name, email, password)
    VALUES (4, 'Anthony', 'anthonycalvillo@alouettes.com', 'championship');
INSERT INTO member (memberID, name, email, password)
    VALUES (5, 'Lebron', 'lebronjames@cavs.com', 'threepit');

SELECT * FROM member;

-- After execute these inserts and select (directly from the current .sql file), the following prints

-- INSERT 0 1
-- INSERT 0 1
-- INSERT 0 1
-- INSERT 0 1
-- INSERT 0 1
--         1 | Bob     | bobby@alibaba.com              | hellohello
--         2 | George  | insta@yahoo.com                | pwpwpw
--         3 | Heather | heatherdunbar@houseofcards.com | iamtheprez
--         4 | Anthony | anthonycalvillo@alouettes.com  | championship
--         5 | Lebron  | lebronjames@cavs.com           | threepit


