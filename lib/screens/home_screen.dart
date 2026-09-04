import 'package:flutter/material.dart';
import '../models/water.dart';
import '../services/storage_service.dart';
import '../widgets/stat_card.dart';
import '../widgets/water_form_dialog.dart';
import '../widgets/water_item.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StorageService storage =
      StorageService();

  List<Water> waterRecords = [];

  bool loading = true;

  static const double mlPerKg = 35;

  @override
  void initState() {
    super.initState();
    _loadWater();
  }

  Future<void> _loadWater() async {
    final loaded =
        await storage.loadWater();

    setState(() {
      waterRecords = loaded;
      loading = false;
    });
  }

  Future<void> _save() async {
    await storage.saveWater(waterRecords);
  }

  String _today() {
    final now = DateTime.now();

    return '${now.year.toString().padLeft(4, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')}';
  }

  double _calculateGoal(double weight) {
    return weight * mlPerKg;
  }


  double get totalToday {
    final today = _today();

    return waterRecords
        .where(
          (record) => record.data == today,
        )
        .fold<double>(
          0.0,
          (sum, record) =>
              sum + record.quantidadeEmMl,
        );
  }

  double get weightToday {
    final today = _today();

    final recordsOfDay = waterRecords
        .where(
          (record) => record.data == today,
        )
        .toList();

    if (recordsOfDay.isNotEmpty) {
      recordsOfDay.sort(
        (a, b) =>
            b.createdAt.compareTo(a.createdAt),
      );

      return recordsOfDay.first.pesoAtualKg;
    }

    if (waterRecords.isNotEmpty) {
      final sorted = [...waterRecords];

      sorted.sort(
        (a, b) =>
            b.createdAt.compareTo(a.createdAt),
      );

      return sorted.first.pesoAtualKg;
    }

    return 0;
  }

  double get dailyGoal {
    return _calculateGoal(weightToday);
  }

  double get goalPercentage {
    if (dailyGoal <= 0) {
      return 0;
    }

    return (totalToday / dailyGoal) * 100;
  }

  String formatNumber(
    double value, {
    int decimals = 2,
  }) {
    return value
        .toStringAsFixed(decimals)
        .replaceAll('.', ',');
  }

  Future<void> _addWater() async {
    final result =
        await showDialog<Water>(
      context: context,
      builder: (_) =>
          const WaterFormDialog(),
    );

    if (result == null) {
      return;
    }

    setState(() {
      waterRecords.insert(0, result);
    });

    await _save();
  }

  Future<void> _editWater(
    Water water,
  ) async {
    final result =
        await showDialog<Water>(
      context: context,
      builder: (_) =>
          WaterFormDialog(water: water),
    );

    if (result == null) {
      return;
    }

    final index =
        waterRecords.indexWhere(
      (item) => item.id == water.id,
    );

    if (index == -1) {
      return;
    }

    setState(() {
      waterRecords[index] = result;
    });

    await _save();
  }

  Future<void> _deleteWater(
    Water water,
  ) async {
    final confirmed =
        await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Excluir registro?',
          ),
          content: const Text(
            'Excluir este registro de '
            'consumo de água?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  false,
                );
              },
              child: const Text(
                'Cancelar',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  true,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFFFF4C78),
                foregroundColor:
                    Colors.white,
              ),
              child: const Text(
                'Excluir',
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    setState(() {
      waterRecords.removeWhere(
        (item) => item.id == water.id,
      );
    });

    await _save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF4F4F4),

      appBar: AppBar(
        backgroundColor:
            const Color(0xFFF43B40),
        foregroundColor: Colors.white,
        elevation: 0,

        title: const Row(
          children: [
            Text(
              '💧',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(width: 8),
            Text(
              'Agua+',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),

      body: loading
          ? const Center(
              child:
                  CircularProgressIndicator(
                color: Color(0xFFF43B40),
              ),
            )
          : Center(
              child: ConstrainedBox(
                constraints:
                    const BoxConstraints(
                  maxWidth: 800,
                ),
                child: ListView(
                  padding:
                      const EdgeInsets.fromLTRB(
                    14,
                    22,
                    14,
                    50,
                  ),
                  children: [
                    _buildStats(),

                    const SizedBox(
                      height: 18,
                    ),

                    _buildWaterCard(),
                  ],
                ),
              ),
            ),

      floatingActionButton:
          waterRecords.isEmpty
              ? FloatingActionButton(
                  onPressed: _addWater,
                  backgroundColor:
                      const Color(0xFFF43B40),
                  foregroundColor:
                      Colors.white,
                  child:
                      const Icon(Icons.add),
                )
              : null,
    );
  }

  Widget _buildStats() {
    return LayoutBuilder(
      builder: (
        context,
        constraints,
      ) {
        final isSmall =
            constraints.maxWidth < 650;

        final cards = [
          StatCard(
            title:
                'Total consumido hoje',
            value:
                '${formatNumber(totalToday)} ml',
          ),

          StatCard(
            title: 'Meta diária',
            value:
                '${formatNumber(dailyGoal)} ml',
          ),

          StatCard(
            title: 'Meta atingida',
            value:
                '${formatNumber(
              goalPercentage,
              decimals: 1,
            )}%',
          ),
        ];

        if (isSmall) {
          return Column(
            children: [
              for (
                int i = 0;
                i < cards.length;
                i++
              ) ...[
                cards[i],
                if (
                  i != cards.length - 1
                )
                  const SizedBox(
                    height: 8,
                  ),
              ],
            ],
          );
        }

        return Row(
          children: [
            Expanded(
              child: cards[0],
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: cards[1],
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: cards[2],
            ),
          ],
        );
      },
    );
  }

  Widget _buildWaterCard() {
    return Container(
      padding:
          const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withValues(alpha: 0.06),
            blurRadius: 30,
            offset:
                const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Consumo de água',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Clique em um consumo para editar.',
                      style: TextStyle(
                        color:
                            Color(0xFF737373),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              IconButton(
                onPressed: _addWater,
                icon:
                    const Icon(Icons.add),
                color: Colors.white,
                style:
                    IconButton.styleFrom(
                  backgroundColor:
                      const Color(
                    0xFFF43B40,
                  ),
                  fixedSize:
                      const Size(
                    34,
                    34,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          if (waterRecords.isEmpty)
            _buildEmptyState()
          else
            Column(
              children: [
                for (
                  int i = 0;
                  i < waterRecords.length;
                  i++
                ) ...[
                  WaterItem(
                    water:
                        waterRecords[i],
                    onTap: () =>
                        _editWater(
                      waterRecords[i],
                    ),
                    onDelete: () =>
                        _deleteWater(
                      waterRecords[i],
                    ),
                  ),

                  if (
                    i !=
                        waterRecords.length -
                            1
                  )
                    const SizedBox(
                      height: 9,
                    ),
                ],
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Padding(
      padding:
          EdgeInsets.fromLTRB(
        20,
        38,
        20,
        30,
      ),
      child: Column(
        children: [
          Text(
            '💧',
            style:
                TextStyle(
              fontSize: 34,
            ),
          ),

          SizedBox(height: 8),

          Text(
            'Nenhum consumo registrado',
            style: TextStyle(
              fontSize: 16,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          SizedBox(height: 6),

          Text(
            'Toque no botão + para adicionar '
            'seu primeiro consumo.',
            textAlign:
                TextAlign.center,
            style: TextStyle(
              color:
                  Color(0xFF737373),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
