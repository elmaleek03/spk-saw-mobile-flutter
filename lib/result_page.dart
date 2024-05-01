import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:spk_saw/custom_styles.dart';
// import 'package:spk_saw/final_page.dart';
import 'package:spk_saw/provider/saw_provider.dart';
import 'package:flutter_to_pdf/flutter_to_pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart' as material;

class ResultPage extends StatefulWidget {
  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  late ExportDelegate exportDelegate;

  @override
  void initState() {
    super.initState();
    final ExportOptions options = ExportOptions(
      pageFormatOptions: PageFormatOptions.a4(),
    );
    exportDelegate = ExportDelegate(options: options);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SawProvider>(builder: (context, provider, _) {
      // final ExportDelegate exportDelegate = ExportDelegate(options: options);
      bool areListsEmpty = provider.criteriaList.isEmpty ||
          provider.alternatifList.isEmpty ||
          provider.matrixValues.isEmpty;

      Future<void> generatePdf() async {
        final pdf = pw.Document();

        // Function to build the table
        pw.Widget buildTable({
          required List<String> headers,
          required List<String> rowNames,
          required List<List<String>> rowData,
        }) {
          final List<pw.TableRow> tableRows = [];

          // Add headers
          tableRows.add(
            pw.TableRow(
              children: headers.map((header) {
                return pw.Container(
                  alignment: pw.Alignment.center,
                  child: pw.Text(header,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  padding: pw.EdgeInsets.all(5),
                  margin: pw.EdgeInsets.all(2),
                );
              }).toList(),
            ),
          );

          // Add rows
          for (int i = 0; i < rowNames.length; i++) {
            final List<pw.Widget> cells = [pw.Text(rowNames[i])];
            for (int j = 0; j < rowData[i].length; j++) {
              cells.add(pw.Text(rowData[i][j]));
            }
            tableRows.add(pw.TableRow(children: cells));
          }

          return pw.Table(
            children: tableRows,
            border: pw.TableBorder.all(color: PdfColors.black),
          );
        }

        // Function to build the sorted table
        pw.Widget buildSortedTable({
          required List<String> headers,
          required List<String> rowNames,
          required List<double> rowData,
        }) {
          final List<pw.TableRow> tableRows = [];

          // Add headers
          tableRows.add(
            pw.TableRow(
              children: headers.map((header) {
                return pw.Container(
                  alignment: pw.Alignment.center,
                  child: pw.Text(header,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  padding: pw.EdgeInsets.all(5),
                  margin: pw.EdgeInsets.all(2),
                );
              }).toList(),
            ),
          );

          // Add rows
          for (int i = 0; i < rowNames.length; i++) {
            tableRows.add(
              pw.TableRow(
                children: [
                  pw.Text(rowNames[i]),
                  pw.Text(rowData[i].toStringAsFixed(2)),
                ],
              ),
            );
          }

          return pw.Table(
            children: tableRows,
            border: pw.TableBorder.all(color: PdfColors.black),
          );
        }

        // Add content to the PDF
        pdf.addPage(
          pw.MultiPage(
            build: (pw.Context context) {
              return <pw.Widget>[
                pw.Padding(
                  padding: pw.EdgeInsets.all(4),
                  child: pw.Center(
                    child: pw.Text(
                      'Sistem Pendukung Keputusan ${provider.judulSubjek} Menggunakan Metode Simple Additive Weighting (SAW)',
                      style: pw.TextStyle(
                          fontSize: 22, fontWeight: pw.FontWeight.bold),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                ),
                pw.SizedBox(height: 16),
                pw.Center(
                  child: pw.Text(
                    'Matriks Keputusan',
                    style: pw.TextStyle(
                        fontSize: 18, fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.SizedBox(height: 8),
                buildTable(
                  headers: ['Alternatives']..addAll(List.generate(
                      provider.criteriaList.length,
                      (index) => 'C${index + 1}').toList()),
                  rowNames:
                      provider.alternatifList.map((alt) => alt.name).toList(),
                  rowData: List.generate(
                    provider.matrixValues.length,
                    (altIndex) => List.generate(
                      provider.matrixValues[altIndex].length,
                      (critIndex) =>
                          provider.matrixValues[altIndex][critIndex].toString(),
                    ),
                  ),
                ),

                pw.SizedBox(height: 16),
                pw.Center(
                  child: pw.Text(
                    'Matriks Ternormalisasi (R)',
                    style: pw.TextStyle(
                        fontSize: 18, fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.SizedBox(height: 8),
                buildTable(
                  headers: ['Alternatives']..addAll(List.generate(
                      provider.criteriaList.length,
                      (index) => 'C${index + 1}').toList()),
                  rowNames:
                      provider.alternatifList.map((alt) => alt.name).toList(),
                  rowData: List.generate(
                    provider.normalizedMatrix[0].length,
                    (critIndex) => List.generate(
                      provider.normalizedMatrix.length,
                      (altIndex) => provider.normalizedMatrix[altIndex]
                              [critIndex]
                          .toStringAsFixed(2),
                    ),
                  ),
                ),
                // Calculated Weight Table
                pw.SizedBox(height: 16),
                pw.Center(
                  child: pw.Text(
                    'Matriks Nilai Preferensi (P)',
                    style: pw.TextStyle(
                        fontSize: 18, fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.SizedBox(height: 8),
                buildTable(
                  headers: ['Hasil'],
                  rowNames:
                      provider.alternatifList.map((alt) => alt.name).toList(),
                  rowData: provider.calculatedWeightSums
                      .map((sum) => [sum.toStringAsFixed(2)])
                      .toList(),
                ),
                // Rank Table
                pw.SizedBox(height: 16),
                pw.Center(
                  child: pw.Text(
                    'Hasil Pengurutan',
                    style: pw.TextStyle(
                        fontSize: 18, fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.SizedBox(height: 8),
                buildSortedTable(
                  headers: ['Alternatives', 'Nilai Akhir'],
                  rowNames: provider.sortedAlternatives
                      .map((alt) => alt.name)
                      .toList(),
                  rowData: provider.sortedAlternatives
                      .map((alt) => alt.finalSumValue)
                      .toList(),
                ),
              ];
            },
          ),
        );

        // Save the PDF to a file
        final output = await getApplicationDocumentsDirectory();
        final file = File('${output.path}/example.pdf');
        await file.writeAsBytes(await pdf.save());

        await Share.shareXFiles([XFile(file.path)], text: 'Export PDF sukses');
      }

      return Scaffold(
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              provider.calculateSAW(provider);
              provider.saveNormalizedMatrix();
              provider.saveCalculatedWeightedSums();
              provider.saveSortedAlternatives();
              // Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) =>
              //                 FinalPage()));
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Hitung Hasil SAW',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          title: Text(
            'Hasil Akhir',
            style: CustomStyles.appBarTextStyle(),
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  generatePdf();
                  // Future<void> saveFile(document, String name)
                  //async {
                  //   final Directory dir =
                  //       await getApplicationDocumentsDirectory();
                  //   final File file = File('${dir.path}/$name.pdf');

                  //   await file.writeAsBytes(await document.save());
                  //   debugPrint('Saved exported PDF at: ${file.path}');

                  //   Fluttertoast.showToast(
                  //     msg: 'Hasil Akhir telah tersimpan dalam bentuk PDF!',
                  //     toastLength: Toast.LENGTH_SHORT,
                  //     gravity: ToastGravity.BOTTOM,
                  //     timeInSecForIosWeb: 1,
                  //     fontSize: 16.0,
                  //   );

                  //   await Share.shareXFiles([XFile(file.path)],
                  //       text: 'Export PDF sukses');
                  // }

                  // final pdf =
                  //     await exportDelegate.exportToPdfDocument('result');
                  // saveFile(pdf, 'hasil-hitung-spk');
                },
                icon: Icon(Icons.print_rounded)),
          ],
          centerTitle: true,
        ),
        body: areListsEmpty
            ? const Center(
                child: Text(
                  'Data belum lengkap!',
                  style: TextStyle(),
                ),
              )
            : ExportFrame(
                frameId: 'result',
                exportDelegate: exportDelegate,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: Text(
                            'Sistem Pendukung Keputusan ${provider.judulSubjek} Menggunakan Metode Simple Additive Weighting (SAW)',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: Text(
                          'Matriks Keputusan',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ),
                      // Table to display matrix values for every alternative
                      buildTable(
                        headers: List.generate(provider.criteriaList.length,
                            (index) => 'C${index + 1}').toList(),
                        rowNames: provider.alternatifList
                            .map((alt) => alt.name)
                            .toList(),
                        rowData: List.generate(
                          provider.matrixValues.length,
                          (altIndex) => List.generate(
                            provider.matrixValues[altIndex].length,
                            (critIndex) => provider.matrixValues[altIndex]
                                    [critIndex]
                                .toString(),
                          ),
                        ),
                      ),
                      // buildTable(
                      //   data: provider.matrixValues,
                      //   headers: provider.criteriaList
                      //       .map((criteria) => criteria.criteria)
                      //       .toList(),
                      //   rowNames: provider.alternatifList
                      //       .map((alt) => alt.name)
                      //       .toList(),
                      //   headerColor: Colors.brown[300]!,
                      //   rowNamePrefix: 'A',
                      // ),
                      const SizedBox(height: 0),
                      provider.hasCalculated
                          ? Column(
                              children: [
                                const Divider(),
                                const SizedBox(height: 10),
                                Center(
                                  child: Text(
                                    'Matriks Ternormalisasi (R)',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                buildTable(
                                  headers: List.generate(
                                      provider.criteriaList.length,
                                      (index) => 'C${index + 1}').toList(),
                                  rowNames: provider.alternatifList
                                      .map((alt) => alt.name)
                                      .toList(),
                                  rowData: List.generate(
                                    provider.normalizedMatrix[0].length,
                                    (critIndex) => List.generate(
                                      provider.normalizedMatrix.length,
                                      (altIndex) => provider
                                          .normalizedMatrix[altIndex][critIndex]
                                          .toStringAsFixed(2),
                                    ),
                                  ),
                                ),
                                // Calculated Weight Table
                                Center(
                                  child: Text(
                                    'Matriks Nilai Preferensi (P)',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),

                                buildTable(
                                  headers: ['Hasil'],
                                  rowNames: provider.alternatifList
                                      .map((alt) => alt.name)
                                      .toList(),
                                  rowData: provider.calculatedWeightSums
                                      .map((sum) => [sum.toStringAsFixed(2)])
                                      .toList(),
                                ),
                                Center(
                                  child: Text(
                                    'Hasil Pengurutan',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                // Rank Table
                                buildSortedTable(
                                  headers: ['Alternatives', 'Nilai Akhir'],
                                  rowNames: provider.sortedAlternatives
                                      .map((alt) => alt.name)
                                      .toList(),
                                  rowData: provider.sortedAlternatives
                                      .map((alt) => alt.finalSumValue)
                                      .toList(),
                                ),
                              ],
                            )
                          : const SizedBox()
                    ],
                  ),
                ),
              ),
      );
    });
  }

  Widget buildTable({
    required List<String> headers,
    required List<String> rowNames,
    required List<List<String>> rowData,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Table(
        border: TableBorder.all(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(8),
        ),
        columnWidths: {
          0: const FixedColumnWidth(150),
          ...{
            for (int index = 0; index < headers.length; index++)
              index + 1: FixedColumnWidth(100),
          },
        },
        children: [
          // Header row
          TableRow(
            children: [
              TableCell(
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  color: Colors.brown[300],
                  alignment: Alignment.center,
                  child: Text(
                    'Alternatives',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // Header cells
              ...headers.map((header) => TableCell(
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      color: Colors.brown[300],
                      alignment: Alignment.center,
                      child: Text(
                        header,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )),
            ],
          ),
          // Data rows
          ...List.generate(
            rowNames.length,
            (rowIndex) {
              return TableRow(
                children: [
                  // Cell for row name
                  TableCell(
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      alignment: Alignment.center,
                      child: Text(rowNames[rowIndex]),
                    ),
                  ),
                  // Cells for row data
                  ...rowData[rowIndex].map((cellData) => TableCell(
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: rowIndex % 2 == 0
                                ? Colors.grey.shade200
                                : Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          alignment: Alignment.center,
                          child: Text(cellData),
                        ),
                      )),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildSortedTable({
    required List<String> headers,
    required List<String> rowNames,
    required List<double> rowData,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Table(
        border: TableBorder.all(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(8),
        ),
        columnWidths: {
          0: const FixedColumnWidth(50), // Width for the "No" column
          1: const FixedColumnWidth(150), // Width for the "Alternatives" column
          2: const FixedColumnWidth(100), // Width for the "Nilai Akhir" column
        },
        children: [
          // Header row
          TableRow(
            children: [
              TableCell(
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  color: Colors.brown[300],
                  alignment: Alignment.center,
                  child: Text(
                    'No',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // Header cells
              ...headers.map((header) => TableCell(
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      color: Colors.brown[300],
                      alignment: Alignment.center,
                      child: Text(
                        header,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )),
            ],
          ),
          // Data rows
          ...List.generate(
            rowNames.length,
            (index) {
              return TableRow(
                children: [
                  // Cell for row number
                  TableCell(
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: index % 2 == 0
                            ? Colors.grey.shade200
                            : Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      alignment: Alignment.center,
                      child: Text((index + 1).toString()),
                    ),
                  ),
                  // Cell for row name
                  TableCell(
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: index % 2 == 0
                            ? Colors.grey.shade200
                            : Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      alignment: Alignment.center,
                      child: Text('A${index + 1} ${rowNames[index]}'),
                    ),
                  ),
                  // Cell for row data
                  TableCell(
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: index % 2 == 0
                            ? Colors.grey.shade200
                            : Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      alignment: Alignment.center,
                      child: Text(rowData[index].toStringAsFixed(2)),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
