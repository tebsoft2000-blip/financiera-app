class User {
  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    required this.address,
    required this.roleId,
    required this.roleName,
    required this.active,
    this.mustChangePassword = false,
    this.canManage = false,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'] as int,
    email: json['email'] as String,
    name: json['name'] as String,
    phone: json['phone'] as String?,
    address: json['address'] as String?,
    roleId: json['roleId'] as int,
    roleName: json['roleName'] as String,
    active: json['active'] as bool,
    mustChangePassword: json['mustChangePassword'] as bool? ?? false,
    canManage: json['canManage'] as bool? ?? false,
  );

  final int id;
  final String email;
  final String name;
  final String? phone;
  final String? address;
  final int roleId;
  final String roleName;
  final bool active;
  final bool mustChangePassword;
  final bool canManage;

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'name': name,
    'phone': phone,
    'address': address,
    'roleId': roleId,
    'roleName': roleName,
    'active': active,
    'mustChangePassword': mustChangePassword,
    'canManage': canManage,
  };
}
