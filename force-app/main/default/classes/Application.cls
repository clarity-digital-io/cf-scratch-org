public class Application {

	public static final fflib_Application.UnitOfWorkFactory unitOfWork =
		new fflib_Application.UnitOfWorkFactory(
			new List<SObjectType> {
				Form__c.sObjectType,
				Question__c.sObjectType,
				Response__c.sObjectType,
				Answer__c.sObjectType
			}
		); 

	public static final fflib_Application.ServiceFactory service =
		new fflib_Application.ServiceFactory(
			new Map<Type, Type> {
				IFormsService.class => FormsServiceImpl.class,
				IResponsesService.class => ResponsesServiceImpl.class
			}
		);

	public static final fflib_Application.SelectorFactory selector =
		new fflib_Application.SelectorFactory(
			new Map<SObjectType, Type> {
				Form__c.sObjectType => FormsSelector.class,
				Response__c.sObjectType => ResponsesSelector.class
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
