public class FieldsServiceImpl implements IFieldsService {
  public List<Field__mdt> getAllAvailableFields() {
    List<Field__mdt> fields = FieldsSelector.newInstance().selectAllFields();
    return fields;
  }

  public List<Field__mdt> getOrgAvailableFields() {

    Subscription_Level__mdt level = Fields

    List<Field__mdt> fields = FieldsSelector.newInstance().selectFields(new Set<Id>{ formId });
    return fields;
  }
}
