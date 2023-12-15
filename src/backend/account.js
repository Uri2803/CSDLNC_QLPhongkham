import ac from "../database/account";
import bcrypt from "bcrypt";


let login = (req, res) =>{
    const {username, password} = req.body;
    if(username, password){
        ac.findUser(username, (err, user) =>{
            if(err){
                res.json({message: 'Username hoặc mật khẩu không đúng', status: false});
            }
            else{
                bcrypt.compare(password, user.password, (err, result)=>{
                    if(err){
                        res.json( {message: 'Lỗi kết nối', status: false });
                    }
                    else{
                        if(result){
                            if(user.role == 'ADMIN'){
                                res.json({message: 'đăng nhập thành công', status: true, role: 'ADMIN', user: user});
                            }
                            if(user.role == ''){

                            }
                        }
                    }

                });
            }
        })
    }
    else{
        res.json({message: 'Vui lòng nhập đầy đủ thông tin', status: false});
    }
}

let register = (req, res) => {
    const { username, password, mail } = req.body;
    if (username && npassword && mail) {
        acc.findUser(username, (err, user) => { // kiểm tra user có tồn tại không 
            if (user) {
                res.json({status: false, message: 'Tài khoản đã tồn tại'});
            } 
            if(!user) {
                const user = { username, password, mail};
                account.createAccount(user, (err, message) => {
                    if (err) {
                        res.json({status: false, message: message});
                    } else {
                        res.json({status: true, message: message});
                    }
                });
            }
        });
    } 
    else{
        res.json({message: 'Vui lòng nhập đầy đủ thông tin', status: false});
    }
}

module.exports = {
    login: login,
    register: register,
}