abiBread2GnosisPay = [
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"internalType": "address",
				"name": "to",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "amount",
				"type": "uint256"
			}
		],
		"name": "TransferSuccessful",
		"type": "event"
	},
	{
		"inputs": [
			{
				"internalType": "int128",
				"name": "i",
				"type": "int128"
			},
			{
				"internalType": "int128",
				"name": "j",
				"type": "int128"
			},
			{
				"internalType": "uint256",
				"name": "dx",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "slippageToleranceInBasisPoints",
				"type": "uint256"
			}
		],
		"name": "computeMinDy",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "safeWallet",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "amount",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "min_dy",
				"type": "uint256"
			}
		],
		"name": "swapAndTransfer",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	}
]