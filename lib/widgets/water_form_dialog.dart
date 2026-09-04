import 'package:flutter/material.dart';

import '../models/water.dart';

class WaterFormDialog extends StatefulWidget {
  final Water? water;

  const WaterFormDialog({
    super.key,
    this.water,
  });

  @override
  State<WaterFormDialog> createState() =>
      _WaterFormDialogState();
}

class _WaterFormDialogState
    extends State<WaterFormDialog> {
  final formKey = GlobalKey<FormState>();

  late TextEditingController dateController;
  late TextEditingController amountController;
  late TextEditingController weightController;

  double goal = 0;
  double percentage = 0;

  bool get isEditing => widget.water != null;

  @override
  void initState() {
    super.initState();

    final water = widget.water;

    dateController = TextEditingController(
      text: water?.data ?? _today(),
    );

    amountController = TextEditingController(
      text: water != null
          ? water.quantidadeEmMl.toString()
          : '',
    );

    weightController = TextEditingController(
      text: water != null
          ? water.pesoAtualKg.toString()
          : '',
    );

    _updatePreview();
  }

  String _today() {
    final now = DateTime.now();

    return '${now.year.toString().padLeft(4, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')}';
  }

  void _updatePreview() {
    final amount =
        double.tryParse(amountController.text) ?? 0;

    final weight =
        double.tryParse(weightController.text) ?? 0;

    setState(() {
      goal = weight * 35;

      percentage = goal > 0
          ? (amount / goal) * 100
          : 0;
    });
  }

  String formatNumber(
    double value, {
    int decimals = 2,
  }) {
    return value
        .toStringAsFixed(decimals)
        .replaceAll('.', ',');
  }

  @override
  void dispose() {
    dateController.dispose();
    amountController.dispose();
    weightController.dispose();
    super.dispose();
  }

  void _save() {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final amount =
        double.parse(amountController.text);

    final weight =
        double.parse(weightController.text);

    final result = Water(
      id: widget.water?.id ??
          '${DateTime.now().millisecondsSinceEpoch}',
      createdAt:
          widget.water?.createdAt ?? DateTime.now(),
      data: dateController.text,
      quantidadeEmMl: amount,
      pesoAtualKg: weight,
    );

    Navigator.pop(context, result);
  }

  Future<void> _selectDate() async {
    DateTime initialDate = DateTime.now();

    if (dateController.text.isNotEmpty) {
      try {
        final parts = dateController.text.split('-');

        initialDate = DateTime(
          int.parse(parts[0]),
          int.parse(parts[1]),
          int.parse(parts[2]),
        );
      } catch (_) {}
    }

    final selected = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      locale: const Locale('pt', 'BR'),
    );

    if (selected != null) {
      setState(() {
        dateController.text =
            '${selected.year.toString().padLeft(4, '0')}-'
            '${selected.month.toString().padLeft(2, '0')}-'
            '${selected.day.toString().padLeft(2, '0')}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      titlePadding: const EdgeInsets.fromLTRB(
        20,
        20,
        12,
        0,
      ),
      contentPadding: const EdgeInsets.fromLTRB(
        20,
        18,
        20,
        10,
      ),
      actionsPadding: const EdgeInsets.fromLTRB(
        20,
        0,
        20,
        20,
      ),
      title: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  isEditing
                      ? 'Editar consumo'
                      : 'Novo consumo',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Preencha os dados abaixo.',
                  style: TextStyle(
                    color: Color(0xFF737373),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const Text(
                'Data',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),

              TextFormField(
                controller: dateController,
                readOnly: true,
                onTap: _selectDate,
                decoration: _inputDecoration(
                  hint: 'Selecione a data',
                  suffixIcon:
                      Icons.calendar_today,
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty) {
                    return 'Informe a data';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 13),

              const Text(
                'Quantidade (ml)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),

              TextFormField(
                controller: amountController,
                keyboardType:
                    const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onChanged: (_) => _updatePreview(),
                decoration: _inputDecoration(
                  hint: 'Ex.: 500',
                ),
                validator: (value) {
                  final number =
                      double.tryParse(value ?? '');

                  if (number == null ||
                      number <= 0) {
                    return 'Informe uma quantidade válida';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 13),

              const Text(
                'Peso atual (kg)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),

              TextFormField(
                controller: weightController,
                keyboardType:
                    const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onChanged: (_) => _updatePreview(),
                decoration: _inputDecoration(
                  hint: 'Ex.: 60',
                ),
                validator: (value) {
                  final number =
                      double.tryParse(value ?? '');

                  if (number == null ||
                      number <= 0) {
                    return 'Informe um peso válido';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              _previewCard(
                title: 'Meta diária estimada',
                value:
                    '${formatNumber(goal)} ml',
                subtitle:
                    'Fórmula: 35 ml × peso corporal',
              ),

              const SizedBox(height: 10),

              _previewCard(
                title: 'Percentual deste consumo',
                value:
                    '${formatNumber(percentage, decimals: 1)}%',
              ),
            ],
          ),
        ),
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () =>
                    Navigator.pop(context),
                style: TextButton.styleFrom(
                  minimumSize:
                      const Size.fromHeight(44),
                  backgroundColor:
                      const Color(0xFFF5F5F5),
                  foregroundColor:
                      const Color(0xFF111111),
                ),
                child: const Text(
                  'Cancelar',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  minimumSize:
                      const Size.fromHeight(44),
                  backgroundColor:
                      const Color(0xFFF43B40),
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Salvar',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    IconData? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF5F5F5),
      contentPadding:
          const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 11,
      ),
      suffixIcon: suffixIcon != null
          ? Icon(suffixIcon, size: 18)
          : null,
      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: Color(0xFFE7E7E7),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: Color(0xFFE7E7E7),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: Color(0xFFF43B40),
        ),
      ),
    );
  }

  Widget _previewCard({
    required String title,
    required String value,
    String? subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0x14F43B40),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: const Color(0x24F43B40),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF737373),
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                color: Color(0xFF737373),
                fontSize: 10,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
