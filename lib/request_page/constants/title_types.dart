import 'package:flutter/material.dart';

class TitleTypeFields extends StatelessWidget {
  final String titleType;
  final TextEditingController dateOfTransferController;
  final TextEditingController unitNumberController;
  final TextEditingController floorNumberController;
  final TextEditingController buildingNameController;
  final BuildContext context;

  const TitleTypeFields({
    super.key,
    required this.titleType,
    required this.dateOfTransferController,
    required this.unitNumberController,
    required this.floorNumberController,
    required this.buildingNameController,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    switch (titleType) {
      case 'Transfer Certificate of Title':
        return _buildTransferFields();
      case 'Condominium Certificate of Title':
        return _buildCondominiumFields();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildTransferFields() {
    return Column(
      children: [
        const SizedBox(height: 16),
        TextFormField(
          controller: dateOfTransferController,
          decoration: const InputDecoration(
            labelText: 'Date of Transfer *',
            border: OutlineInputBorder(),
            suffixIcon: Icon(Icons.calendar_today),
          ),
          readOnly: true,
          onTap: () => _selectDate(context),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the date of transfer';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildCondominiumFields() {
    return Column(
      children: [
        const SizedBox(height: 16),
        TextFormField(
          controller: unitNumberController,
          decoration: const InputDecoration(
            labelText: 'Unit Number *',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the unit number';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: floorNumberController,
          decoration: const InputDecoration(
            labelText: 'Floor Number *',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the floor number';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: buildingNameController,
          decoration: const InputDecoration(
            labelText: 'Building Name *',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the building name';
            }
            return null;
          },
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      dateOfTransferController.text = "${picked.month}/${picked.day}/${picked.year}";
    }
  }
}