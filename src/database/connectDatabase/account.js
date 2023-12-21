const { sql, db, connectToDatabase } = require('../connect');
import bcrypt from "bcrypt";

let findUser = async (username, result) => {
  try {
    await connectToDatabase(); 
    const request = db.request();
    request.input('UserName', sql.NVarChar(20), username);
    const res = await request.query("EXEC GetUserByUsername @UserName");
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
      bcrypt.hash(user.password, 10, async (err, pass) => {
        if(err){
            result(err, err);
        }
        else{
          try {
            await connectToDatabase(); 
            const request = db.request();
            console.log(user);
            request.input('UserName', sql.NVARCHAR(20), user.username);
            request.input('Password', sql.VARCHAR(300), user.password);
            request.input('Email', sql. VARCHAR(50), user.mail);
            request.input('Role_ID', sql.INT, 1);
            const res = await request.query(" EXEC AddUser @UserName, @Password, @Email, @Role_ID ");
            return result(null, 'Đăng ký thành công');
          } 
          catch (err) {
            return result(err, 'Lỗi kết nối');
          } 
          finally {
            sql.close();
          }
        }
        return;
    });
}


let getUserInfor = async (userId, result) => {
    try {
      await connectToDatabase(); 
      const request = db.request();
      request.input('userId', sql.VarChar(5), userId);
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


let updateUserInfor= async (userInf, result) =>{
  try {
    await connectToDatabase(); 
    const request = db.request();
    request.input('User_ID', sql.VarChar(5), userInf.userID);
    request.input('FullName', sql.NVarChar(70), userInf.fullName);
    request.input('BirthDay', sql.DATE, userInf.birthday);
    request.input('Sex', sql.NVarChar(3), userInf.sex);
    request.input('Mail', sql.VarChar(50), userInf.mail);
    request.input('Address', sql.NVarChar(100), userInf.address);
    request.input('Phone', sql.CHAR(10), userInf.phone);
    request.input('Banking', sql.VarChar(20), userInf.banking);
    await request.query("EXEC UpdateUserInfor @User_ID, @FullName, @BirthDay, @Sex, @Mail, @Address, @Phone, @Banking");
    return result(null, ' Đã cập nhật thông tin');
  } 
  catch (err) {
    return result(err, 'Lỗi kết nối');
  } 
  finally {
    sql.close();
  }
}



module.exports = {
    findUser: findUser,
    creaateUser, creaateUser,
    getUserInfor: getUserInfor,
    updateUserInfor: updateUserInfor,
}