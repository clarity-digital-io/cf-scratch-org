public interface IContentVersionsSelector extends fflib_ISObjectSelector {
  List<ContentVersion> selectById(Set<Id> recordIds);
}
