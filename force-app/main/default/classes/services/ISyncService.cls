public interface ISyncService {
	String registerUsers();
	String connectOrganization();
	String getOrganizationInformation();
	void process(String userId);
}