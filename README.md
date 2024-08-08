# Those f#cking b@stards at Remote
### They said that my solution could improve:

- The solution does not respect the typical structure/patterns for a Phoenix application
- Ecto APIs are not used to write migrations/queries, just raw queries sent to the lower-level SQL adapter;
- Likewise, Ecto changesets were not used;
- Using a GenServer to implement async email sending could have been ok, but Phoenix.PubSub is unnecessarily thrown into the mix;
- Some claims in the solution documentation were not verified by looking at the actual code; for example, there is no GIN index on the `name` column of the `users` table;
- No automated tests;
- The candidate mentions "performance" a lot in the solution documentation, but doesn't back up any claim with numbers.

### My answer to it
  - There's no typical structure/patterns for a Phoenix application, some Elixir devs picked some shitty rails patterns and tried to force it into Elixir I came from a node.js background and I really believe rails is not the way software should be written(They still werent able to stop gluing their frontends into their backends, looks like a less shit PHP)
  - You mentioned that the test is for people who never used Elixir before, so how do you expect people to know th Ecto apis? I never used Ecto before because I only used Elixir with NoSQL because worrying about the ACID of a SQL is a waste of the concurrency power of Elixir, and second I used the raw SQL because I was dealing with fulltext search queries
  - Again I never used Ecto before so I didnt even know a Ecto changesets existed
  - Perhaps, but I never worked with Phoenix.PubSub before and wanted to give it a try
  - I know some devs at Remote aren't the best at evaluating software but dont tell me you are blind as well, there's literally a migration just for creating the index(https://github.com/KevinDaSilvaS/be-elixir--code-exercise/blob/test-implementation/priv/repo/migrations/20240731223328_create_index_name_users.exs)
  - No way I'm adding test to a shitty api test app if you wanted tests you should have written it as a must, you dont know how to read software to find a migration, I wouldnt be surprised if you had some dificulties in writing as well
  - I mention it most about the database structure and I literally dont have to show numbers, for example when I added the last salary in the users table I wouldnt need to make a join operation, thats literally relational algebra if do less intersections you process less data and the query executes faster and the second one is when I mention I added a index to full text search the name instead of using LIKE operators in sql and there's an entire chapter in the postgres documentation dedicated to explain how it is faster: https://www.postgresql.org/docs/current/textsearch.html Do you guys really think you know more about postgres than the team who developed the database so you need to be proven with numbers?

### My statements against Remote
  - The dev teams sent me a existing Phoenix project that wasnt working, I spent four hours trying to make that shitty software work and at the end I created a new phoenix project from scratch and it ran at the first time, the problem is Remote all the time, unbelievable

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
