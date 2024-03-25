import 'package:flutter/material.dart';
import 'package:spk_saw/model/model.dart';

class SawProvider extends ChangeNotifier {
  List<Criteria> _criteriaList = [];
  List<String> _alternatifList = [];
  List<List<double>> _matrixValues = [];

  List<Criteria> get criteriaList => _criteriaList;
  List<String> get alternatifList => _alternatifList;
  List<List<double>> get matrixValues => _matrixValues;

  void addCriteria(Criteria criteria) {
    _criteriaList.add(criteria);
    notifyListeners();
  }

  void addAlternatif(String alternatif) {
    _alternatifList.add(alternatif);
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

  void calculateSAW(SawProvider provider) {
    // Normalize the matrix values
    List<List<double>> normalizedMatrix =
        _normalizeMatrix(provider.matrixValues);

    // Calculate the weighted sum for each alternative
    List<double> weightedSums =
        _calculateWeightedSums(normalizedMatrix, provider.criteriaList);

    // Rank the alternatives
    List<int> rankings = _rankAlternatives(weightedSums);

    // Update provider with rankings
    provider.updateRankings(rankings);
  }

// Normalize the matrix values
  List<List<double>> _normalizeMatrix(List<List<double>> matrix) {
    List<List<double>> normalizedMatrix = [];
    for (int col = 0; col < matrix[0].length; col++) {
      double sum = 0;
      for (int row = 0; row < matrix.length; row++) {
        sum += matrix[row][col];
      }
      List<double> normalizedColumn = [];
      for (int row = 0; row < matrix.length; row++) {
        normalizedColumn.add(matrix[row][col] / sum);
      }
      normalizedMatrix.add(normalizedColumn);
    }
    return normalizedMatrix;
  }

// Calculate the weighted sum for each alternative
  List<double> _calculateWeightedSums(
      List<List<double>> normalizedMatrix, List<Criteria> criteriaList) {
    List<double> weightedSums = List.filled(normalizedMatrix.length, 0.0);
    for (int altIndex = 0; altIndex < normalizedMatrix.length; altIndex++) {
      for (int critIndex = 0;
          critIndex < normalizedMatrix[0].length;
          critIndex++) {
        weightedSums[altIndex] += normalizedMatrix[altIndex][critIndex] *
            criteriaList[critIndex].weightValue;
      }
    }
    return weightedSums;
  }

// Rank the alternatives
  List<int> _rankAlternatives(List<double> weightedSums) {
    List<int> rankings =
        List.generate(weightedSums.length, (index) => index + 1);
    rankings.sort((a, b) => weightedSums[b - 1].compareTo(weightedSums[a - 1]));
    return rankings;
  }

  // void updateRankings(List<int> rankings) {
  //   // Update the rankings in your provider class
  //   // For example, you might have a list of alternatives with their rankings
  //   // You can update this list with the provided rankings
  //   // This is just a placeholder implementation, you need to adapt it to your specific use case
  //   for (int i = 0; i < alternatifList.length; i++) {
  //     alternatifList[i].ranking = rankings[i];
  //   }

  //   // Notify listeners that the rankings have been updated
  //   notifyListeners();
  // }
}
