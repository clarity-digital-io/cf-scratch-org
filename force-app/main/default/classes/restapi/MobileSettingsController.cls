@RestResource(urlMapping='/MobileSettingsController/*')
global with sharing class MobileSettingsController {

	//called on login/authentication of user logging into mobile app
	//get back company info + org + user info + check permissions of user
	@HttpGet
    global static Boolean start() {

        RestRequest req = RestContext.request;

		RestResponse res = RestContext.response;

		Id userId = UserInfo.getUserId();
		
		Boolean valid = false; 		

		List<PermissionSetAssignment> psas = [SELECT Id, PermissionSetId, PermissionSet.Name, PermissionSet.ProfileId, PermissionSet.Profile.Name, AssigneeId, Assignee.Name FROM PermissionSetAssignment WHERE PermissionSet.Name = 'Clarity_Forms_Mobile' AND AssigneeId = :userId LIMIT 1];

		if(psas.size() > 0) {
			valid = true; 
		}

		return valid; 

	}
	
}
