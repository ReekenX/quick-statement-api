# Quick Statement API

API built for personal bank statement analysis and quick matching/splitting/mapping to various income and expense categories.

## Tech Stack

MongoDB for storing categories, statement entries, income and expense collections.

Rails for API.

RSpec for unit tests.

Docker to run this project locally and in production.

## Installing

In order to launch this project you will need Docker with Docker Compose.

Setup and launch API project:

    git clone https://github.com/ReekenX/quick-statement-api.git
    cd quick-statement-api
    docker-compose -f docker-compose.yml -f docker-compose.dev.yml up --build

Setup and launch APP project:

    git clone https://github.com/ReekenX/quick-statement-app.git
    cd quick-statement-app
    docker-compose up --build

After a minute or two project will be up and running on `http://localhost:3000`.

## Testing

100% code coverage.

To run tests use:

    docker exec -it quick-statement-api rspec

## Public Endpoints

Following endpoints are public (no need to authorize).

| Endpoint                     | Description                                                                   |
|:-----------------------------|:------------------------------------------------------------------------------|
| `GET /`                      | Returns welcome message. Just to see if API is working.                       |

## Private Endpoints

Following endpoints are private. In order to use them, you need to send API token with every request.

| Endpoint                     | Description                                                                   |
|:-----------------------------|:------------------------------------------------------------------------------|
| `POST /check`                | Endpoint to check if authorization token is valid.                            |
| `POST /analyse`              | Analyse statement row and detects category if possible.                       |
| `POST /store`                | Stores already processed row to database.                                     |
| `GET /years`                 | Returns list of years that have income/expense reports.                       |
| `GET /years/:month`          | Returns list of year months that have income/expense reports.                 |
| `GET /reports/:year/:month`  | Returns income and expenses report for current moth globally and by category. |

## API Token for Authorization

Generate API token to authorize endpoints with:

    $ docker exec -it quick-statement-api rake token:generate
    New Token for API authorization: 54493095-4a46

It will randomly generate API token. This token will be able to access all the data in the API / Mongo.
