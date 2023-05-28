import 'package:celo_fitness_starter_file/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkoutScreen extends ConsumerStatefulWidget {
  const WorkoutScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends ConsumerState<WorkoutScreen> {
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(web3Provider).getAllWorkOut();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(web3Provider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workouts'),
        backgroundColor: Colors.teal,
      ),
      body: state.getAllWorkoutStatus == Status.loading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.teal,
              ),
            )
          : state.workoutList.isEmpty
              ? const Center(
                  child: Text('You have not created any workouts'),
                )
              : ListView.builder(
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.all(15),
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        border: Border.all(color: Colors.teal),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(state.workoutList[0][index]),
                          Text(DateTime.fromMillisecondsSinceEpoch(
                                  state.workoutList[1][index].toInt() * 1000)
                              .toString()),
                        ],
                      ),
                    );
                  },
                  itemCount: state.workoutList[0].length,
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await buildShowDialog(context);
        },
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<dynamic> buildShowDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController controller = TextEditingController();
        return AlertDialog(
          title: const Text('Add Workouts'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Enter workout'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            Consumer(builder: (context, ref, child) {
              final state = ref.watch(web3Provider);
              return TextButton(
                child:
                    ref.watch(web3Provider).addWorkoutStatus == Status.loading
                        ? const CircularProgressIndicator(
                            color: Colors.teal,
                          )
                        : const Text('Add'),
                onPressed: () {
                  debugPrint(state.addWorkoutStatus.toString());
                  if (controller.text.trim().isNotEmpty) {
                    ref
                        .read(web3Provider)
                        .addWorkOut(controller.text.trim(), context);
                  }
                  debugPrint(state.addWorkoutStatus.toString());
                },
              );
            }),
          ],
        );
      },
    );
  }
}
