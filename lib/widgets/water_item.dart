import 'package:flutter/material.dart';

import '../models/water.dart';

class WaterItem extends StatelessWidget {
  final Water water;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const WaterItem({
    super.key,
    required this.water,
    required this.onTap,
    required this.onDelete,
  });

  String formatNumber(
    double value, {
    int decimals = 2,
  }) {
    return value
        .toStringAsFixed(decimals)
        .replaceAll('.', ',');
  }

  String formatDate(String date) {
    if (date.isEmpty) {
      return 'Data não informada';
    }

    final parts = date.split('-');

    if (parts.length != 3) {
      return date;
    }

    return '${parts[2]}/${parts[1]}/${parts[0]}';
  }

  double calculateGoal() {
    return water.pesoAtualKg * 35;
  }

  double calculatePercentage() {
    final goal = calculateGoal();

    if (goal <= 0) {
      return 0;
    }

    return (water.quantidadeEmMl / goal) * 100;
  }

  @override
  Widget build(BuildContext context) {
    final percentage = calculatePercentage();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmall = constraints.maxWidth < 500;

        return InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: isSmall
                ? _buildSmallLayout(percentage)
                : _buildLargeLayout(percentage),
          ),
        );
      },
    );
  }

  // ============================================================
  // TELA PEQUENA
  // ============================================================

  Widget _buildSmallLayout(double percentage) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '💧',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'Consumo de água',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            _buildDeleteButton(),
          ],
        ),

        const SizedBox(height: 8),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildValue(
                '${formatNumber(water.quantidadeEmMl)} ml',
                'consumidos',
              ),
            ),

            const SizedBox(width: 15),

            Expanded(
              child: _buildValue(
                '${formatNumber(
                  percentage,
                  decimals: 1,
                )}%',
                'da meta',
                center: true,
              ),
            ),
          ],
        ),

        const SizedBox(height: 6),

        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '${formatDate(water.data)} | '
            'Peso: ${formatNumber(
              water.pesoAtualKg,
              decimals: 1,
            )} kg',
            style: const TextStyle(
              color: Color(0xFF737373),
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // TELA GRANDE
  // ============================================================

  Widget _buildLargeLayout(double percentage) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    '💧',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Consumo de água',
                      overflow:
                          TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight:
                            FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 5),

              Text(
                '${formatDate(water.data)} | '
                'Peso: ${formatNumber(
                  water.pesoAtualKg,
                  decimals: 1,
                )} kg',
                style: const TextStyle(
                  color: Color(0xFF737373),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 10),

        SizedBox(
          width: 100,
          child: _buildValue(
            '${formatNumber(water.quantidadeEmMl)} ml',
            'consumidos',
          ),
        ),

        SizedBox(
          width: 65,
          child: _buildValue(
            '${formatNumber(
              percentage,
              decimals: 1,
            )}%',
            'da meta',
            center: true,
          ),
        ),

        const SizedBox(width: 8),

        _buildDeleteButton(),
      ],
    );
  }

  // ============================================================
  // VALOR
  // ============================================================

  Widget _buildValue(
    String value,
    String subtitle, {
    bool center = false,
  }) {
    return Column(
      crossAxisAlignment: center
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Text(
          value,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          subtitle,
          style: const TextStyle(
            color: Color(0xFF737373),
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // BOTÃO EXCLUIR
  // ============================================================

  Widget _buildDeleteButton() {
    return IconButton(
      onPressed: onDelete,
      tooltip: 'Excluir',
      style: IconButton.styleFrom(
        backgroundColor:
            const Color(0x14FF4C78),
        foregroundColor:
            const Color(0xFFFF4C78),
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(7),
        ),
      ),
      icon: const Icon(
        Icons.close,
        size: 22,
      ),
    );
  }
}
