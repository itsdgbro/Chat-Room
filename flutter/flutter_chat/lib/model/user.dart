class User {
  late String sender;
  late String message;

  // constructor
  User({required this.sender, required this.message});

  void getSender() => sender;
  void setSender(String username) => sender = username;

  void getMessage() => message;
  void setMessage(String message) => this.message = message;
}
