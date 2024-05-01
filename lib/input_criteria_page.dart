import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:spk_saw/custom_styles.dart';
import 'package:spk_saw/model/model.dart';
import 'package:flutter/services.dart';
import 'package:spk_saw/provider/saw_provider.dart';

class InputCriteriaPage extends StatefulWidget {
  const InputCriteriaPage({super.key});

  @override
  State<InputCriteriaPage> createState() => _InputCriteriaPageState();
}

class _InputCriteriaPageState extends State<InputCriteriaPage> {
  TextEditingController symbolController = TextEditingController();
  TextEditingController criteriaController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  String dropdownValue = 'Benefit';

  @override
  Widget build(BuildContext context) {
    return Consumer<SawProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Input Kriteria',
            style: CustomStyles.appBarTextStyle(),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(14.0),
                        child: CircleAvatar(
                          radius:
                              85, // Adjust this value to change the size of the CircleAvatar
                        ),
                      ),
                      Positioned(
                        top:
                            00, // Adjust this value to position the Image.asset
                        child: Image.asset(
                          'assets/images/scale.png',
                          height: 180,
                          width: 180,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Pengambil keputusan memberi bobot preferensi dari setiap kriteria dengan masing-masing jenisnya',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                        fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    controller: symbolController,
                    decoration: InputDecoration(
                      labelText: 'Symbol',
                      contentPadding:
                          const EdgeInsets.all(14.0), // Add this line
                      labelStyle: GoogleFonts.inter(
                          fontSize: 14, fontWeight: FontWeight.w500),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: criteriaController,
                    decoration: InputDecoration(
                      labelText: 'Criteria',
                      contentPadding:
                          const EdgeInsets.all(14.0), // Add this line
                      labelStyle: GoogleFonts.inter(
                          fontSize: 14, fontWeight: FontWeight.w500),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: weightController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*\.?\d{0,2}$'),
                      )
                    ],
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(14.0),
                      labelStyle: GoogleFonts.inter(
                          fontSize: 14, fontWeight: FontWeight.w500),
                      labelText: 'Weight Value',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: dropdownValue,
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                          });
                        },
                        items: <String>['Benefit', 'Cost']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: GoogleFonts.inter(
                                  fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      addCriteria();
                      provider.saveCriteria(provider.criteriaList);
                    },
                    child: Text(
                      'Tambah Kriteria',
                      style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: provider.criteriaList.length,
                    itemBuilder: (context, index) {
                      final criteria = provider.criteriaList[index];
                      return ListTile(
                        leading: Text(
                          '${index + 1}.',
                          style: GoogleFonts.inter(fontSize: 18),
                        ), // Add this line
                        title: Text(
                          '${criteria.symbol} - ${criteria.criteria} (${criteria.attribute})',
                          style: GoogleFonts.inter(),
                        ),
                        subtitle: Text(
                          'Bobot: ${criteria.weightValue}',
                          style: GoogleFonts.inter(),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            provider.removeCriteriaAt(index);
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  void addCriteria() {
    final symbol = symbolController.text;
    final criteria = criteriaController.text;
    final weightValue = double.tryParse(weightController.text) ?? 0;
    final attribute = dropdownValue;

    if (symbol.isNotEmpty && criteria.isNotEmpty && weightValue > 0) {
      final provider = Provider.of<SawProvider>(context, listen: false);
      provider.addCriteria(
        Criteria(
            symbol: symbol,
            criteria: criteria,
            weightValue: weightValue,
            attribute: attribute),
      );
      setState(() {
        symbolController.clear();
        criteriaController.clear();
        weightController.clear();
      });
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Invalid Input'),
            content: Text('Please fill in all fields correctly.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
