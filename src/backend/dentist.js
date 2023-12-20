import dentist from "../database/connectDatabase/dentist";

let getDentistSchedule = (req, res) =>{
    const {dentistID, day} = req.body;
    console.log(dentistID, day);
    if(dentistID && day){
        const scd = {dentistID, day};
        console.log(scd);
        dentist.getscheduledentist( scd, (err, dentistShedule) =>{
            if(err){
                res.json({status: false});
            }
            else{
                res.json({status: true, dentistShedule: dentistShedule});
            }
        });
    }
    else{
        res.json({status: false});
    }
}

let addSchedule = (req, res) =>{
    const {dentistID, day} = req.body;

    if(dentistID && day){
        const scd = {dentistID, day};
        dentist.addSchedule(scd, (err, message)=>{
            if(err){
                res.json({status: false, message: message});
            }
            else{
                res.json({status: true, message: message});
            }
        });
        
    }   
    else {
        res.json({status: false, message: 'Chưa điền đầy đủ thông tin '});
    }
}


module.exports = {
    getDentistSchedule: getDentistSchedule,
    addSchedule: addSchedule,

}