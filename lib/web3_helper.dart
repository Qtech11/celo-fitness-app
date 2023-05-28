import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

final client = Web3Client('https://alfajores-forno.celo-testnet.org', Client());

const abi = [
  {
    "inputs": [
      {"internalType": "uint256", "name": "_weight", "type": "uint256"}
    ],
    "name": "addWeightRecord",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {"internalType": "string", "name": "_name", "type": "string"}
    ],
    "name": "addWorkout",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "getAllWeightRecords",
    "outputs": [
      {"internalType": "uint256[]", "name": "", "type": "uint256[]"},
      {"internalType": "uint256[]", "name": "", "type": "uint256[]"}
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "getAllWorkouts",
    "outputs": [
      {"internalType": "string[]", "name": "", "type": "string[]"},
      {"internalType": "uint256[]", "name": "", "type": "uint256[]"}
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {"internalType": "uint256", "name": "_index", "type": "uint256"}
    ],
    "name": "getWeightRecord",
    "outputs": [
      {"internalType": "uint256", "name": "", "type": "uint256"},
      {"internalType": "uint256", "name": "", "type": "uint256"}
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "getWeightRecordCount",
    "outputs": [
      {"internalType": "uint256", "name": "", "type": "uint256"}
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {"internalType": "uint256", "name": "_index", "type": "uint256"}
    ],
    "name": "getWorkout",
    "outputs": [
      {"internalType": "string", "name": "", "type": "string"},
      {"internalType": "uint256", "name": "", "type": "uint256"}
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "getWorkoutCount",
    "outputs": [
      {"internalType": "uint256", "name": "", "type": "uint256"}
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {"internalType": "address", "name": "", "type": "address"},
      {"internalType": "uint256", "name": "", "type": "uint256"}
    ],
    "name": "weightRecords",
    "outputs": [
      {"internalType": "uint256", "name": "weight", "type": "uint256"},
      {"internalType": "uint256", "name": "timestamp", "type": "uint256"}
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {"internalType": "address", "name": "", "type": "address"},
      {"internalType": "uint256", "name": "", "type": "uint256"}
    ],
    "name": "workouts",
    "outputs": [
      {"internalType": "string", "name": "name", "type": "string"},
      {"internalType": "uint256", "name": "timestamp", "type": "uint256"}
    ],
    "stateMutability": "view",
    "type": "function"
  }
];
// Replace these with your actual contract address and ABI

final contractAddress =
    EthereumAddress.fromHex('0x5c247A852f7cf7586c9D7B3c290d18bfDe97CFD0');
final contractABI = json.encode(abi);

class Web3Helper {
  //Create a contract instance that we can interact with
  final contract = DeployedContract(
    ContractAbi.fromJson(contractABI, 'FitnessTracker'),
    contractAddress,
  );

  // final credentials = await client.credentialsFromPrivateKey("<your-private-key>");
  final credentials = EthPrivateKey.fromHex(
      "88093061c7ffd4701cd6c37532868e34043ad3f57ab3f2c08e1d290401b2a7b4");

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
    log('lets go.........');
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
