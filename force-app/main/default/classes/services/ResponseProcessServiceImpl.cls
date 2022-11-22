public class ResponseProcessServiceImpl implements IResponseProcessService {

	public void saveConnectionProcess(Form_Connection_Process__c connectionProcess) {

		fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance(new fflib_SecureDML());

		uow.registerUpsert(connectionProcess);

		uow.commitWork();	
	}

	public void saveResponse(List<Response__c> responses) {

		fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance(new fflib_SecureDML());

		uow.registerUpsert(responses);

		uow.commitWork();	
	
	}

}
