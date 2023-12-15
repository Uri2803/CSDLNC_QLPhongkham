import sql from "./connect";

let findUser = (username, result) => {
    sql.query(" CALL FIND_USER (?)", [username], (err, user)=>{
        if(err){
            result(err, err);
        }
        else{
            result(null, user);
        }
    });
}

let creaateUser = (user, result) =>{
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

module.exports = {
    findUser: findUser,
    creaateUser, creaateUser,
}