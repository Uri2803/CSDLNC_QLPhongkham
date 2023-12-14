import express from "express";
import path from "path";


const app = express();
const port = 3000;

app.get('/', (req, res) => {
  const pa = path.join(__dirname, 'frontend/mainpage.html');
  res.sendFile(pa);
});
app.get('/login', (req, res) =>{

});



app.post('/login', (req, res) =>{

});
app.post('/register', (req, res)=>{

});

app.listen(port, () => {
  console.log(`Server is running at http://localhost:${port}`);
});
