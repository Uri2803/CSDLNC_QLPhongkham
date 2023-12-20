const { sql, db, connectToDatabase } = require('../connect');

let makeApoiment = async (apm, result) => {
    try {
      await connectToDatabase(); 
      request.input('Customer_ID', sql.VarChar(5), );
      request.input('Dentist_ID', sql.VarChar(5), scd.dentistID);
      request.input('Date', sql.DATE, );
      request.input('Ship_ID', sql.INT, );
      const request = db.request();
      const res = await request.query("EXEC MakeAppointment");
      if (res.returnValue = -1)
      return result(null, 'Đã tồn tại lịch cho bác sĩ');
    else
     return result(null, 'Đã thêm lịch thành công');
      return result(null, res.recordset);
    } 
    catch (err) {
      return result(err, null);
    } 
    finally {
      sql.close();
    }
  };
  
  module.exports ={
    makeApoiment: makeApoiment,
    
  }