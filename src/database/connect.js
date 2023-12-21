import sql from "mssql";

const config = {
    user: 'sa',
    password: '123',
    server: 'localhost',
    port: 1433,
    database: 'DENTAL',
    options: {
        encrypt: true,
        trustServerCertificate: true, 
    },

}

const db = new sql.ConnectionPool(config);

const connectToDatabase = async () => {
  try {
    await db.connect();
    console.log('Kết nối thành công đến cơ sở dữ liệu');
  } catch (err) {
    console.error('Không thể kết nối đến cơ sở dữ liệu:', err);
  }
};

module.exports = { sql, db, connectToDatabase };
