@isTest
public class AnswersResourceUnitTest {

	@TestSetup
	public static void setup(){
		
		Form__c form = TestDataFactory.generateForm(); 

		Form__c updatedForm = FormsService.updateForm(form);

		List<Question__c> newQuestions = TestDataFactory.generateQuestions(new List<Form__c>{ form });

		List<Question__c> questions = QuestionsService.saveQuestions(newQuestions);

		updatedForm.Status__c = 'Published';

		Form__c publishedForm = FormsService.updateForm(updatedForm);

		Response__c response = ResponseController.createResponse( publishedForm.Id, JSON.serialize(new Map<String, String>()) );

	}

	@isTest
	public static void shouldUpdateAnswers() {
		
		Response__c response = [SELECT Id FROM Response__c LIMIT 1];

		List<Question__c> questions = [SELECT Id FROM Question__c LIMIT 5];

		Map<String, String> data = new Map<String, String>();

		List<Answer> answers = new List<Answer>();

		for(Question__c question : questions) {
			
			Answer answer = new Answer();

			answer.UUID = 'UUID-' + question.Id;
			answer.Name = 'Test';
			answer.Answer = 'Answer';
			answer.Question = question.Id;
			answer.Response = response.Id;

			answers.add(answer); 

		}

		data.put('data', JSON.serialize(answers));

		RestRequest request = new RestRequest();

		request.httpMethod = 'POST';
		request.requestBody = Blob.valueOf(JSON.serialize(data));

		RestContext.request = request;

		AnswersResource.updateAnswers();

		List<Answer__c> updatedAnswers = [SELECT Id FROM Answer__c];

		System.assertEquals(answers.size(), updatedAnswers.size());

	} 
	
}
