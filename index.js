const http = require('http');
const port = process.env.PORT || 3000;

const server = http.createServer((req, res) => {
  res.statusCode = 200;
  const msg = 'Hello Node!\n'
  res.end(msg);
});

const mysql = require('mysql');
const connection = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: 'password',
  database: 'testdb'
});

connection.connect();

const userInput = "Redmond'; DROP TABLE OrdersTable; --";
const query = `SELECT * FROM OrdersTable WHERE ShipCity = '${userInput}'`;

connection.query(query, (error, results, fields) => {
  if (error) throw error;
  console.log(results);
});

connection.end();

server.listen(port, () => {
  console.log(`Server running on http://localhost:${port}/`);
});
