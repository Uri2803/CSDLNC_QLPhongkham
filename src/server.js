import express from "express";
import path from "path";
import ac from "./backend/account";


const app = express();
const port = 3000;

app.get('/', (req, res) => {
  res.json({message: 'mainpage'});
});
app.post('/login', ac.login);

app.post('/register', ac.register);

app.get('/customer/appointment');

app.listen(port, () => {
  console.log(`Server is running at http://localhost:${port}`);
});
