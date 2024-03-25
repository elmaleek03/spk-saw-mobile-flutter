import 'package:spk_saw/input_alternatif_page.dart';
import 'package:spk_saw/input_criteria_page.dart';
import 'package:spk_saw/input_matrix_page.dart';
import 'package:spk_saw/model/model.dart';

List<MainMenu> mainMenuList = [
  MainMenu(
    title: '1. Input Kriteria',
    desc:
        'Langkah pertama ialah menginput kriteria dari lorem ipsum color si jamet',
    subDesc: 'Input kriteria terlebih dahulu!',
    offTitle: 'Input data >',
    onTitle: 'Lihat data >',
    pageNavigator: const InputCriteriaPage(),
  ),
  MainMenu(
    title: '2. Input Alternatif',
    desc:
        'Langkah selanjutnya ialah menginput alternatif dari lorem ipsum color si jamet',
    subDesc: 'Input alternatif terlebih dahulu!',
    offTitle: 'Input data >',
    onTitle: 'Lihat data >',
    pageNavigator: const InputAlternatifPage(),
  ),
  MainMenu(
    title: '3. Input Matrix',
    desc:
        'Langkah selanjutnya ialah menginput matrix dari lorem ipsum color si jamet',
    subDesc: 'Input matriks terlebih dahulu!',
    offTitle: 'Input data >',
    onTitle: 'Lihat data >',
    pageNavigator: const InputMatrixPage(),
  ),
  // Add more MainMenu objects here...
];
