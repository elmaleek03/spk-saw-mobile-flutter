import 'package:spk_saw/input_alternatif_page.dart';
import 'package:spk_saw/input_criteria_page.dart';
import 'package:spk_saw/input_matrix_page.dart';
import 'package:spk_saw/model/model.dart';
import 'package:spk_saw/result_page.dart';

List<MainMenu> mainMenuList = [
  MainMenu(
    title: '1. Input Kriteria',
    desc: 'Langkah pertama ialah menginput kriteria',
    subDesc: 'Input kriteria terlebih dahulu!',
    offTitle: 'Input data >',
    onTitle: 'Lihat data >',
    pageNavigator: const InputCriteriaPage(),
  ),
  MainMenu(
    title: '2. Input Alternatif',
    desc: 'Langkah selanjutnya ialah menginput alternatif',
    subDesc: 'Input alternatif terlebih dahulu!',
    offTitle: 'Input data >',
    onTitle: 'Lihat data >',
    pageNavigator: const InputAlternatifPage(),
  ),
  MainMenu(
    title: '3. Input Matrix',
    desc:
        'Langkah selanjutnya ialah menginput matrix keputusan untuk setiap alternatif',
    subDesc: 'Input matriks terlebih dahulu!',
    offTitle: 'Input data >',
    onTitle: 'Lihat data >',
    pageNavigator: const InputMatrixPage(),
  ),
  MainMenu(
    title: '4. Normalisasi dan Hasil Akhir',
    desc:
        'Langkah selanjutnya ialah mengkalkulasikan matrix keputusan dan menghitung nilai akhir menggunakan metode SAW',
    subDesc: 'Input seluruh data terlebih dahulu!',
    offTitle: 'Kalkulasi data >',
    onTitle: 'Kalkulasi data >',
    pageNavigator: ResultPage(),
  ),
  // Add more MainMenu objects here...
];
