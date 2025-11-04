using { purchaseorders.db as db } from '../db/models';

service CatalogSerivce @(path: 'CatalogService', requires: 'authenticated-user'){

    @readonly
    entity BusinessPartners as projection on db.master.businesspartner;


    entity Addresses @(restrict : [
        {
            grant : ['READ'],
            to : 'Viewer',
            where : 'COUNTRY = $user.myCountry'
        },
        {
            grant : ['WRITE'],
            to : 'Admin'
        }
    ]) as projection on db.master.address;

     @Capabilities : { Readable, Updatable : false, Insertable : false, Deletable : false }
    entity Employees as projection on db.master.employees;

    @readonly
    entity Products as projection on db.master.product;

    entity POItems as projection on db.transaction.poitems;
    // Added some comments here
    @odata.draft.enabled : true
    entity purchaseorders as projection on db.transaction.purchaseorder {
        *,
        case OVERALL_STATUS
            when 'N' then 'New'
            when 'P' then 'Pending'
            when 'B' then 'Blocked'
            when 'C' then 'Completed'
            else 'Delivered'
        end as OverallStatus : String(20) @title : '{i18n>OVERALL_STATUS}' ,
        case OVERALL_STATUS
            when 'N' then 3
            when 'P' then 2
            when 'B' then 1
            when 'C' then 2
            else 3
        end as OSC : Integer ,
        case LIFECYCLE_STATUS
            when 'N' then 'Not Paid'
            when 'P' then 'Paid'
            when 'R' then 'Returned'
            when 'C' then 'Closed'
            else 'Unknown'
        end as LifecycleStatus : String(20) @title : '{i18n>LIFECYCLE_STATUS}' ,
        case LIFECYCLE_STATUS
            when 'N' then 1
            when 'P' then 2
            when 'R' then 1
            when 'C' then 3
            else 1
        end as LCS : Integer ,
        Items : redirected to POItems
    } actions {
        @cds.odata.bindingparameter.name : 'discount'
        @Common.SideEffects : {
            TargetProperties : ['discount/GROSS_AMOUNT']
        }
        action discountOnPrice();
        function largestOrder() returns array of purchaseorders;
    };
    action createEmployee(
        Currency : String,
        ID : UUID,
        accountNumber : String,
        bankId : String,
        bankName : String,
        email : String,
        phoneNumber : String,
        nameFirst : String,
        sex : String,
        language : String,
        nameLast : String,
        loginName : String,
        nameMiddle : String,
        salaryAmount : Decimal(10,2),
        nameInitials : String
    ) returns array of Employees ;

}