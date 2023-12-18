const { sql, db, connectToDatabase } = require('../connect');

let getScheduleDoctor = async (DentistID, result) => {
  try {
    await connectToDatabase(); 
    const request = db.request();
    request.input('Dentist_ID', sql.VarChar(5), DentistID);
    const res = await request.query("EXEC GetDoctorSchedule @Dentist_ID");
    return result(null, res.recordset[0]);
  } 
  catch (err) {
    return result(err, null);
  } 
  finally {
    sql.close();
  }
};

module.exports = {
    getScheduleDoctor: getScheduleDoctor,

}