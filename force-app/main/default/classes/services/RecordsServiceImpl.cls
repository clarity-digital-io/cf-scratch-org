public class RecordsServiceImpl implements IRecordsService {
	
	public List<sObject> getRecords() {

		List<sObject> records = [SELECT Id, Name FROM Account];//RecordsSelector.newInstance().selectSObjects();
		return records; 
	}

}

