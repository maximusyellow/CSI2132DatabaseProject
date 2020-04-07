# CSI2132DatabaseProject

## Populate the database
1. Install node
2. Start a command line/terminal at project folder and do the command `npm install`
    If on Windows: also do the command `npm install random-date-generator`
                   and do the command `npm install pg`
3. Start the pgAdmin server and UI on your browser as instructed in the lab
4. Create a new schema called `OnlineTravel`
4. Run the sql queries in the file schema.sql in the pgAdmin SQL editor
5. On lines from 271 - 275 in populate_database.js, change the login information to fit your server
6. In the terminal, do `node populate_database.js`. If everything works, then it should tell you that it has successfully created several tables.
7. In the OnlineTravel.sh app, change PGPASSWORD to the password of your database
