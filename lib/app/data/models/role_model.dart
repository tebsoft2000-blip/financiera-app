class Role {
  const Role({required this.id, required this.name, required this.isSystem, required this.permissions});

  factory Role.fromJson(Map<String, dynamic> json) => Role(
    id: json['id'] as int,
    name: json['name'] as String,
    isSystem: json['isSystem'] as bool? ?? false,
    permissions: List<String>.from(json['permissions'] as List? ?? const []),
  );

  final int id;
  final String name;
  final bool isSystem;
  final List<String> permissions;

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'isSystem': isSystem, 'permissions': permissions};
}
