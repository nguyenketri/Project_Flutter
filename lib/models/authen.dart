class AuthenModel {
  final String userId;
  final String? sessionId;
  final String userName;
  final String? displayName;
  final List<dynamic>? roles;
  final List<dynamic>? permissions;
  final Map<String, dynamic>? responseStatus;
  final String? profileUrl;

  AuthenModel({
    required this.userId,
    this.sessionId,
    required this.userName,
    this.displayName,
    this.roles,
    this.permissions,
    this.responseStatus,
    this.profileUrl,
  });

  // Convert JSON -> UserModel
  factory AuthenModel.fromJson(Map<String, dynamic> json) {
    return AuthenModel(
      userId: json['UserId'].toString(),
      userName: json['UserName'] ?? '',
      sessionId: json['SessionId'],
      displayName: json['DisplayName'],
      roles: json['Roles'],
      permissions: json['Permissions'],
      responseStatus: json['ResponseStatus'],
      profileUrl: json['ProfileUrl'],
    );
  }

  // Convert UserModel to Json
  Map<String, dynamic> toJson() {
    return {
      "UserId": userId,
      "UserName": userName,
      "SessionId": sessionId,
      "DisplayName": displayName,
      "Roles": roles,
      "Permissions": permissions,
      "ResponseStatus": responseStatus,
      "ProfileUrl": profileUrl,
    };
  }
}
