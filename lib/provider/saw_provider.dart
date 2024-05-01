import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spk_saw/model/model.dart';
import 'package:decimal/decimal.dart';
import 'dart:math' as math;

class SawProvider extends ChangeNotifier {
  String _judulSubjek = '';

  List<Criteria> _criteriaList = [];

  List<Alternative> _alternatifList = [];

  List<List<double>> _matrixValues = [];

  List<List<double>> _normalizedMatrix = [];
  List<Decimal> _calculatedWeightedSums = [];
  List<Alternative> _sortedAlternatives = [];
  bool _hasCalculated = false;

  String get judulSubjek => _judulSubjek;
  List<Criteria> get criteriaList => _criteriaList;
  List<Alternative> get alternatifList => _alternatifList;
  List<List<double>> get matrixValues => _matrixValues;
  List<List<double>> get normalizedMatrix => _normalizedMatrix;
  List<Decimal> get calculatedWeightSums => _calculatedWeightedSums;
  List<Alternative> get sortedAlternatives => _sortedAlternatives;
  bool get hasCalculated => _hasCalculated;

  Future<void> loadData() async {
    _judulSubjek = await loadJudulSubjek();
    _criteriaList = await loadCriteria();
    _alternatifList = await loadAlternatives();
    _matrixValues = await loadMatrixValues();
    _normalizedMatrix = await loadNormalizedMatrix();
    _calculatedWeightedSums = await loadCalculatedWeightedSums();
    _sortedAlternatives = await loadSortedAlternatives();
    notifyListeners();
  }

  void addJudulSubjek(String judul) {
    _judulSubjek = judul;
    notifyListeners();
  }

  void addCriteria(Criteria criteria) {
    _criteriaList.add(criteria);
    notifyListeners();
  }

  void addAlternatif(String alternatif) {
    _alternatifList.add(Alternative(alternatif, 0));
    notifyListeners();
  }

  void addMatrixValues(List<double> values) {
    _matrixValues.add(values);
    notifyListeners();
  }

  void fillMatrixValues(List<List<double>> values) {
    _matrixValues = values;
    notifyListeners();
  }

  void removeCriteriaAt(int index) {
    _criteriaList.removeAt(index);
    notifyListeners();
  }

  void removeAlternatifAt(int index) {
    _alternatifList.removeAt(index);
    notifyListeners();
  }

  void clearMatrixValuesAt(int index) {
    if (index >= 0 && index < _matrixValues.length) {
      _matrixValues[index] = [0.0, 0.0];
      notifyListeners();
    }
  }

  void setHasCalculated(bool value) {
    _hasCalculated = value;
    notifyListeners();
  }

  void calculateSAW(SawProvider provider) {
    // Normalize the matrix values
    _normalizedMatrix =
        _normalizeMatrix(provider.matrixValues, provider.criteriaList);

    // Calculate the weighted sum for each alternative
    _calculatedWeightedSums =
        _calculateWeightedSums((_normalizedMatrix), provider.criteriaList);

    // Rank the alternatives
    _sortedAlternatives = _rankAlternatives();

    // Update provider with rankings
    // provider.updateRankings(_rankings);
    _hasCalculated = true;
    notifyListeners();
  }

  List<List<double>> _normalizeMatrix(
    List<List<double>> matrix,
    List<Criteria> criteriaList,
  ) {
    List<List<double>> normalizedMatrix = [];

    for (int row = 0; row < matrix.length; row++) {
      List<double> rowValues = [];

      for (int col = 0; col < matrix[row].length; col++) {
        double value = matrix[row][col];
        double normalizedValue;

        if (criteriaList[col].attribute == "Cost") {
          // Cost criteria: Rij = ( min{Xij} / Xij )
          double minValue = matrix.map((e) => e[col]).reduce(math.min);
          normalizedValue = minValue / value;
        } else {
          // Benefit criteria: Rij = ( Xij / max{Xij} )
          double maxValue = matrix.map((e) => e[col]).reduce(math.max);
          normalizedValue = value / maxValue;
        }

        rowValues.add(normalizedValue);
      }

      normalizedMatrix.add(rowValues);
    }
    debugPrint('Normalized Matrix: ${transpose(normalizedMatrix)}');
    return transpose(normalizedMatrix);
  }

  // Function to transpose a matrix
  List<List<T>> transpose<T>(List<List<T>> matrix) {
    return List.generate(
      matrix[0].length,
      (col) => List.generate(
        matrix.length,
        (row) => matrix[row][col],
      ),
    );
  }

  // Calculate the weighted sum for each alternative
  List<Decimal> _calculateWeightedSums(
    List<List<double>> normalizedMatrix,
    List<Criteria> criteriaList,
  ) {
    List<Decimal> weightedSums = [];

    // Multiply each value in the normalized matrix by the corresponding weight value
    debugPrint('Normalized Matrix: $normalizedMatrix');
    debugPrint('Length of Normalized Matrix: ${normalizedMatrix.length}');
    debugPrint('Length of Criteria List: ${criteriaList.length}');

    List<List<double>> weightedMatrix = List.generate(
      criteriaList.length, // Number of criteria
      (critIndex) => List.generate(
        normalizedMatrix[0].length, // Number of alternatives
        (altIndex) =>
            normalizedMatrix[critIndex][altIndex] *
            criteriaList[critIndex].weightValue,
      ),
    );

    // Transpose the matrix
    List<List<double>> transposedWeightedMatrix = transpose(weightedMatrix);

    // Sum the values in each list to get the weighted sum for each alternative
    for (int altIndex = 0;
        altIndex < transposedWeightedMatrix.length;
        altIndex++) {
      Decimal sum = Decimal.zero;
      for (int critIndex = 0;
          critIndex < transposedWeightedMatrix[altIndex].length;
          critIndex++) {
        sum += Decimal.parse(
            transposedWeightedMatrix[altIndex][critIndex].toString());
      }
      weightedSums.add(sum);
      alternatifList[altIndex].finalSumValue = sum.toDouble();
    }
    debugPrint('Weighted Sums: $weightedSums');
    return weightedSums;
  }

  List<Alternative> _rankAlternatives() {
    // Create a copy of the original list to avoid modifying it directly
    List<Alternative> sortedAlternatifList = List.from(alternatifList);

    // Sort alternatives based on their finalSumValue
    sortedAlternatifList
        .sort((a, b) => b.finalSumValue.compareTo(a.finalSumValue));

    // _sortedAlternatives = sortedAlternatifList;
    // notifyListeners();
    return sortedAlternatifList;
  }

  Future<void> saveCriteria(List<Criteria> criteriaList) async {
    final prefs = await SharedPreferences.getInstance();
    final criteriaListString =
        jsonEncode(criteriaList.map((c) => c.toJson()).toList());
    await prefs.setString('criteriaList', criteriaListString);
  }

  Future<List<Criteria>> loadCriteria() async {
    final prefs = await SharedPreferences.getInstance();
    final criteriaListString = prefs.getString('criteriaList');
    if (criteriaListString != null) {
      final criteriaList = (jsonDecode(criteriaListString) as List)
          .map((item) => Criteria.fromJson(item))
          .toList();
      return criteriaList;
    } else {
      return [];
    }
  }

  Future<void> saveAlternatives(List<Alternative> alternativeList) async {
    final prefs = await SharedPreferences.getInstance();
    final alternativeListString =
        jsonEncode(alternativeList.map((a) => a.toJson()).toList());
    await prefs.setString('alternativeList', alternativeListString);
  }

  Future<List<Alternative>> loadAlternatives() async {
    final prefs = await SharedPreferences.getInstance();
    final alternativeListString = prefs.getString('alternativeList');
    if (alternativeListString != null) {
      final alternativeList = (jsonDecode(alternativeListString) as List)
          .map((item) => Alternative.fromJson(item))
          .toList();
      return alternativeList;
    } else {
      return [];
    }
  }

  Future<void> saveMatrixValues() async {
    final prefs = await SharedPreferences.getInstance();
    final matrixValuesString = jsonEncode(matrixValues);
    await prefs.setString('matrixValues', matrixValuesString);
  }

  Future<List<List<double>>> loadMatrixValues() async {
    final prefs = await SharedPreferences.getInstance();
    final matrixValuesString = prefs.getString('matrixValues');
    if (matrixValuesString != null) {
      final matrixValues = (jsonDecode(matrixValuesString) as List)
          .map((item) =>
              (item as List<dynamic>).map((i) => i as double).toList())
          .toList();
      return matrixValues;
    } else {
      return [];
    }
  }

// Save methods
  Future<void> saveNormalizedMatrix() async {
    final prefs = await SharedPreferences.getInstance();
    final normalizedMatrixString = jsonEncode(_normalizedMatrix);
    await prefs.setString('normalizedMatrix', normalizedMatrixString);
  }

  Future<void> saveCalculatedWeightedSums() async {
    final prefs = await SharedPreferences.getInstance();
    final calculatedWeightedSumsString = jsonEncode(
        _calculatedWeightedSums.map((item) => item.toString()).toList());
    await prefs.setString(
        'calculatedWeightedSums', calculatedWeightedSumsString);
  }

  Future<void> saveSortedAlternatives() async {
    final prefs = await SharedPreferences.getInstance();
    final sortedAlternativesString =
        jsonEncode(_sortedAlternatives.map((a) => a.toJson()).toList());
    await prefs.setString('sortedAlternatives', sortedAlternativesString);
  }

// Load methods
  Future<List<List<double>>> loadNormalizedMatrix() async {
    final prefs = await SharedPreferences.getInstance();
    final normalizedMatrixString = prefs.getString('normalizedMatrix');
    if (normalizedMatrixString != null) {
      final normalizedMatrix = (jsonDecode(normalizedMatrixString) as List)
          .map((item) =>
              (item as List<dynamic>).map((i) => i as double).toList())
          .toList();
      return normalizedMatrix;
    } else {
      return [];
    }
  }

  Future<List<Decimal>> loadCalculatedWeightedSums() async {
    final prefs = await SharedPreferences.getInstance();
    final calculatedWeightedSumsString =
        prefs.getString('calculatedWeightedSums');
    if (calculatedWeightedSumsString != null) {
      final calculatedWeightedSums =
          (jsonDecode(calculatedWeightedSumsString) as List)
              .map((item) => Decimal.parse(item as String))
              .toList();
      return calculatedWeightedSums;
    } else {
      return [];
    }
  }

  Future<List<Alternative>> loadSortedAlternatives() async {
    final prefs = await SharedPreferences.getInstance();
    final sortedAlternativesString = prefs.getString('sortedAlternatives');
    if (sortedAlternativesString != null) {
      final sortedAlternatives = (jsonDecode(sortedAlternativesString) as List)
          .map((item) => Alternative.fromJson(item))
          .toList();
      return sortedAlternatives;
    } else {
      return [];
    }
  }

  // Save method
  Future<void> saveJudulSubjek() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('judulSubjek', judulSubjek);
  }

  // Load method
  Future<String> loadJudulSubjek() async {
    final prefs = await SharedPreferences.getInstance();
    final loadedJudulSubjek = prefs.getString('judulSubjek');
    return loadedJudulSubjek ?? '';
  }

  Future<void> resetAllData() async {
    // Clear all data in the provider
    _judulSubjek = '';
    _criteriaList = [];
    _alternatifList = [];
    _matrixValues = [];
    _normalizedMatrix = [];
    _calculatedWeightedSums = [];
    _sortedAlternatives = [];
    _hasCalculated = false;
    notifyListeners();

    // Clear all data in SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
