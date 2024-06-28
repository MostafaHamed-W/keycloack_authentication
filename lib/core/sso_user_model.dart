class SsoUserModel {
  String? sub;
  bool? emailVerified;
  String? name;
  String? englishFirstName;
  String? englishLastName;
  List<dynamic>? groups;
  String? preferredUsername;
  String? givenName;
  String? familyName;
  String? email;
  String? username;
  String? englishTitle;

  SsoUserModel({
    this.sub,
    this.emailVerified,
    this.name,
    this.englishFirstName,
    this.englishLastName,
    this.groups,
    this.preferredUsername,
    this.givenName,
    this.familyName,
    this.email,
    this.username,
    this.englishTitle,
  });

  factory SsoUserModel.fromJson(Map<String, dynamic> json) => SsoUserModel(
        sub: json['sub'] as String?,
        emailVerified: json['email_verified'] as bool?,
        name: json['name'] as String?,
        englishFirstName: json['englishFirstName'] as String?,
        englishLastName: json['englishLastName'] as String?,
        groups: json['groups'] as List<dynamic>?,
        preferredUsername: json['preferred_username'] as String?,
        givenName: json['given_name'] as String?,
        familyName: json['family_name'] as String?,
        email: json['email'] as String?,
        username: json['username'] as String?,
        englishTitle: json['englishTitle'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'sub': sub,
        'email_verified': emailVerified,
        'name': name,
        'englishFirstName': englishFirstName,
        'englishLastName': englishLastName,
        'groups': groups,
        'preferred_username': preferredUsername,
        'given_name': givenName,
        'family_name': familyName,
        'email': email,
        'username': username,
        'englishTitle': englishTitle,
      };
}
