({
	doInit: function(cmp, event, helper) {

		let action = cmp.get("c.getSetup");

		action.setCallback(this, function (response) {

				let state = response.getState();
		
				if (state === "SUCCESS") {
				 
					let licenses = JSON.parse(response.getReturnValue());

					licenses.forEach(license => {
						if(license.Type == 'Mobile') {
							let mobileLicense = license;
							let withinLicensePeriod = new Date(license.ExpirationDate) < Date.now();
							cmp.set('v.mobileLicense', mobileLicense); 
							cmp.set('v.mobileAccess', withinLicensePeriod); 
						} else {
							let builderLicense = license; 
							cmp.set('v.builderLicense', builderLicense); 
						}
					})

					cmp.set('v.licenses', licenses); 

				}

		}); 

		$A.enqueueAction(action);

	},
	handleAccess: function(cmp, event, helper) {

		window.open('https://clarity-api-auth.herokuapp.com/', "CNN_WindowName", "resizable,scrollbars,status"); 

	},
	handleConnect: function(cmp, event, helper) {

			let action = cmp.get("c.createConnect");

			action.setCallback(this, function (response) {

					let state = response.getState();
			
					if (state === "SUCCESS") {
						console.log(response.getReturnValue());
					}

			}); 

			$A.enqueueAction(action);

	},
	handleSyncUsers: function(cmp, event, helper) {

		let action = cmp.get("c.registerUsers");

		action.setCallback(this, function (response) {

				let state = response.getState();
		
				if (state === "SUCCESS") {
					console.log(response.getReturnValue());
				}

		}); 

		$A.enqueueAction(action);

}
})
