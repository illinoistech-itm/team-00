// server.js
const express = require('express');
const mysql = require('mysql2');
require('dotenv').config()
console.log(process.env)

// Define Express App
const app = express();
const PORT = process.env.PORT || 3000;
// Serve Static Assets
app.use(express.static('public'));
app.use('/static', express.static('public'))

app.get('/about', (req,res) => {
    res.sendFile('about.html', { root: 'public' });
});

app.get('/questions', (req,res) => {
    res.sendFile('questions.html', { root: 'public' });
});
app.get('/user', (req,res) => {
    res.sendFile('user.html', { root: 'public' });
});

app.get('/db', (req,res) => {

    var query_results = "";
  
  // create the connection to database
   const connection = mysql.createConnection({
     host: process.env.FQDN,
       user: process.env.USER,
       password: process.env.PASS,
       database: process.env.HOST
       });
  
  connection.connect((err) => {
     if(err){
        console.log('Error connecting to Db');
         return;
      }
    console.log('Connection established');
  });
  
  
  // simple query
   connection.query(
     'SELECT * FROM `comment`;',
       function(err, results, fields) {
           query_results = results;
           console.log(results); // results contains rows returned by server
          // console.log(fields); // fields contains extra meta data about results, if available
           console.log(err); // return the error
       }
              );
  
      res.statusCode = 200;
      res.setHeader('Content-Type', 'text/plain');
      res.write('The SQL query results are: ' + JSON.stringify(query_results));
      res.write('Connection to MySQL status:' + conn_status)
      res.end('Hello World' + host.hostname());
  
  });

// Samples @ http://expressjs.com/en/starter/examples.html
app.listen(PORT, () => {
  console.log('Server connected at:',PORT);
});
