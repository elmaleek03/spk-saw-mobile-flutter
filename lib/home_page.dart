import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:spk_saw/custom_styles.dart';
import 'package:spk_saw/model/data.dart';
import 'package:spk_saw/provider/saw_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool firstEmptyFound = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Aplikasi SPK SAW',
            style: CustomStyles.appBarTextStyle(),
          ),
          centerTitle: true,
        ),
        body: Consumer<SawProvider>(builder: (context, provider, child) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: mainMenuList.length,
                itemBuilder: (context, index) {
                  final mainMenu = mainMenuList[index];
                  final isEmpty = (mainMenu.title.contains('Kriteria') &&
                          provider.criteriaList.isEmpty) ||
                      (mainMenu.title.contains('Alternatif') &&
                          provider.alternatifList.isEmpty) ||
                      (mainMenu.title.contains('Matrix') &&
                          provider.matrixValues.isEmpty) ||
                      (mainMenu.title.contains('Hasil Akhir') &&
                          provider.sortedAlternatives.isEmpty);
                  final currentList = mainMenu.title.contains('Kriteria')
                      ? provider.criteriaList.length
                      : mainMenu.title.contains('Alternatif')
                          ? provider.alternatifList.length
                          : [];
                  if (isEmpty && !firstEmptyFound) {
                    firstEmptyFound = true;
                  }
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(mainMenu.title,
                                  style: GoogleFonts.inter(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600)),
                              isEmpty
                                  ? const Icon(Icons.error_rounded,
                                      color: Colors.red, size: 32)
                                  : const Icon(Icons.check_circle,
                                      color: Colors.green, size: 32)
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(mainMenu.desc,
                              style: GoogleFonts.inter(fontSize: 14)),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: isEmpty
                                    ? Text(
                                        mainMenu.subDesc,
                                        style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w500),
                                      )
                                    : Text(
                                        'Terdapat $currentList data telah diinput',
                                        style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w500),
                                      ),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                mainMenu.pageNavigator));
                                  },
                                  child: isEmpty
                                      ? Text(
                                          mainMenu.offTitle,
                                          style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w600),
                                        )
                                      : Text(
                                          mainMenu.onTitle,
                                          style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w600),
                                        ))
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }));
  }
}
