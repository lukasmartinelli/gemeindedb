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

app.get('/communities', function(req, res) {
  db.query("select id as community_id, name from public.communities")
    .then(function (data) {
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
