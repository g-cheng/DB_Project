Cheng Gong 260463255 cheng.gong@mail.mcgill.ca
Michael Ho 260532097 michael.ho@mail.mcgill.ca 
Brian Zhou 260381251 brian.zhou@mail.mcgill.ca

We used PostgreSQL 9.4 on Ubuntu 14.04 and Mac OS X Yosemite

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


Thanks!