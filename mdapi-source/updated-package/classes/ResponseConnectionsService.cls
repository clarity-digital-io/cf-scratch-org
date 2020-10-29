public with sharing class ResponseConnectionsService {

	public static IResponseConnectionsService service(){
		return (IResponseConnectionsService) Application.service.newInstance(IResponseConnectionsService.class);
	}

}