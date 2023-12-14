import sql from "mssql";

const config = {
    user: 'sa',
    password: 'MinQuan@',
    server: 'localhost',
    port: 1433,
    database: 'QLPKNK',
    options: {
        encrypt: true,
        trustServerCertificate: true, 
    },

}

const db = new sql.ConnectionPool(config);

db.connect((err)=>{
    if(err){
        console.error('Không thể kết nối đến cơ sở dữ liệu:', err);
    }
    else{
        console.log('Kết nối thành công đến cơ sở dữ liệu');
    }
})

module.exports = db;