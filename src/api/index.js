var express = require('express');
var app = express();
var pgp = require('pg-promise')();

var db = pgp({
    host: process.env.DB_HOST || 'postgres',
    port: 5432,
    database: process.env.DB_NAME || 'gemeindedb',
    user: process.env.DB_USER ||  'suisse',
    password: process.env.DB_PASSWORD ||  'suisse'
});

app.use(function(req, res, next) {
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
  next();
});

app.get('/communities', function(req, res) {
  var searchQuery = req.query.q;
  var dbQuery = db.query("SELECT id AS community_id, name FROM public.communities");
  if(searchQuery) {
    dbQuery = db.query(
        "SELECT id, name FROM public.communities_search WHERE name ILIKE '$1^%' OR zip::text = $1",
        searchQuery
    );
  }

  dbQuery.then(function (data) {
      res.json(data);
    })
    .catch(function (error) {
      res.json(error);
  });
});

app.get('/communities/:id', function(req, res) {
  db.one("select * from public.communities_detail where community_id=$1", req.params.id)
    .then(function (data) {
      res.json(data);
    })
    .catch(function (error) {
      res.json(error);
  });
});

app.listen(process.env.PORT || 3000);
