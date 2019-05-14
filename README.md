# README

## Setup
Create the containers and the DB:

`docker-compose run web rails db:setup`

## Run the tests

`docker-compose run web tests`

## Run the API locally

Exposes the app on `localhost:3000`

`docker-compose up web`

## Resources

* GET | POST `/api/games`
* GET | DELETE `/api/games/:id`
* GET `/api/games/:id/frames`
* GET `/api/games/:id/frames/:id`
* GET | POST `/api/games/:id/frames/:id/throws`
* GET `/api/games/:id/frames/:id/throws/:id`

## Examples

List all games:

`curl localhost:3000/api/games`

Create a new game:

`curl localhost:3000/api/games -H 'Content-Type: application/json' -d '{"player_name": "Awesome Player"}'`

Get created game:

`curl localhost:3000/api/games/1`

Get a game current frames score:

`curl localhost:3000/api/games/1/frames`

Get a game frame's score:

`curl localhost:3000/api/games/1/frames/2`

Create a new throw and update the score:

`curl localhost:3000/api/games/1/frames/1/throw -H 'Content-Type: application/json' -d '{"knocked_pins": 3}'`

Destroy a game:

`curl -X DELETE localhost:3000/api/games/1`

## TODO:

Return current_frame after throw creation?
