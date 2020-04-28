({
	doInit : function(cmp, event, helper) {
		console.log('responseSigned Digital', cmp.get('v.responseSigned'))
	},
	handleSignUpdate: function(cmp, event, helper) {
		var appEvent = $A.get("e.c:DigitalSignatureEvent");
		appEvent.setParams({ "signature" : cmp.get('v.name'), "body": cmp.get('v.responseSigned') });
		appEvent.fire();
	},
	handleAgreeChange: function(cmp, event, helper) {
		let agreed = event.getParam('value'); 
		cmp.set('v.agreed', agreed);
		var appEvent = $A.get("e.c:DigitalSignatureEvent");
		appEvent.setParams({ "agreed" : agreed.length ? true : false });
		appEvent.fire();
	}
})
