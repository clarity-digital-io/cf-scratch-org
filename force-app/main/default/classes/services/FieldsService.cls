public with sharing class FieldsService {
  public static List<Field__mdt> getAvailableFields() {
    return service().getAvailableFields();
  }

  // public static List<Field__mdt> getOrgAvailableFields() {
  //   return service().getOrgAvailableFields();
  // }

  public static IFieldsService service() {
    return (IFieldsService) Application.service.newInstance(
      IFieldsService.class
    );
  }
}
