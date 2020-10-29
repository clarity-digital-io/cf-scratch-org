public class ResultsHelper {

	public static Map<String, String> buildColumn(Question__c question) {

        Map<String, String> column = new Map<String, String>(); 

        if(question.Type__c != 'FreeText') {
            
            column.put('id', question.Id);
            column.put('label', question.Title__c);
            column.put('fieldName', question.Name);
            column.put('type', question.Type__c.toLowerCase());

        }

        return column; 

    }

    public static String buildAnswer(Answer__c answer, Map<Id, List<Question_Option__c>> questionOptions) {

        switch on answer.Question__r.Type__c {
            when 'PictureChoice','Checkbox','Dropdown' {

                String value = '';

				List<Question_Option__c> options = new List<Question_Option__c>();
				
				if( questionOptions.get(answer.Question__c) != null ) {
					options = questionOptions.get(answer.Question__c);
				}
				
				List<String> answers = answer.Answer__c != null ? answer.Answer__c.split(',') : new List<String>();

                for(Question_Option__c option : options) {
					System.debug('answer: ' + answer);

					for(String splitAnswer : answers) {
						if(option.Id == splitAnswer) {
							value = value + option.Label__c + ' '; 
						}
					}

                }

                return value;

            }
            when 'Date' {
                return answer.Date_Answer__c != null ? answer.Date_Answer__c.format() : '';
            }
            when 'RecordGroup' {
                return answer.Record__c;
            }
            when 'Attachments' {
                return answer.ContentVersion__c;
			}
            when else {
                return answer.Answer__c;
            }
        }

    }

}
