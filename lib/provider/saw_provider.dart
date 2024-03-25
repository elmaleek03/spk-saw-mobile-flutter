import 'package:flutter/material.dart';
import 'package:spk_saw/model/model.dart';
import 'package:decimal/decimal.dart';

class SawProvider extends ChangeNotifier {
  List<Criteria> _criteriaList = [];
  List<Alternative> _alternatifList = [];
  List<List<double>> _matrixValues = [];
  List<List<double>> _normalizedMatrix = [];
  List<List<Decimal>> _calculatedWeights = [];
  List<int> _rankings = [];
  bool _hasCalculated = false;

  List<Criteria> get criteriaList => _criteriaList;
  List<Alternative> get alternatifList => _alternatifList;
  List<List<double>> get matrixValues => _matrixValues;
  List<List<double>> get normalizedMatrix => _normalizedMatrix;
  List<List<Decimal>> get calculatedWeights => _calculatedWeights;
  List<int> get rankings => _rankings;
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
    _normalizedMatrix = _normalizeMatrix(provider.matrixValues);

    // Calculate the weighted sum for each alternative
    _calculatedWeights =
        _calculateWeightedSums(_normalizedMatrix, provider.criteriaList);

    // Rank the alternatives
    _rankings = _rankAlternatives(_calculatedWeights);

    // Update provider with rankings
    provider.updateRankings(_rankings);
    _hasCalculated = true;
    notifyListeners();
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
        double normalizedValue =
            double.parse((matrix[row][col] / sum).toStringAsFixed(2));
        normalizedColumn.add(normalizedValue);
      }
      normalizedMatrix.add(normalizedColumn);
    }
    return normalizedMatrix;
  }

  // Calculate the weighted sum for each alternative
  List<List<Decimal>> _calculateWeightedSums(
      List<List<double>> normalizedMatrix, List<Criteria> criteriaList) {
    List<List<Decimal>> weightedSums = [];
    for (int altIndex = 0; altIndex < normalizedMatrix.length; altIndex++) {
      List<Decimal> altWeights = List.filled(criteriaList.length,
          Decimal.zero); // Initialize list for alternative weights
      for (int critIndex = 0;
          critIndex < normalizedMatrix[0].length;
          critIndex++) {
        altWeights[critIndex] =
            Decimal.parse(normalizedMatrix[altIndex][critIndex].toString()) *
                Decimal.parse(criteriaList[critIndex].weightValue.toString());
      }
      weightedSums.add(altWeights);
    }
    return weightedSums;
  }

  // Rank the alternatives
  List<int> _rankAlternatives(List<List<Decimal>> weightedSums) {
    List<int> rankings =
        List.generate(weightedSums.length, (index) => index + 1);
    rankings.sort((a, b) {
      Decimal sumA = Decimal.zero;
      Decimal sumB = Decimal.zero;

      // Calculate the sum of weighted sums for alternative A
      for (int i = 0; i < weightedSums[a - 1].length; i++) {
        sumA += weightedSums[a - 1][i];
      }

      // Calculate the sum of weighted sums for alternative B
      for (int i = 0; i < weightedSums[b - 1].length; i++) {
        sumB += weightedSums[b - 1][i];
      }

      // Compare the sums
      return sumB.compareTo(sumA);
    });
    return rankings;
  }

  void updateRankings(List<int> rankings) {
    // Update the rankings in your provider class
    // For example, you might have a list of alternatives with their rankings
    // You can update this list with the provided rankings
    // This is just a placeholder implementation, you need to adapt it to your specific use case
    for (int i = 0; i < alternatifList.length; i++) {
      alternatifList[i].ranking = rankings[i];
    }

    // Notify listeners that the rankings have been updated
    notifyListeners();
  }
}
