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

module.exports = {
    findUser: findUser,
}