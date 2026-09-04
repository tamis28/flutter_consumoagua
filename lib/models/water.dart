class Water {
  final String id;
  final DateTime createdAt;
  final String data;
  final double quantidadeEmMl;
  final double pesoAtualKg;

  Water({
    required this.id,
    required this.createdAt,
    required this.data,
    required this.quantidadeEmMl,
    required this.pesoAtualKg,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'data': data,
      'quantidade_em_ml': quantidadeEmMl,
      'peso_atual_kg': pesoAtualKg,
    };
  }

  factory Water.fromJson(Map<String, dynamic> json) {
    return Water(
      id: json['id'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        json['createdAt'] as int,
      ),
      data: json['data'] as String,
      quantidadeEmMl:
          (json['quantidade_em_ml'] as num).toDouble(),
      pesoAtualKg:
          (json['peso_atual_kg'] as num).toDouble(),
    );
  }

  Water copyWith({
    String? id,
    DateTime? createdAt,
    String? data,
    double? quantidadeEmMl,
    double? pesoAtualKg,
  }) {
    return Water(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      data: data ?? this.data,
      quantidadeEmMl:
          quantidadeEmMl ?? this.quantidadeEmMl,
      pesoAtualKg:
          pesoAtualKg ?? this.pesoAtualKg,
    );
  }
}
