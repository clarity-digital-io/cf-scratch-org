public class Application {

	public static final fflib_Application.UnitOfWorkFactory unitOfWork =
		new fflib_Application.UnitOfWorkFactory(
			new List<SObjectType> {
				Form__c.sObjectType,
				Question__c.sObjectType,
				Question_Option__c.sObjectType,
				Response__c.sObjectType,
				Answer__c.sObjectType,
				Question_Criteria__c.sObjectType
			}
		); 

	public static final fflib_Application.ServiceFactory service =
		new fflib_Application.ServiceFactory(
			new Map<Type, Type> {
				IFormsService.class => FormsServiceImpl.class,
				IResponsesService.class => ResponsesServiceImpl.class,
				IQuestionsService.class => QuestionsServiceImpl.class,
				IRecordsService.class => RecordsServiceImpl.class
			}
		);

	public static final fflib_Application.SelectorFactory selector =
		new fflib_Application.SelectorFactory(
			new Map<SObjectType, Type> {
				Form__c.sObjectType => FormsSelector.class,
				Response__c.sObjectType => ResponsesSelector.class,
				Question__c.sObjectType => QuestionsSelector.class,
				Question_Option__c.sObjectType => QuestionOptionsSelector.class,
				Question_Criteria__c.sObjectType => QuestionCriteriaSelector.class
			}
		);

	public static final fflib_Application.DomainFactory domain =
		new fflib_Application.DomainFactory(
			Application.Selector,
			new Map<SObjectType, Type> {
				Form__c.sObjectType => Forms.Constructor.class,
				Response__c.sObjectType => Responses.Constructor.class
			}
		);
}
