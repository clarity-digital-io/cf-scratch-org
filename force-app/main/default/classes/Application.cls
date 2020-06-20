public class Application {

	public static final fflib_Application.UnitOfWorkFactory unitOfWork =
		new fflib_Application.UnitOfWorkFactory(
			new List<SObjectType> {
				Form__c.sObjectType,
				Question__c.sObjectType,
				Question_Option__c.sObjectType,
				Response__c.sObjectType,
				Response_Connection__c.sObjectType,
				Answer__c.sObjectType,
				Question_Criteria__c.sObjectType,
				Form_Connection__c.sObjectType,
				Form_Connection_Field__c.sObjectType,
				ContentVersion.sObjectType,
				ContentDocumentLink.sObjectType
			}
		); 

	public static final fflib_Application.ServiceFactory service =
		new fflib_Application.ServiceFactory(
			new Map<Type, Type> {
				IFormsService.class => FormsServiceImpl.class,
				IFormConnectionsService.class => FormConnectionsServiceImpl.class,
				IFormConnectionFieldsService.class => FormConnectionFieldsServiceImpl.class,
				IResponsesService.class => ResponsesServiceImpl.class,
				IQuestionsService.class => QuestionsServiceImpl.class,
				IRecordsService.class => RecordsServiceImpl.class,
				ISyncService.class => SyncServiceImpl.class,
				IResponseConnectionsService.class => ResponseConnectionsServiceImpl.class,
				IAnswersService.class => AnswersServiceImpl.class
			}
		);

	public static final fflib_Application.SelectorFactory selector =
		new fflib_Application.SelectorFactory(
			new Map<SObjectType, Type> {
				Form__c.sObjectType => FormsSelector.class,
				Form_Connection__c.sObjectType => FormConnectionsSelector.class,
				Form_Connection_Field__c.sObjectType => FormConnectionFieldsSelector.class,
				Response__c.sObjectType => ResponsesSelector.class,
				Question__c.sObjectType => QuestionsSelector.class,
				Question_Option__c.sObjectType => QuestionOptionsSelector.class,
				Question_Criteria__c.sObjectType => QuestionCriteriaSelector.class,
				Response_Connection__c.sObjectType => ResponseConnectionsSelector.class,
				Answer__c.sObjecttype => AnswersSelector.class
			}
		);

	public static final fflib_Application.DomainFactory domain =
		new fflib_Application.DomainFactory(
			Application.Selector,
			new Map<SObjectType, Type> {
				Form__c.sObjectType => Forms.Constructor.class,
				Question__c.sObjectType => Questions.Constructor.class,
				Response__c.sObjectType => Responses.Constructor.class,
				Form_Connection__c.sObjectType => FormConnections.Constructor.class,
				ContentVersion.sObjectType => ContentVersions.Constructor.class,
				Answer__c.sObjectType => Answers.Constructor.class
			}
		);
}
