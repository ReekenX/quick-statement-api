QUICK STATEMENT API
===================

API built for personal bank statement analysis and quick matching/splitting/mapping to various income and expense categories.

Tech Stack
----------

MongoDB for storing categories, statement entries, income and expense collections.

Rails for API.

RSpec for unit tests.

Docker to run this project locally and in production.

Quick Preview
-------------

Fire up with Docker:

    docker-compose -f docker-compose.yml -f docker-compose.dev.yml up --build

Do requests to `localhost:8000` to work with the API.

Testing
-------

100% code coverage.

To run tests use:

    docker exec -it quick-statement-api rspec

Public Endpoints
----------------

Following endpoints are public (no need to authorize).

| Endpoint                     | Description                                                                   |
|:-----------------------------|:------------------------------------------------------------------------------|
| `GET /`                      | Returns welcome message. Just to see if API is working.                       |
| `POST /analyse`              | Analyse statement row and detects category if possible.                       |
| `POST /store`                | Stores already processed row to database.                                     |
| `GET /reports/:year/:month`  | Returns income and expenses report for current moth globally and by category. |
