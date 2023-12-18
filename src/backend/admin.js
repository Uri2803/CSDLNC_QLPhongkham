import admin from "../database/connectDatabase/admin";

let getAllMedicine = (req, res) =>{
    admin.getAllMedicine(req, (err, medincines)=>{
        if(err){
            res.json({status: false, message: 'Lỗi kết nối'});
        }
        else{
           res.json({status: true, medincines: medincines});
        }
    });
}

module.exports = {
    getAllMedicine: getAllMedicine,

}