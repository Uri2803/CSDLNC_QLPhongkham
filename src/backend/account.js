import ac from "../database/account";
import bcrypt from "bcrypt";


let login = (req, res) =>{
    const {username, password} = req.body;
    if(username, password){
        ac.findUser(username, (err, user) =>{
            if(err){
                res.json({message: 'Username haocj mật khẩu không đúng', status: false});
            }
            else{
                bcrypt.compare(password, user.password, (err, result)=>{
                    if(err){
                        res.json( {message: 'Lỗi kết nối', status: false });
                    }
                    else{
                        if(result){
                            if(user.role == 'ADDMIN'){
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

    }
    

}

module.exports = {
    login: login,
}