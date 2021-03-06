var web3;// = new Web3("ws://localhost:8080");
var a = document.getElementById("info");
var blank_request = "0x0000000000000000000000000000000000000000000000000000000000000000";
var x, y, ID, name, account, curr_request, supply;


async function loadWeb3() {
    if (typeof web3 !== 'undefined') {
        web3 = await new Web3(window.ethereum);//web3 = await new Web3(web3.currentProvider);
    }
    //if (window.ethereum) {
        //web3 = new Web3(window.ethereum);
        //await window.ethereum.enable();
    //} 
}

async function loadContract() {
    var abi = [
{
"inputs": [],
"stateMutability": "nonpayable",
"type": "constructor"
},
{
"anonymous": false,
"inputs": [
    {
        "indexed": true,
        "internalType": "address",
        "name": "owner",
        "type": "address"
    },
    {
        "indexed": true,
        "internalType": "address",
        "name": "approved",
        "type": "address"
    },
    {
        "indexed": true,
        "internalType": "uint256",
        "name": "tokenId",
        "type": "uint256"
    }
],
"name": "Approval",
"type": "event"
},
{
"anonymous": false,
"inputs": [
    {
        "indexed": true,
        "internalType": "address",
        "name": "owner",
        "type": "address"
    },
    {
        "indexed": true,
        "internalType": "address",
        "name": "operator",
        "type": "address"
    },
    {
        "indexed": false,
        "internalType": "bool",
        "name": "approved",
        "type": "bool"
    }
],
"name": "ApprovalForAll",
"type": "event"
},
{
"anonymous": false,
"inputs": [
    {
        "indexed": true,
        "internalType": "address",
        "name": "from",
        "type": "address"
    },
    {
        "indexed": true,
        "internalType": "address",
        "name": "to",
        "type": "address"
    },
    {
        "indexed": true,
        "internalType": "uint256",
        "name": "tokenId",
        "type": "uint256"
    }
],
"name": "Transfer",
"type": "event"
},
{
"inputs": [
    {
        "internalType": "address",
        "name": "to",
        "type": "address"
    },
    {
        "internalType": "uint256",
        "name": "tokenId",
        "type": "uint256"
    }
],
"name": "approve",
"outputs": [],
"stateMutability": "nonpayable",
"type": "function"
},
{
"inputs": [
    {
        "internalType": "address",
        "name": "owner",
        "type": "address"
    }
],
"name": "balanceOf",
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
"inputs": [],
"name": "baseURI",
"outputs": [
    {
        "internalType": "string",
        "name": "",
        "type": "string"
    }
],
"stateMutability": "view",
"type": "function"
},
{
"inputs": [],
"name": "generateRandomWalkNFT",
"outputs": [
    {
        "internalType": "bool",
        "name": "success",
        "type": "bool"
    }
],
"stateMutability": "nonpayable",
"type": "function"
},
{
"inputs": [
    {
        "internalType": "uint256",
        "name": "tokenId",
        "type": "uint256"
    }
],
"name": "getApproved",
"outputs": [
    {
        "internalType": "address",
        "name": "",
        "type": "address"
    }
],
"stateMutability": "view",
"type": "function"
},
{
"inputs": [
    {
        "internalType": "address",
        "name": "owner",
        "type": "address"
    },
    {
        "internalType": "address",
        "name": "operator",
        "type": "address"
    }
],
"name": "isApprovedForAll",
"outputs": [
    {
        "internalType": "bool",
        "name": "",
        "type": "bool"
    }
],
"stateMutability": "view",
"type": "function"
},
{
"inputs": [],
"name": "name",
"outputs": [
    {
        "internalType": "string",
        "name": "",
        "type": "string"
    }
],
"stateMutability": "view",
"type": "function"
},
{
"inputs": [
    {
        "internalType": "uint256",
        "name": "tokenId",
        "type": "uint256"
    }
],
"name": "ownerOf",
"outputs": [
    {
        "internalType": "address",
        "name": "",
        "type": "address"
    }
],
"stateMutability": "view",
"type": "function"
},
{
"inputs": [],
"name": "randomResult",
"outputs": [
    {
        "internalType": "int256",
        "name": "",
        "type": "int256"
    }
],
"stateMutability": "view",
"type": "function"
},
{
"inputs": [
    {
        "internalType": "bytes32",
        "name": "requestId",
        "type": "bytes32"
    },
    {
        "internalType": "uint256",
        "name": "randomness",
        "type": "uint256"
    }
],
"name": "rawFulfillRandomness",
"outputs": [],
"stateMutability": "nonpayable",
"type": "function"
},
{
"inputs": [
    {
        "internalType": "uint256",
        "name": "userProvidedSeed",
        "type": "uint256"
    },
    {
        "internalType": "uint256",
        "name": "nodes",
        "type": "uint256"
    }
],
"name": "requestRandomWalk",
"outputs": [
    {
        "internalType": "bytes32",
        "name": "",
        "type": "bytes32"
    }
],
"stateMutability": "nonpayable",
"type": "function"
},
{
"inputs": [
    {
        "internalType": "bytes32",
        "name": "",
        "type": "bytes32"
    }
],
"name": "requestToMapName",
"outputs": [
    {
        "internalType": "string",
        "name": "",
        "type": "string"
    }
],
"stateMutability": "view",
"type": "function"
},
{
"inputs": [
    {
        "internalType": "bytes32",
        "name": "",
        "type": "bytes32"
    }
],
"name": "requestToNodes",
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
        "internalType": "bytes32",
        "name": "",
        "type": "bytes32"
    }
],
"name": "requestToSender",
"outputs": [
    {
        "internalType": "address",
        "name": "",
        "type": "address"
    }
],
"stateMutability": "view",
"type": "function"
},
{
"inputs": [
    {
        "internalType": "bytes32",
        "name": "",
        "type": "bytes32"
    }
],
"name": "requestToTokenID",
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
        "name": "from",
        "type": "address"
    },
    {
        "internalType": "address",
        "name": "to",
        "type": "address"
    },
    {
        "internalType": "uint256",
        "name": "tokenId",
        "type": "uint256"
    }
],
"name": "safeTransferFrom",
"outputs": [],
"stateMutability": "nonpayable",
"type": "function"
},
{
"inputs": [
    {
        "internalType": "address",
        "name": "from",
        "type": "address"
    },
    {
        "internalType": "address",
        "name": "to",
        "type": "address"
    },
    {
        "internalType": "uint256",
        "name": "tokenId",
        "type": "uint256"
    },
    {
        "internalType": "bytes",
        "name": "_data",
        "type": "bytes"
    }
],
"name": "safeTransferFrom",
"outputs": [],
"stateMutability": "nonpayable",
"type": "function"
},
{
"inputs": [
    {
        "internalType": "uint256",
        "name": "tokenID",
        "type": "uint256"
    }
],
"name": "seeRandomWalk",
"outputs": [
    {
        "components": [
            {
                "internalType": "string",
                "name": "name",
                "type": "string"
            },
            {
                "internalType": "uint256",
                "name": "ID",
                "type": "uint256"
            },
            {
                "internalType": "uint256",
                "name": "nodes",
                "type": "uint256"
            },
            {
                "internalType": "int256[]",
                "name": "x",
                "type": "int256[]"
            },
            {
                "internalType": "int256[]",
                "name": "y",
                "type": "int256[]"
            }
        ],
        "internalType": "struct RandomWalkNFT.RandomWalk",
        "name": "",
        "type": "tuple"
    }
],
"stateMutability": "view",
"type": "function"
},
{
"inputs": [
    {
        "internalType": "address",
        "name": "",
        "type": "address"
    }
],
"name": "senderToRequest",
"outputs": [
    {
        "internalType": "bytes32",
        "name": "",
        "type": "bytes32"
    }
],
"stateMutability": "view",
"type": "function"
},
{
"inputs": [
    {
        "internalType": "address",
        "name": "operator",
        "type": "address"
    },
    {
        "internalType": "bool",
        "name": "approved",
        "type": "bool"
    }
],
"name": "setApprovalForAll",
"outputs": [],
"stateMutability": "nonpayable",
"type": "function"
},
{
"inputs": [
    {
        "internalType": "uint256",
        "name": "tokenID",
        "type": "uint256"
    },
    {
        "internalType": "string",
        "name": "_tokenURI",
        "type": "string"
    }
],
"name": "setTokenURI",
"outputs": [],
"stateMutability": "nonpayable",
"type": "function"
},
{
"inputs": [
    {
        "internalType": "bytes4",
        "name": "interfaceId",
        "type": "bytes4"
    }
],
"name": "supportsInterface",
"outputs": [
    {
        "internalType": "bool",
        "name": "",
        "type": "bool"
    }
],
"stateMutability": "view",
"type": "function"
},
{
"inputs": [],
"name": "symbol",
"outputs": [
    {
        "internalType": "string",
        "name": "",
        "type": "string"
    }
],
"stateMutability": "view",
"type": "function"
},
{
"inputs": [
    {
        "internalType": "uint256",
        "name": "index",
        "type": "uint256"
    }
],
"name": "tokenByIndex",
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
        "name": "owner",
        "type": "address"
    },
    {
        "internalType": "uint256",
        "name": "index",
        "type": "uint256"
    }
],
"name": "tokenOfOwnerByIndex",
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
        "internalType": "uint256",
        "name": "tokenId",
        "type": "uint256"
    }
],
"name": "tokenURI",
"outputs": [
    {
        "internalType": "string",
        "name": "",
        "type": "string"
    }
],
"stateMutability": "view",
"type": "function"
},
{
"inputs": [],
"name": "totalSupply",
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
        "name": "from",
        "type": "address"
    },
    {
        "internalType": "address",
        "name": "to",
        "type": "address"
    },
    {
        "internalType": "uint256",
        "name": "tokenId",
        "type": "uint256"
    }
],
"name": "transferFrom",
"outputs": [],
"stateMutability": "nonpayable",
"type": "function"
}
];

    // ??? Old contract, has bugs, but useful for testing	(ABI is the same)
    //var contractAddress = "0x8BFc9b3bdCE5d4005C42E899FF872F5ac6f5a9E5";
    
    // ??? Newest contract
    var contractAddress = "0xc9E02478307B6306edfd2a96642576eDF15f17fa";
    return await new web3.eth.Contract(abi, contractAddress);
}

async function load() {
    await loadWeb3();
    window.contract = await loadContract();
    await getCurrentAccount();
    updateStatus("Loading Python...");
}

async function getCurrentAccount() {
    const accounts = await web3.eth.getAccounts();
    account = accounts[0];
}

function updateStatus(status) {
    const statusE1 = document.getElementById("status");
    statusE1.innerHTML = status;
    console.log(status);
}

function refreshWebpage() {
    window.location = window.location.href;
}

async function getTotalSupply() {
    const supply = await window.contract.methods.totalSupply().call();
    a.innerHTML = "No. of Random Walks: " + supply;
}

async function storeWalkDetails() {
    ID = document.getElementById("WalkID").value;
    const walk = await window.contract.methods.seeRandomWalk(ID).call();
    x = walk.x;
    y = walk.y;
    name = walk.name + " (ID: " + ID + ")";
}

async function plotWalk() {
    await window.contract.methods.totalSupply().call().then(function(new_supply) {
        supply = Number(new_supply);
    });
    if (document.getElementById("WalkID").value >= supply || !Number.isInteger(Number(document.getElementById("WalkID").value))) {
        document.getElementById("WalkID").value = "Must be a valid ID";
        await getTotalSupply();
        return true;
    }
    updateStatus("Loading Python and imports...");
    await storeWalkDetails();
    //pyodide.loadPackage('numpy')
    import_code = 'from js import window\nfrom js import document\nimport matplotlib.pyplot as plt\nimport io\nimport base64\nfrom numpy import random';
    await pyodide.runPythonAsync(import_code);

    updateStatus("Plotting RWalk in Python...");
    plot_code = '\nxs = [int(x)/10**24 for x in window.x]\nys = [int(y)/10**24 for y in window.y]\nplt.figure(int(window.ID) + random.randint(1e6))\nplt.plot(xs, ys, "k--", linewidth=2.25)\nplt.plot(xs[0], ys[0], "bo", markersize="10", label="Start")\nplt.plot(xs[-1], ys[-1], "ro", markersize="10", label="End")\nplt.legend()\nplt.title(window.name)\nbuf = io.BytesIO()\nplt.savefig(buf, format="png")\nbuf.seek(0)\nimg_str = "data:image/png;base64," + base64.b64encode(buf.read()).decode("UTF-8")\nimg_tag = document.getElementById("RWalk_plt")\nimg_tag.src = img_str\nbuf.close()';
    //plot_code = 'from js import window\nfrom js import document\nimport numpy\nx=numpy.linspace(0,10,100)';
    
    await pyodide.runPythonAsync(plot_code);
    updateStatus("Finished plot of RWalk ID: "+ID);
}

async function generateRWalk() {
    var num_nodes = document.getElementById("user_nodes").value;
    if (num_nodes > 40 || !Number.isInteger(Number(num_nodes))) {
        document.getElementById("user_nodes").value = "Must be less than 41";
        return true;
    }

    updateStatus("Generating RWalk (wait at least 3 blocks)...");
    rand_code = "from numpy import random\nrand = random.randint(1e8)";
    await pyodide.runPythonAsync(rand_code);

    // Request a random number for the user:
    await getCurrentAccount();
    await window.contract.methods.requestRandomWalk(pyodide.globals.rand, num_nodes).send({from:account}).then(console.log);

    await getRequest();
    var request = curr_request;
    console.log("Wait, "+request);

    while (true) {
        await setTimeout(function() {
            console.log(curr_request);
        }, 5000);
        await getRequest();
        if (curr_request !== blank_request) {
            break;
        }
    }

    // After it is confirmed that the VRF Oracle gave
    // a random number to the user, generate the NFT:
    await window.contract.methods.generateRandomWalkNFT().send({from:account}).then(console.log);

    // Plot on screen:
    await window.contract.methods.requestToTokenID(curr_request).call().then(function(new_ID){
        //ID = new_ID;
        document.getElementById("WalkID").value = new_ID;
        plotWalk();
    });
}

async function getRequest() {
    var request;
    const call_request = await window.contract.methods.senderToRequest(account).call().then(function(req) {
        console.log(req);
        curr_request = req;
    });
    
}


load();