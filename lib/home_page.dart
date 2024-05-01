import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  TextEditingController titleController = TextEditingController();
  bool firstEmptyFound = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    await Provider.of<SawProvider>(context, listen: false).loadData();
    String judulSubjek = await Provider.of<SawProvider>(context, listen: false)
        .loadJudulSubjek();
    titleController.text = judulSubjek;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Aplikasi SPK SAW',
            style: CustomStyles.appBarTextStyle(),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Reset Semua Data'),
                      content:
                          Text('Apakah Anda yakin ingin mereset semua data?'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Batalkan'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text('Ya'),
                          onPressed: () {
                            // Call your method to reset all data here
                            Provider.of<SawProvider>(context, listen: false)
                                .resetAllData();
                            titleController.text = '';
                            Navigator.of(context).pop();
                            Fluttertoast.showToast(
                              msg: 'Semua data telah direset!',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              fontSize: 16.0,
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.refresh_rounded),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Consumer<SawProvider>(builder: (context, provider, child) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Selamat Datang!',
                                    style: GoogleFonts.inter(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w800)),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                                'Aplikasi ini digunakan untuk membantu dalam proses pengambilan keputusan dengan metode SAW (Simple Additive Weighting).\n\nPertama-tama, silahkan input judul subjek yang akan dihitung.',
                                style: GoogleFonts.inter(fontSize: 14)),
                            const SizedBox(height: 8),
                            TextField(
                              controller: titleController,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                hintText: 'Contoh: Pemilihan Laptop Terbaik',
                                // labelText: 'Title of the subject',
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                const Spacer(),
                                TextButton(
                                    onPressed: () {
                                      provider
                                          .addJudulSubjek(titleController.text);
                                      provider.saveJudulSubjek();
                                      Fluttertoast.showToast(
                                        msg: 'Judul telah tersimpan!',
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        fontSize: 16.0,
                                      );
                                    },
                                    child: const Text('Simpan'))
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    ListView.builder(
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                Text(
                                  mainMenu.desc,
                                  style: GoogleFonts.inter(fontSize: 14),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                                    fontWeight:
                                                        FontWeight.w600),
                                              )
                                            : Text(
                                                mainMenu.onTitle,
                                                style: GoogleFonts.inter(
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ))
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }),
        ));
  }
}
