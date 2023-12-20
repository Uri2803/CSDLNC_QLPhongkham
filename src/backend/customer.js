import cus from "../database/connectDatabase/customer";

let makeApoiment = (req, res )=>{
    const {customerID, dentistID, day, shipftID} = req.body;
    if(customerID && dentistID &&day &&shipftID){
        const cus = {customerID, dentistID, day, shipftID};
        cus.makeApoiment(cus, (err, message) =>{
            if(err){
                res.json({status: false, message: message});
            }
            else{
                res.json({status: true, message: message});
            }
        });
    }
    else{
        res.json({status: false, message: 'Không đủ thông tin'});
    }
}

module.exports ={
    makeApoiment: makeApoiment,
}