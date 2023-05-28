import 'package:celo_fitness_starter_file/web3_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Status { init, loading, done }

final web3Provider = ChangeNotifierProvider((ref) => Web3Provider());

class Web3Provider extends ChangeNotifier {
  List weightList = [];
  List workoutList = [];

  Status addWorkoutStatus = Status.init;
  Status addWeightStatus = Status.init;
  Status getAllWorkoutStatus = Status.init;
  Status getAllWeightStatus = Status.init;

  Future<void> addWorkOut(String workout, context) async {
    try {
      addWorkoutStatus = Status.loading;
      notifyListeners();
      final response = await Web3Helper().addWorkout(workout);
      if (response != null) {
        await getAllWorkOut();
      }
      addWorkoutStatus = Status.done;
      notifyListeners();
      Navigator.pop(context);
    } catch (e) {
      addWorkoutStatus = Status.done;
      notifyListeners();
      print(e);
    }
  }

  void addWeight(int weight, BuildContext context) async {
    try {
      addWeightStatus = Status.loading;
      notifyListeners();
      final response = await Web3Helper().addWeight(weight);
      if (response != null) {
        await getAllWeight();
      }
      addWeightStatus = Status.done;
      notifyListeners();
      Navigator.pop(context);
    } catch (e) {
      addWeightStatus = Status.done;
      notifyListeners();
      print(e);
    }
  }

  Future<void> getAllWorkOut() async {
    try {
      getAllWorkoutStatus = Status.loading;
      notifyListeners();
      final response = await Web3Helper().getAllWorkout();
      if (response != null) {
        workoutList = response;
      }
      getAllWorkoutStatus = Status.done;
      notifyListeners();
    } catch (e) {
      getAllWorkoutStatus = Status.done;
      notifyListeners();
      print(e);
    }
  }

  Future<void> getAllWeight() async {
    try {
      getAllWeightStatus = Status.loading;
      notifyListeners();
      final response = await Web3Helper().getAllWeights();
      if (response != null) {
        weightList = response;
      }
      getAllWeightStatus = Status.done;
      notifyListeners();
    } catch (e) {
      getAllWeightStatus = Status.done;
      notifyListeners();
      print(e);
    }
  }
}
