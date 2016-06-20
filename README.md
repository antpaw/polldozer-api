# Polldozer API

Rails project to create and vote on polls. Checkout [Polldozer](https://github.com/antpaw/polldozer) JavaScript client app.

## API

`GET` `/api/v1/polls/POLL_ID.json`  
```JavaScript
// Response:
{
  "_id": "5766786ae4bf660003f87a86",
  "title": "Kittens",
  "valid_until": 1466419690,
  "finished": true,
  "total_votes_count": 0,
  "ip_has_voted": false,
  "answers": [
    {
      "_id": "5766786ae4bf660003f87a87",
      "title": "yes",
      "vote_count": 0,
      "percent": 0,
      "winner": false
    },
    {
      "_id": "5766786ae4bf660003f87a88",
      "title": "no",
      "vote_count": 0,
      "percent": 0,
      "winner": false
    }
  ]
}
```


`POST` `/api/v1/polls.json`
```JavaScript
// Request
{
  "poll_title": "My Title", // required
  "answer_titles": ["yes", "no"] // required
  "date_offset": {
    "days": 3,
    "hours" 0,
    "minutes": 0
  } // optional, default: 1 day
}
// Response: Poll object
```


`POST` `/api/v1/polls/POLL_ID/vote.json?answer_id=ANSWER_ID`
```JavaScript
// Response: Poll object
```

## APP

`GET` `/polls/POLL_ID` renders a poll  
`GET` `/polls/new` renders a form to create a poll


## Dependencies

* Ruby `2.3.1`
* Mongodb `3.0.7`


## Development

Install dependencies:
```bash
bundle install
npm install
```

Start server:
```bash
npm run s # foreman will start rails and webpack-dev server
```


## Test

```bash
rake test
```


## Deployment

Use `npm run webpack:deploy` to create JavaScript assets for production.
