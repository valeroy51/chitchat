class ChatUser {
  ChatUser({
    required this.Email,
    required this.LastSeen,
    required this.PushToken,
    required this.CreateAt,
    required this.Id,
    required this.Image,
    required this.IsOnline,
    required this.Name,
    required this.About,
  });
  late  String Email;
  late  String LastSeen;
  late  String PushToken;
  late  String CreateAt;
  late  String Id;
  late  String Image;
  late  bool IsOnline;
  late  String Name;
  late  String About;

  ChatUser.fromJson(Map<String, dynamic> json){
    Email = json['Email'] ?? '';
    LastSeen = json['Last_seen'] ?? '';
    PushToken = json['Push_token'] ?? '';
    CreateAt = json['Create_at'] ?? '';
    Id = json['Id'] ?? '';
    Image = json['Image'] ?? '';
    IsOnline = json['Is_online'] ?? '';
    Name = json['Name'] ?? '';
    About = json['About'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Email'] = Email;
    data['Last_seen'] = LastSeen;
    data['Push_token'] = PushToken;
    data['Create_at'] = CreateAt;
    data['Id'] = Id;
    data['Image'] = Image;
    data['Is_online'] = IsOnline;
    data['Name'] = Name;
    data['About'] = About;
    return data;
  }
}