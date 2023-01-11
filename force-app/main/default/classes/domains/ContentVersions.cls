public with sharing class ContentVersions extends fflib_SObjectDomain implements IContentVersions {
  public void save(fflib_ISObjectUnitOfWork uow) {
    ContentVersionUnitofWorkHelper cvWork = new ContentVersionUnitofWorkHelper();
    uow.registerWork(cvWork);
    uow.registerNew((List<ContentVersion>) Records);

    cvWork.registerContentVersions((List<ContentVersion>) Records);
  }

  public static IContentVersions newInstance(List<ContentVersion> recordList) {
    return (IContentVersions) Application.Domain.newInstance(recordList);
  }

  public static IContentVersions newInstance(Set<Id> recordIdSet) {
    return (IContentVersions) Application.Domain.newInstance(recordIdSet);
  }

  public ContentVersions(List<ContentVersion> sObjectList) {
    // Domain classes are initialised with lists to enforce bulkification throughout
    super(sObjectList);
  }

  public class Constructor implements fflib_SObjectDomain.IConstructable {
    public fflib_SObjectDomain construct(List<SObject> sObjectList) {
      return new ContentVersions(sObjectList);
    }
  }
}
