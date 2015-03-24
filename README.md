Cheng Gong 260463255 cheng.gong@mail.mcgill.ca
Michael Ho 260532097 michael.ho@mail.mcgill.ca 
Brian Zhou 260381251 brian.zhou@mail.mcgill.ca

We used PostgreSQL 9.4 on Ubuntu 14.04 and Mac OS X Yosemite

### Deliverable 2

To run our scripts and populate the database:

1. Go to the current directory in terminal
2. Create and connect to the database
3. $ psql
4. $ \i q2create.sql
5. $ \i q4import.txt
6. $ \i q5select.sql
7. $ \i q6update.sql
8. $ \i q7view.sql
9. $ \i q8constraints.sql

To drop the whole database

$ \i drop.sql

Note:
q3insert.sql and q4insert.sql are only working samples. To populate the whole database we used csv files with q4import.

### Deliverable 3

Running the CLI with your local psql database

running:

edit this.dbURL value to match the name of your local database then run

java DBApp dbUserName dbPassword


if you get "Class Not Found" exception:

 - most likely ran into a problem with your JDBC driver. make sure you have the driver .jar file, make sure its part of your classpath

if you get "authentication failed for user dbusernname" exception:

 - most likely your local psql doesn't allow you to connect via other users than your unix shell username, you need to edit your pg_hba.conf file


after you get it to connect successfully, just edit methods choice2, choice3, choice4 and choice5, these are the menu options.

I already wrote choice1, it probably needs alot of refactoring but at least it runs so you can take a look at it if you want.
