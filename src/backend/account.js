import ac from "../database/account";
import bcrypt from "bcrypt";


let login = (req, res) =>{
    console.log(req.body);
    const {username, password} = req.body;
    if(username, password){
        ac.findUser(username, (err, user) =>{
            if(err){
                res.json({message: 'Username hoặc mật khẩu không đúng', status: false});
            }
            else{
                bcrypt.compare(password, user.Password, (err, result)=>{
                    if(err){
                        res.json( {message: 'Lỗi kết nối', status: false });
                    }
                    else{
                        console.log('test')
                        console.log(user);
                        console.log(result);
                        if(result){
                            if(user.RoleName == 'admin'){
                                res.json({message: 'đăng nhập thành công', status: true, role: 'admin', user: user});
                            }
                            if(user.RoleName == 'user'){
                                res.json({message: 'đăng nhập thành công', status: true, role: 'user', user: user});
                                console.log('test4');

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
        ac.findUser(username, (err, user) => { // kiểm tra user có tồn tại không 
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

let test = (req, res) =>{
    const {test, message} = req.body;
    res.json({test: test, message: message});
}

let getUserInfor = (req, res) =>{
    const {userId} = req.body;
    if(userId){
        ac.getUserInfor(userId, (err, user) =>{
            if(err){
                console.log(err);
                res.json({message: 'lỗi kết nối', user: null, status: false });
            }
            else{
                res.json({user:user, status: true});
            }
        });
    }
    else{
        res.json({user:null, status: false});

    }
  
}

let updateUserInfor = (req, res) =>{
    const {userId, fullName, brirthday, sex, mail } = req.body;
    ac.updateUserInfor();
    //UI.User_ID, UI.FullName, UI.UserName, UI.BirthDay, UI.Age, UI.Sex, U.Email, R.RoleName, R.RoleDescription 

}


module.exports = {
    login: login,
    register: register,
    test: test,
    getUserInfor: getUserInfor,
}