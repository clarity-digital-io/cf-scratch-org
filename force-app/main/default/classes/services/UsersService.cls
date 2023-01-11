public with sharing class UsersService {
  public static User save(User u) {
    return service().save(u);
  }

  public static void assignPermissionSet(User u, PermissionSet ps) {
    service().assignPermissionSet(u, ps);
  }

  public static IUsersService service() {
    return (IUsersService) Application.service.newInstance(IUsersService.class);
  }
}
