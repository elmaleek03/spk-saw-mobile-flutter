import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:spk_saw/custom_styles.dart';
import 'package:spk_saw/provider/saw_provider.dart';

class InputMatrixPage extends StatefulWidget {
  const InputMatrixPage({super.key});

  @override
  State<InputMatrixPage> createState() => _InputMatrixPageState();
}

class _InputMatrixPageState extends State<InputMatrixPage> {
  late List<List<TextEditingController>>
      _controllers; // Text editing controllers for each input field
  int _selectedAlternativeIndex =
      0; // Index of the currently selected alternative

  @override
  void initState() {
    super.initState();
    // Initialize text editing controllers for each input field
    _initControllers();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initControllers();
  }

  void _initControllers() {
    final provider = Provider.of<SawProvider>(context, listen: false);
    _controllers = List.generate(
      provider.alternatifList.length,
      (altIndex) => List.generate(
        provider.criteriaList.length,
        (index) {
          if (provider.matrixValues.isNotEmpty &&
              altIndex < provider.matrixValues.length &&
              index < provider.matrixValues[altIndex].length) {
            return TextEditingController(
              text: provider.matrixValues[altIndex][index].toString(),
            );
          } else {
            return TextEditingController();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SawProvider>(
      builder: (context, provider, child) {
        debugPrint('criteria name: ${provider.criteriaList[0].criteria}');
        debugPrint('criteria symbol list: ${provider.criteriaList[0].symbol}');
        debugPrint(
            'criteria weight list: ${provider.criteriaList[0].weightValue}');
        debugPrint('Alternatif list: ${provider.alternatifList}');
        debugPrint('Matrix list: ${provider.matrixValues}');
        return Scaffold(
          appBar: AppBar(
            title: Text('Input Matriks', style: CustomStyles.appBarTextStyle()),
            centerTitle: true,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Display alternatives list
                  Text(
                    'Alternatives:',
                    style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8.0,
                    children:
                        provider.alternatifList.asMap().entries.map((entry) {
                      final index = entry.key;
                      final alternatif = entry.value;
                      final isSelected = _selectedAlternativeIndex == index;
                      return ActionChip(
                        label: Text(
                          alternatif.name,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                        backgroundColor:
                            isSelected ? Colors.brown[400] : Colors.grey[300],
                        onPressed: () {
                          setState(() {
                            _selectedAlternativeIndex = index;
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            'Alternative ${provider.alternatifList[_selectedAlternativeIndex].name}:',
                            style:
                                GoogleFonts.inter(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: provider.criteriaList.length,
                            itemBuilder: (context, index) {
                              final criterion = provider.criteriaList[index];
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${criterion.symbol} ${criterion.criteria}',
                                        style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    const Spacer(),
                                    Expanded(
                                      child: TextField(
                                        controller: _controllers[
                                            _selectedAlternativeIndex][index],
                                        keyboardType: TextInputType.number,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.allow(
                                            RegExp(
                                                r'^(0(\.[1-9])?|([1-9](\.\d{0,1})?)|(10))$'),
                                          )
                                        ],
                                        decoration: InputDecoration(
                                          labelText: criterion.symbol,
                                          hintText: criterion.criteria,
                                          contentPadding:
                                              const EdgeInsets.all(14.0),
                                          labelStyle: GoogleFonts.inter(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          // Button to save matrix values
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  provider.clearMatrixValuesAt(
                                      _selectedAlternativeIndex);
                                  for (var controller in _controllers[
                                      _selectedAlternativeIndex]) {
                                    controller.clear();
                                  }
                                },
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  _saveMatrixValues(provider);
                                },
                                child: Text('Simpan',
                                    style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _saveMatrixValues(SawProvider provider) {
    List<List<double>> matrixValues = [];
    for (int altIndex = 0;
        altIndex < provider.alternatifList.length;
        altIndex++) {
      List<double> altMatrixValues = [];
      for (int critIndex = 0;
          critIndex < provider.criteriaList.length;
          critIndex++) {
        double value =
            double.tryParse(_controllers[altIndex][critIndex].text) ?? 0.0;
        altMatrixValues.add(value);
      }
      matrixValues.add(altMatrixValues);
    }
    provider.fillMatrixValues(matrixValues);
  }
}
