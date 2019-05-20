# Bowling API

For the purpose of the challenge, no authentication mechanism was implemented. The app was configured only to run in dev and test mode.
Docker configurations are in place and all the setup steps are to be run via docker-compose.

## Database

The used Database is Postgresql. There are three models/tables:

* Games
* Frames
* Throws

To see how the DB is modeled please refer to `db/schema.rb` and the models themselves.

## Setup

## Create the containers and the DB:

`docker-compose run dev rails db:setup`

## Run the tests:

`docker-compose run test`

## Run the API locally in dev mode:

`docker-compose up dev`

Exposes the app on `localhost:3000`

## API

### Resources

* GET | POST `/api/games`
* GET | DELETE `/api/games/:id`
* GET `/api/games/:id/frames`
* GET `/api/games/:id/frames/:id`
* POST `/api/games/:id/throws` (for the current frame of the game)
* GET `/api/games/:id/throws/:id`
* GET | POST `/api/games/:id/frames/:id/throws`
* GET `/api/games/:id/frames/:id/throws/:id`

### Error handling

The API should respond to all error situations correctly:

* Resource not found - 404: Not Found
* Bad syntax - 400: Bad Request
* Invalid Parameters - 422: Unprocessable Entity

## Examples

### List all games:

`curl -v localhost:3000/api/games`

### Create a new game:

`curl -v localhost:3000/api/games -H 'Content-Type: application/json' -d '{"player_name": "Awesome Player"}'`

### Get created game:

`curl -v localhost:3000/api/games/1`

### Get a game current frames score:

`curl -v localhost:3000/api/games/1/frames`

### Get a specific frame score:

`curl -v localhost:3000/api/games/1/frames/2`

### Create a new throw and update the score:

`curl -v localhost:3000/api/games/1/frames/1/throws -H 'Content-Type: application/json' -d '{"knocked_pins": 3}'`

or

`curl -v localhost:3000/api/games/1/throws -H 'Content-Type: application/json' -d '{"knocked_pins": 3}'`

to create a throw in the current game frame.

### Destroy a game:

`curl -v -X DELETE localhost:3000/api/games/1`
