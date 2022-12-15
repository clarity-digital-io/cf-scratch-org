public with sharing class FieldsService {
  public static List<Field__mdt> getAvailableFields() {
    return service().getAvailableFields();
  }

  public static IFieldsService service() {
    return (IFieldsService) Application.service.newInstance(
      IFieldsService.class
    );
  }
}
