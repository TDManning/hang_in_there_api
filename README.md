# README

System dependencies </br>
Ensure the following dependencies are installed on your system:
* Ruby version: 3.2.2 
* Rails version: 7.1.4
* PostgreSQL: 14.0 
* Bundler version: 2.5.17
* Node.js: Required for managing JavaScript assets

Configuration

* Installing Gems: Run **bundle install** to install all necessary gems for the project:

Database creation

* Set up the database by running **rails db:create**

Database initialization

* After creating the database, run the migrations to set up your database schema: **rails db:seed**

How to run the test suite

*  Run the test suite with: rspec
*  Start the Rails server: rails server

Deployment instructions

*  Deployment to Heroku (Example)
1. Ensure you have the Heroku CLI installed.

2. Create a new Heroku application: heroku create your-app-name

3. Set up your database: heroku addons:create heroku-postgresql:hobby-dev

4. Push the code to Heroku: git push heroku main

5. Run the database migrations on Heroku: heroku run rails db:migrate

6. (Optional) Seed the database on Heroku: heroku run rails db:seed


