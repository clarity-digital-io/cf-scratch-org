public interface IUsersService {
  User save(User user);
  void assignPermissionSet(User u, PermissionSet ps);
}
