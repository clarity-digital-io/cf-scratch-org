@isTest
public class SetupControllerUnitTest {
	
	@TestSetup
	public static void setup(){
		
		Form__c form = TestDataFactory.generateForm(); 
		
		List<Question__c> newQuestions = TestDataFactory.generateQuestions(new List<Form__c>{ form });

		BuilderController.save(JSON.serialize(newQuestions));
		
	}

	@isTest
	public static void shouldGetSetup() {

	}

	@isTest
	public static void shouldCreateConnect() {
		
	}

	@isTest
	public static void shouldRegisterUsers() {
		
	}

}
