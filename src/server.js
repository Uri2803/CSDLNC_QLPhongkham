import express from "express";
import ac from "./backend/account";
import bodyParser, { BodyParser } from "body-parser";
import cors from "cors";
import admin from "./backend/admin";
import dentist from "./backend/dentist"



const app = express();
const port = 3000;

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true}));
app.use(cors());

app.get('/', (req, res) => {
  res.json({message: 'mainpage'});
});

app.post('/test', ac.test);

app.post('/login', ac.login);

app.post('user/register', ac.register);

app.post('admin/getallmedicine', admin.getAllMedicine); 

//app.get('/customer/appointment');

//app.post('/userinfor', ac.getUserInfor);

app.post('dentist/schedule', dentist.getDentistSchedule)

app.listen(port, () => {
  console.log(`Server is running at http://localhost:${port}`);
});
