const { sql, db, connectToDatabase } = require('../connect');

let makeAppoiment = async (apm, result) => {
    try {
      await connectToDatabase(); 
      console.log(apm);
      const request = db.request();
      request.input('Customer_ID', sql.VarChar(5), apm.customerID);
      request.input('Dentist_ID', sql.VarChar(5), apm.dentistID);
      request.input('Date', sql.DATE, apm.day);
      request.input('Ship_ID', sql.INT, apm.shipftID);
      const res = await request.query("EXEC MakeAppointment @Customer_ID, @Dentist_ID, @Date, @Ship_ID");
      return result(null, 'Đã đặt lịch thành công');
    }
    catch (err) {
      return result(err, 'Lỗi kết nối');
    } 
    finally {
      sql.close();
    }
  };

  let getAppoimentCard = async (customerID, result) => {
    try {
      await connectToDatabase(); 
      const request = db.request();
      request.input('Customer_ID', sql.VarChar(5), customerID);
      const res = await request.query("EXEC GetAppointmentCard @Customer_ID");
      return result(null, res.recordset);
    } 
    catch (err) {
      console.log(err);
      return result(err, null);
    } 
    finally {
      sql.close();
    }
  };


  
  module.exports ={
    makeAppoiment: makeAppoiment,
    getAppoimentCard: getAppoimentCard,
    
  }