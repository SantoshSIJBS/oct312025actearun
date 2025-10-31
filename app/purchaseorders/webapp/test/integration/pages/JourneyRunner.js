sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"purchaseorders/test/integration/pages/purchaseordersList",
	"purchaseorders/test/integration/pages/purchaseordersObjectPage",
	"purchaseorders/test/integration/pages/POItemsObjectPage"
], function (JourneyRunner, purchaseordersList, purchaseordersObjectPage, POItemsObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('purchaseorders') + '/test/flp.html#app-preview',
        pages: {
			onThepurchaseordersList: purchaseordersList,
			onThepurchaseordersObjectPage: purchaseordersObjectPage,
			onThePOItemsObjectPage: POItemsObjectPage
        },
        async: true
    });

    return runner;
});

