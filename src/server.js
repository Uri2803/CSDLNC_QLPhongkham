import express from "express";
import path from "path";
import ac from "./backend/account";


const app = express();
const port = 3000;

app.get('/', (req, res) => {
  res.json({message: 'test'});

});

app.get('/login', ac.login);




app.post('/login', (req, res) =>{

});
app.post('/register', (req, res)=>{

});

app.listen(port, () => {
  console.log(`Server is running at http://localhost:${port}`);
});
