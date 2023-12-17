import express from "express";
import ac from "./backend/account";
import bodyParser, { BodyParser } from "body-parser";


const app = express();
const port = 3000;

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true}));

app.get('/', (req, res) => {
  res.json({message: 'mainpage'});
});

app.post('/test', ac.test);

app.post('/login', ac.login);

app.post('/register', ac.register);

app.get('/customer/appointment');

app.get('/userinfor', ac.getUserInfor);

app.listen(port, () => {
  console.log(`Server is running at http://localhost:${port}`);
});
