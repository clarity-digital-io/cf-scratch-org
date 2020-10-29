({
	getSetupInformation: function(cmp, event) {

		//cmp.set('v.loading', true);

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
					cmp.set('v.loading', false);

				}

		}); 

		cmp.set('v.mobileLicense', { IsAPIConnected: true })

		//$A.enqueueAction(action);

	}
})
