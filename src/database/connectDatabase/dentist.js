const { sql, db, connectToDatabase } = require('../connect');

let getscheduledentist = async (scd, result) => {
  console.log(scd.dentistID);
  try {
    console.log(scd.dentistID);
    await connectToDatabase(); 
    const request = db.request();
    request.input('Dentist_ID', sql.VarChar(5), scd.dentistID);
    request.input('Day', sql.DATE, scd.day);
    const res = await request.query("EXEC GetDentistSchedule @Dentist_ID, @Day");
    return result(null, res.recordset);
  } 
  catch (err) {
    return result(err, null);
  } 
  finally {
    sql.close();
  }
};


let addSchedule = async (scd, result) =>{
  try {
    await connectToDatabase(); 
    const request = db.request();
    request.input('DentistID', sql.VarChar(5), scd.dentistID);
    request.input('Day', sql.DATE, scd.day);
    const res = await request.query("EXEC AddDentistSchedule @DentistID, @Day");
    return result(null, 'Đã thêm lịch thành công');
  } 
  catch (err) {
    return result(err, 'Lỗi kết nối');
  } 
  finally {
    sql.close();
  }
}

module.exports = {
    getscheduledentist:getscheduledentist,
    addSchedule: addSchedule,

}