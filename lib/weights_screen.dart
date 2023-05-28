import 'package:celo_fitness_starter_file/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WeightScreen extends ConsumerStatefulWidget {
  const WeightScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<WeightScreen> createState() => _WeightScreenState();
}

class _WeightScreenState extends ConsumerState<WeightScreen> {
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(web3Provider).getAllWeight();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(web3Provider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weights'),
        backgroundColor: Colors.teal,
      ),
      body: state.getAllWeightStatus == Status.loading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.teal,
              ),
            )
          : state.weightList.isEmpty
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
                          Text('${state.weightList[0][index].toString()} kg'),
                          Text(DateTime.fromMillisecondsSinceEpoch(
                                  state.weightList[1][index].toInt() * 1000)
                              .toString()),
                        ],
                      ),
                    );
                  },
                  itemCount: state.weightList[0].length,
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
          title: const Text("Add Today's Weight"),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: 'Enter Weight'),
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
                child: ref.watch(web3Provider).addWeightStatus == Status.loading
                    ? const CircularProgressIndicator(
                        color: Colors.teal,
                      )
                    : const Text('Add'),
                onPressed: () {
                  debugPrint(state.addWeightStatus.toString());
                  if (controller.text.trim().isNotEmpty) {
                    ref
                        .read(web3Provider)
                        .addWeight(int.parse(controller.text.trim()), context);
                  }
                  debugPrint(state.addWeightStatus.toString());
                },
              );
            }),
          ],
        );
      },
    );
  }
}
