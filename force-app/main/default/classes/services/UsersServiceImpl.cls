public class UsersServiceImpl implements IUsersService {

	public User save(User u) {

		fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance(new fflib_SecureDML());

		uow.registerNew(u);

		uow.commitWork();	

		return u;
	}

	public void assignPermissionSet(User u, PermissionSet ps) {

		fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance(new fflib_SecureDML());

		PermissionSetAssignment psa = new PermissionSetAssignment(AssigneeId = u.Id, PermissionSetId = ps.Id); 

		uow.registerNew(psa);

		uow.commitWork();	

	}

}
