import 'dart:convert';

import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

final client = Web3Client('https://alfajores-forno.celo-testnet.org', Client());

const abi = '<your-contract-abi>';
// Replace these with your actual contract ABI

final contractAddress = EthereumAddress.fromHex(
    '<your-contract-address>'); // replace with your actual contract address
final contractABI = json.encode(abi);

class Web3Helper {
  //Create a contract instance that we can interact with
  final contract = DeployedContract(
    ContractAbi.fromJson(contractABI, 'FitnessTracker'),
    contractAddress,
  );

  final credentials = EthPrivateKey.fromHex(
      "<your-private-key>"); // replace with your celo wallet private key

  Future addWorkout(String workOut) async {
    final addWorkoutFunction = contract.function('addWorkout');
    final responseAddWorkout = await client.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: addWorkoutFunction,
        parameters: [workOut],
      ),
      chainId: 44787,
    );

    while (true) {
      final receipt = await client.getTransactionReceipt(responseAddWorkout);
      if (receipt != null) {
        print('Transaction successful');
        print(receipt);
        break;
      }
      // Wait for a while before polling again
      await Future.delayed(const Duration(seconds: 1));
    }
    return responseAddWorkout;
  }

  Future addWeight(int weight) async {
    final addWeightFunction = contract.function('addWeightRecord');
    final responseAddWeight = await client.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: addWeightFunction,
        parameters: [BigInt.from(weight)], // Your weight in kilograms
      ),
      chainId: 44787,
    );

    while (true) {
      final receipt = await client.getTransactionReceipt(responseAddWeight);
      if (receipt != null) {
        print('Transaction successful');
        break;
      }
      // Wait for a while before polling again
      await Future.delayed(const Duration(seconds: 1));
    }
    return responseAddWeight;
  }

  Future getAllWorkout() async {
    final getWorkoutsFunction = contract.function('getAllWorkouts');
    final workouts = await client.call(
      sender: credentials.address,
      contract: contract,
      function: getWorkoutsFunction,
      params: [],
    );
    return workouts;
  }

  Future getAllWeights() async {
    final getWeightsFunction = contract.function('getAllWeightRecords');
    final weights = await client.call(
      sender: credentials.address,
      contract: contract,
      function: getWeightsFunction,
      params: [],
    );
    return weights;
  }
}
