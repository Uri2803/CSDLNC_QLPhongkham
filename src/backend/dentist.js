import dentist from "../database/connectDatabase/dentist";

let getDentistSchedule = (req, res) =>{
    const {Dentist_ID} = req.body;
    console.log(Dentist_ID);
    if(Dentist_ID){
        dentist.getScheduleDoctor(Dentist_ID, (err, dentistShedule) =>{
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

module.exports = {
    getDentistSchedule: getDentistSchedule,
}