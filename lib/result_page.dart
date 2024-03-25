import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:spk_saw/custom_styles.dart';
import 'package:spk_saw/provider/saw_provider.dart';

class ResultPage extends StatefulWidget {
  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hasil',
          style: CustomStyles.appBarTextStyle(),
        ),
        centerTitle: true,
      ),
      body: Consumer<SawProvider>(
        builder: (context, provider, _) {
          debugPrint(provider.calculatedWeights.toString());
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Tabel Alternatif',
                    style: GoogleFonts.inter(
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
                                  style: TextStyle(fontWeight: FontWeight.bold),
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
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
                                      borderRadius: BorderRadius.circular(8.0),
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
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      provider.calculateSAW(provider);
                    },
                    child: Text(
                      'Hitung Hasil SAW',
                      style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                provider.hasCalculated
                    ? Column(
                        children: [
                          Center(
                            child: Text(
                              'Tabel Normalisasi',
                              style: GoogleFonts.inter(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Table(
                                border: TableBorder.all(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.circular(8)),
                                columnWidths: {
                                  0: FixedColumnWidth(
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
                                    provider.normalizedMatrix.length,
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
                                                'A${altIndex + 1}',
                                              ),
                                            ),
                                          ),
                                          ...List.generate(
                                            provider.normalizedMatrix[altIndex]
                                                .length,
                                            (critIndex) => TableCell(
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
                                                  provider.normalizedMatrix[
                                                          altIndex][critIndex]
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
                              ),
                            ),
                          ),
                          // Calculated Weight Table
                          Table(
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
                                          'Weight for C${index + 1}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              ...List.generate(
                                provider.normalizedMatrix.length,
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
                                            'A${altIndex + 1}',
                                          ),
                                        ),
                                      ),
                                      ...List.generate(
                                        provider
                                            .normalizedMatrix[altIndex].length,
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
                                              provider
                                                  .calculatedWeights[altIndex]
                                                      [critIndex]
                                                  .toStringAsFixed(
                                                      2), // Use altIndex and critIndex to access the weight
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

// Rank Table
                          Table(
                            border: TableBorder.all(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(8)),
                            columnWidths: {
                              0: const FixedColumnWidth(
                                  150), // Adjust width of the first column as needed
                              1: const FixedColumnWidth(
                                  100), // Adjust width of the second column as needed
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
                                  TableCell(
                                    child: Container(
                                      padding: EdgeInsets.all(8.0),
                                      color: Colors.brown[300],
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Rank',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              ...List.generate(
                                provider.alternatifList.length,
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
                                            provider.rankings[altIndex]
                                                .toString(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      )
                    : const SizedBox()
              ],
            ),
          );
        },
      ),
    );
  }
}
