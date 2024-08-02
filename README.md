# Solution

# Warning
- I didnt managed to make the seeder to run faster I got a metric of inserting the 20k users in around 40-50 minutes, so I recommend reducing the 20k to a lesser number(priv\repo\seeds.exs line 465)
- I searched how to turn the benchmarks faster but I didnt foun anything applied to ecto, so any tips in performance improvement are welcome

# Instalation

To run the app we need to build the image and then after it run the docker-compose file:
```
docker build -t app:1.0 .

docker-compose up -d
```

## Structuring the DB

We have two tables that I would set as:

```
+----------------------------------------------------+         +----------------------------------------------------+
|    USERS                                           |         |                    SALARIES                        |
|   user_id integer primary key                      |         |   salary_id integer primary key                    |
|   name    varchar                                  |         |   salary  integer(560045 = 560045/100 = 5600.45)   |
|   salary  integer(560045 = 560045/100 = 5600.45)   |         |   currency enum(USD, BRL, GPI, etc)                |
|   currency enum(USD, BRL, GPI, etc)                |         |   user_id integer foreign key                      |
|   active   bool default true                       |         +----------------------------------------------------+
+----------------------------------------------------+
```

Salaries table will work more as a log table for changes in salary so the step for adding a new user is like:

```
INSERT INTO Users (name, salary, currency) VALUES ('John Doe', 560045, 'USD');

INSERT INTO Salaries (salary, currency, user_id) VALUES (560045, 'USD', PREVIOUS_INSERTED_USER_ID); 
```

## Mapping the endpoints

### /users GET
  -  Due to having the current or the last salary in the users table I dont have to make joins wich will make queries faster
  -  To save the database some processing time I added pagination to the url like /users?page=1&itens_per_page=10 and use the offset feature of sql
  -  I also created an index to be able to do full text search in Postgres:
      ```
      CREATE INDEX name_index ON users USING GIN (to_tsvector(name));
      ```
  - So the request comes in as http://localhost:4000/users?search=andrew&page=1&itens_per_page=10

  -  And the final JSON something more like:
    ```
         [{"name":"Hudson Andrews","salary":3787},{"name":"Leo Andrews","salary":3056},{"name":"Lily Andrews","salary":7498}]
    ```
  - See the implementation: lib/app/users/user_service.ex

### /invite-users POST
   - For this endpoint I used a GenServer and the Phoenix.PubSub to send batches of 10 users to the email sender at a time
   - Sending small batches helps to not request too much from the database as well as not being blocked by the "email" provider 
   - So the request comes as http://localhost:4000/invite-users and returns an:
     ```
       {"ok":"Mail request sent successfully"}
     ```
   - Meaning that the request batch to send emails was sent to the mailer and it will start processing the mail async
   - See the implementation: lib/app/mailer/mailer-server.ex



Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
