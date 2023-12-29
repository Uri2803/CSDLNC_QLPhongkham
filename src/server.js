import express from "express";
import ac from "./backend/account";
import bodyParser, { BodyParser } from "body-parser";
import cors from "cors";
import admin from "./backend/admin";
import dentist from "./backend/dentist";
import cus from "./backend/customer";



const app = express();
const port = 3000;

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true}));
app.use(cors());

app.get('/', (req, res) => {
  res.json({message: 'mainpage'});
});

app.post('/test', ac.test);

app.post('/login', ac.login); // username, password

app.post('/register', ac.register); // username, password, mail

app.post('/userinfor', ac.getUserInfor); // userId    (Nếu id đó là của customor -> infor customer, dentist -> info dentist,  ... )

app.post('/updateusserinfor', ac.updateUserInfor); //userID, fullName, birthday, sex, mail, address, phone, banking
// Test xong 

app.post('/getallmedicine', admin.getAllMedicine); //

app.post('/addschedule', dentist.addSchedule); // dentistID, day 

app.post('/getscheduledentist', dentist.getDentistSchedule); // dentistID, day

app.post('/makeappoiment', cus.makeAppoiment ); // customerID, dentistID, day, shipftID

app.post('/getappoimentcard', cus.getAppoimentCard) //customerID


//app.get('/customer/appointment');

//app.post('/userinfor', ac.getUserInfor);

app.post('dentist/schedule', dentist.getDentistSchedule)

app.post('dentist/infor', dentist.getDentistInfor); //dentistID



app.listen(port, () => {
  console.log(`Server is running at http://localhost:${port}`);
});
