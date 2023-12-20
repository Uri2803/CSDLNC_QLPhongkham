import cust from "../database/connectDatabase/customer";

let makeAppoiment = (req, res )=>{
    const {customerID, dentistID, day, shipftID} = req.body;
    if(customerID && dentistID &&day &&shipftID){
        const apm = {customerID, dentistID, day, shipftID};

        cust.makeAppoiment(apm, (err, message) =>{
            if(err){
                console.log(err);
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

let getAppoimentCard = (req, res) =>{
    const {customerID} = req.body;
    if(customerID){
        cust.getAppoimentCard(customerID, (err, card)=>{
            if(err){
                res.json({status: false, message: 'Lỗi kết nối'});
            }
            else{
                res.json({status: true, card: card});
            }
        });

    }
    else{
        res.json({status: false})
    }
}

module.exports ={
    makeAppoiment: makeAppoiment,
    getAppoimentCard: getAppoimentCard
}