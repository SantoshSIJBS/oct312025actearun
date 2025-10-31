const cds = require("@sap/cds");


module.exports = (srv) => {
    const { Employees, purchaseorders } = srv.entities;
    srv.on('createEmployee', async(req,res) => {
        const dataset = req.data;
        let returndata = await cds.tx(req).run([
            INSERT.into(Employees).entries(dataset)
        ]).then((resolve, reject)=>{
            if(typeof(resolve) !== undefined){
                return req.data;
            } else {
                req.error(500,"Error in the creation of Employee");
            }
        }).catch(err => {
            req.error(500,"There is an error "+ err.toString());
        });
        return returndata;
    });

    srv.on('discountOnPrice',async(request,response) => {
        try {
            const ID = request.params[0];
            // Step-2 : Declaring the CDS transaction
            const tx = cds.tx(request);
            // Step-3 : Update the Service with the data
            await tx.update(purchaseorders).with({
                GROSS_AMOUNT : { '-=' : 1000 },
                NET_AMOUNT : { '-=' : 800 },
                TAX_AMOUNT : { '-=' : 200 },
                NOTE : "Discounted..!"
            }).where(ID)
        } catch (error) {
            return "Error : " + error.toString();
        }
    });

    srv.on('largestOrder',async(request,response) => {
        try {
           const tx = cds.tx(request);

           const reply = await tx.read(purchaseorders).orderBy({
                GROSS_AMOUNT : 'desc'
           }).limit(1);

           return reply;
        } catch (error) {
            return "Error : " + error.toString();
        }
    });
}