namespace purchaseorders.common;

using {Currency} from '@sap/cds/common';

/*
* Example : Reuse Types for the Unique ID, Phone Number, and Email address
*/

type Guid        : String(32);
type PhoneNumber : String(32);
type Email       : String(255);

/*
* Example : Type for Gender
*/

type Gender      : String(1) enum {
    male = 'M';
    female = 'F';
    undiscolsed = 'U'
}

/*
* Example : Type for Amount
*/

type AmountT     : Decimal(10, 2) @(
    Semantics.amount.currencyCode: 'CURRENCY_CODE',
    sap.unit                     : 'CURRENCY_CODE'
);

/*
* Example : Aspect for Amount
*/
aspect Amount : {
    CURRENCY     : Currency @(title: '{i18n>CURRENCY_CODE}');
    GROSS_AMOUNT : AmountT  @(title: '{i18n>GROSS_AMOUNT}');
    NET_AMOUNT   : AmountT  @(title: '{i18n>NET_AMOUNT}');
    TAX_AMOUNT   : AmountT  @(title: '{i18n>TAX_AMOUNT}');
}
