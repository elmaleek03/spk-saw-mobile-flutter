import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_to_pdf/flutter_to_pdf.dart';
import 'package:provider/provider.dart';
import 'package:spk_saw/provider/saw_provider.dart';
import 'package:flutter_to_pdf/flutter_to_pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';


class FinalPage extends StatelessWidget {
  const FinalPage({super.key});

  @override
  Widget build(BuildContext context) {
       final ExportOptions options = ExportOptions(
  pageFormatOptions: PageFormatOptions.a4(),
);
    var exportDelegate = ExportDelegate(options: options);
    return Scaffold(
      appBar: AppBar(
        actions: [
            IconButton(onPressed: () async{
         
  Future<void> saveFile(document, String name) async {
    
  final Directory dir = await getApplicationDocumentsDirectory();
  final File file = File('${dir.path}/$name.pdf');

  await file.writeAsBytes(await document.save());
  debugPrint('Saved exported PDF at: ${file.path}');

  Fluttertoast.showToast(
    msg: 'PDF saved in the application documents directory!',
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    fontSize: 16.0,
  );

  await Share.shareXFiles([XFile(file.path)], text: 'Export PDF sukses');
}

              final pdf = await exportDelegate.exportToPdfDocument('result');
                  saveFile(pdf, 'hasil-hitung-spk');
            }, icon: Icon(Icons.print_rounded)),
          ],
      ),
      body: Consumer<SawProvider>(builder: (context, provider, _) {
          return ExportFrame(
                  frameId: 'result',
              exportDelegate: exportDelegate,
                  child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              'Matriks Keputusan',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                          ),
                          // Table to display matrix values for every alternative
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Table(
                                border: TableBorder.all(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.circular(8)),
                                columnWidths: {
                                  0: const FixedColumnWidth(
                                      150), // Adjust width of the first column as needed
                                  ...{
                                    for (int index = 0;
                                        index < provider.criteriaList.length;
                                        index++)
                                      index + 1: FixedColumnWidth(
                                          100), // Adjust width of other columns as needed
                                  },
                                },
                                children: [
                                  TableRow(
                                    children: [
                                      TableCell(
                                        child: Container(
                                          padding: EdgeInsets.all(8.0),
                                          color: Colors.brown[300],
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Alternatif',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      ...List.generate(
                                        provider.criteriaList.length,
                                        (index) => TableCell(
                                          child: Container(
                                            padding: EdgeInsets.all(8.0),
                                            color: Colors.brown[300],
                                            alignment: Alignment.center,
                                            child: Text(
                                              'C${index + 1}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  ...List.generate(
                                    provider.matrixValues.length,
                                    (altIndex) {
                                      return TableRow(
                                        children: [
                                          TableCell(
                                            child: Container(
                                              padding: EdgeInsets.all(8.0),
                                              decoration: BoxDecoration(
                                                color: altIndex % 2 == 0
                                                    ? Colors.grey.shade200
                                                    : Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              alignment: Alignment.center,
                                              child: Text(
                                                'A${altIndex + 1} ${provider.alternatifList[altIndex].name}',
                                              ),
                                            ),
                                          ),
                                          ...List.generate(
                                            provider.matrixValues[altIndex].length,
                                            (critIndex) => TableCell(
                                              child: Container(
                                                padding: EdgeInsets.all(8.0),
                                                decoration: BoxDecoration(
                                                  color: altIndex % 2 == 0
                                                      ? Colors.grey.shade200
                                                      : Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(8.0),
                                                ),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  provider.matrixValues[altIndex]
                                                          [critIndex]
                                                      .toString(),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  provider.calculateSAW(provider);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Hitung Hasil SAW',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 0),
                        Column(
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
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Table(
                                            border: TableBorder.all(
                                              color: Colors.black12,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            columnWidths: {
                                              0: const FixedColumnWidth(
                                                  150), // Adjust width of the first column as needed
                                              ...{
                                                for (int index = 0;
                                                    index <
                                                        provider.criteriaList.length;
                                                    index++)
                                                  index + 1: FixedColumnWidth(
                                                      100), // Adjust width of other columns as needed
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
                                                            fontWeight:
                                                                FontWeight.bold),
                                                      ),
                                                    ),
                                                  ),
                                                  // Generate header cells for criteria
                                                  ...List.generate(
                                                    provider.criteriaList.length,
                                                    (index) => TableCell(
                                                      child: Container(
                                                        padding: EdgeInsets.all(8.0),
                                                        color: Colors.brown[300],
                                                        alignment: Alignment.center,
                                                        child: Text(
                                                          'C${index + 1}',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight.bold),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              // Data columns
                                              ...List.generate(
                                                provider.normalizedMatrix[0].length,
                                                (critIndex) {
                                                  return TableRow(
                                                    children: [
                                                      // Generate cell for alternative name
                                                      TableCell(
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.all(8.0),
                                                          decoration: BoxDecoration(
                                                            color:
                                                                Colors.grey.shade200,
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    8.0),
                                                          ),
                                                          alignment: Alignment.center,
                                                          child: Text(
                                                            provider
                                                                .alternatifList[
                                                                    critIndex]
                                                                .name,
                                                          ),
                                                        ),
                                                      ),
                                                      // Generate cells for normalized values for the current alternative
                                                      ...List.generate(
                                                        provider
                                                            .normalizedMatrix.length,
                                                        (altIndex) => TableCell(
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.all(8.0),
                                                            decoration: BoxDecoration(
                                                              color: altIndex % 2 == 0
                                                                  ? Colors
                                                                      .grey.shade200
                                                                  : Colors.white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(8.0),
                                                            ),
                                                            alignment:
                                                                Alignment.center,
                                                            child: Text(
                                                              provider
                                                                  .normalizedMatrix[
                                                                      altIndex]
                                                                      [critIndex]
                                                                  .toStringAsFixed(2),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              ),
                                            ],
                                          )),
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
                          
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Table(
                                        border: TableBorder.all(
                                          color: Colors.black12,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        columnWidths: {
                                          0: const FixedColumnWidth(
                                              150), // Adjust width of the first column as needed
                                          ...{
                                            for (int index = 0;
                                                index < provider.criteriaList.length;
                                                index++)
                                              index + 1: FixedColumnWidth(
                                                  100), // Adjust width of other columns as needed
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
                                              // Header cell for weighted sums
                                              TableCell(
                                                child: Container(
                                                  padding: EdgeInsets.all(8.0),
                                                  color: Colors.brown[300],
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    'Hasil',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          // Data rows
                                          ...List.generate(
                                            provider.alternatifList.length,
                                            (altIndex) {
                                              return TableRow(
                                                children: [
                                                  // Generate cell for alternative name
                                                  TableCell(
                                                    child: Container(
                                                      padding: EdgeInsets.all(8.0),
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey.shade200,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                8.0),
                                                      ),
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        provider
                                                            .alternatifList[altIndex]
                                                            .name,
                                                      ),
                                                    ),
                                                  ),
                                                  // Generate cell for weighted sum for the current alternative
                                                  TableCell(
                                                    child: Container(
                                                      padding: EdgeInsets.all(8.0),
                                                      decoration: BoxDecoration(
                                                        color: altIndex % 2 == 0
                                                            ? Colors.grey.shade200
                                                            : Colors.white,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                8.0),
                                                      ),
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        altIndex <
                                                                provider
                                                                    .calculatedWeightSums
                                                                    .length
                                                            ? provider
                                                                .calculatedWeightSums[
                                                                    altIndex]
                                                                .toStringAsFixed(2)
                                                            : '', // Check if altIndex is within the range of calculatedWeightSums
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ],
                                      ),
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
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Table(
                                        border: TableBorder.all(
                                          color: Colors.black12,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        columnWidths: {
                                          0: const FixedColumnWidth(
                                              50), // Width for the "No" column
                                          1: const FixedColumnWidth(
                                              150), // Width for the "Alternatives" column
                                          2: const FixedColumnWidth(
                                              100), // Width for the "Nilai Akhir" column
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
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              TableCell(
                                                child: Container(
                                                  padding: EdgeInsets.all(8.0),
                                                  color: Colors.brown[300],
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    'Alternatives',
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              TableCell(
                                                child: Container(
                                                  padding: EdgeInsets.all(8.0),
                                                  color: Colors.brown[300],
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    'Nilai Akhir',
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          // Data rows
                                          ...List.generate(
                                            provider.sortedAlternatives.length,
                                            (index) {
                                              return TableRow(
                                                children: [
                                                  TableCell(
                                                    child: Container(
                                                      padding: EdgeInsets.all(8.0),
                                                      decoration: BoxDecoration(
                                                        color: index % 2 == 0
                                                            ? Colors.grey.shade200
                                                            : Colors.white,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                8.0),
                                                      ),
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        (index + 1)
                                                            .toString(), // Display the index as the "No"
                                                      ),
                                                    ),
                                                  ),
                                                  TableCell(
                                                    child: Container(
                                                      padding: EdgeInsets.all(8.0),
                                                      decoration: BoxDecoration(
                                                        color: index % 2 == 0
                                                            ? Colors.grey.shade200
                                                            : Colors.white,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                8.0),
                                                      ),
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        'A${index + 1} ${provider.sortedAlternatives[index].name}', // Display the alternative name
                                                      ),
                                                    ),
                                                  ),
                                                  TableCell(
                                                    child: Container(
                                                      padding: EdgeInsets.all(8.0),
                                                      decoration: BoxDecoration(
                                                        color: index % 2 == 0
                                                            ? Colors.grey.shade200
                                                            : Colors.white,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                8.0),
                                                      ),
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        provider
                                                            .sortedAlternatives[index]
                                                            .finalSumValue
                                                            .toStringAsFixed(
                                                                2), // Display the final sum value
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                        ],
                      ),
                    ),
                );
        }
      ),
    );
  }
}