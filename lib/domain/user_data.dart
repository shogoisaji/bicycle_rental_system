class UserData {
  String uid;
  String userName;
  String userEmail;
  String postalCode;
  String userAddress;
  bool isAdmin = false;

  UserData({
    required this.uid,
    required this.userName,
    required this.userEmail,
    required this.postalCode,
    required this.userAddress,
  });
}
