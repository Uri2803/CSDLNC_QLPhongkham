const { sql, db, connectToDatabase } = require('./connect');

let findUser = async (username, result) => {
  try {
    await connectToDatabase(); 
    const request = db.request();
    request.input('UserName', sql.NVarChar(20), username);
    const res = await request.query("EXEC GetUserByUsername @UserName");
    console.log(res);
    return result(null, res.recordset[0]);
  } 
  catch (err) {
    return result(err, null);
  } 
  finally {
    sql.close();
  }
};

let creaateUser = (user, result) =>{
    bcrypt.hash(user.password, 10, (err, pass)=> {
        if(err){
            result(err, err);
        }
        else{
            sql.query("CALL CREATE_USER (?, ?, ?, @err)", [ac.new_username, pass, ac.mail], (err, message) =>{
                if(err){
                    result(err, err);
                }
                else{
                    result(null, "Đã thêm vào csdl");
                }
            });
        }
        return;
    });

    sql.query(" CALL CREATE_USER(?, ?, ?, ?)", [user.username, user.password, user.mail, 1], (err, messsage)=>{
        if(err){
            messsage = 'Lỗi kết nối';
            result(err, messsage);
        }
        else{
            messsage = 'Đăng kí tài khoản thành công';
            result(null, messsage);
        }
    })
}


let getUserInfor = async (userId, result) => {
    try {
      await connectToDatabase(); 
      const request = db.request();
      request.input('userId', sql.VarChar(5), userID);
      const res = await request.query("EXEC ReadUserInfoByUserId @userId");
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
    findUser: findUser,
    creaateUser, creaateUser,
    getUserInfor: getUserInfor,
}