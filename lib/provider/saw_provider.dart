import 'package:flutter/material.dart';
import 'package:spk_saw/model/model.dart';
import 'package:decimal/decimal.dart';
import 'dart:math' as math;

class SawProvider extends ChangeNotifier {
  List<Criteria> _criteriaList = [];

  List<Alternative> _alternatifList = [];

  List<List<double>> _matrixValues = [];

  List<List<double>> _normalizedMatrix = [];
  List<Decimal> _calculatedWeightedSums = [];
  List<Alternative> _sortedAlternatives = [];
  bool _hasCalculated = false;

  List<Criteria> get criteriaList => _criteriaList;
  List<Alternative> get alternatifList => _alternatifList;
  List<List<double>> get matrixValues => _matrixValues;
  List<List<double>> get normalizedMatrix => _normalizedMatrix;
  List<Decimal> get calculatedWeightSums => _calculatedWeightedSums;
  List<Alternative> get sortedAlternatives => _sortedAlternatives;
  bool get hasCalculated => _hasCalculated;

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
}
