class Worker {
  final int id;
  final String name;
  final String email;

  Worker({required this.id, required this.name, required this.email});

  factory Worker.fromJson(Map<String, dynamic> json) {
    return Worker(id: json['id'], name: json['name'], email: json['email']);
  }
}
