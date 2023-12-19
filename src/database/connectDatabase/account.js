const { sql, db, connectToDatabase } = require('../connect');

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
            request.input('UserName', sql.NVARCHAR(20), user.username);
            request.input('Password', sql.VARCHAR(300), user.password);
            request.input('Email', sql. VARCHAR(50), user.mail);
            request.input('Role_ID', sql.INT, 1);
            const res = await request.query("AddUser ReadUserInfoByUserId @UserName, @Password, @Email, @Role_ID ");
            return result(null, res.recordset[0]);
          } 
          catch (err) {
              console.log('err' +err);
            return result(err, null);
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
        console.log('err' +err);
      return result(err, null);
    } 
    finally {
      sql.close();
    }
};


let updateUserInfor= async (user, result) =>{
  try {
    await connectToDatabase(); 
    const request = db.request();
    request.input('userId', sql.VarChar(5), userId);
    const res = await request.query("EXEC UpdateUserInfo @UserId, @UserName ,@NewFullName ,@NewBirthDay ,@NewSex)");
    return result(null, res.recordset[0]);
  } 
  catch (err) {
      console.log('err' +err);
    return result(err, null);
  } 
  finally {
    sql.close();
  }
}



module.exports = {
    findUser: findUser,
    creaateUser, creaateUser,
    getUserInfor: getUserInfor,
}