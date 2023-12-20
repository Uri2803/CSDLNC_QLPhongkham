const { sql, db, connectToDatabase } = require('../connect');

let getAllMedicine = async (req, result) => {
  try {
    await connectToDatabase(); 
    const request = db.request();
    const res = await request.query("EXEC GetMedicineInformation");
    return result(null, res.recordset);
  } 
  catch (err) {
    return result(err, null);
  } 
  finally {
    sql.close();
  }
};


module.exports = {
    getAllMedicine: getAllMedicine,

}