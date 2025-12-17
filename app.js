let provider;
let signer;
let contract;

async function connectWallet() {
  if (!window.ethereum) {
    alert("MetaMask tidak ditemukan");
    return;
  }

  provider = new ethers.providers.Web3Provider(window.ethereum);
  await provider.send("eth_requestAccounts", []);
  signer = provider.getSigner();

  const address = await signer.getAddress();
  document.getElementById("account").innerText =
    "Connected: " + address;

  contract = new ethers.Contract(
    CONTRACT_ADDRESS,
    CONTRACT_ABI,
    signer
  );
}

async function mintNFT() {
  const tx = await contract.mintNFT();
  await tx.wait();
  alert("NFT berhasil di-mint");
}

async function listNFT() {
  const tokenId = document.getElementById("tokenId").value;
  const priceEth = document.getElementById("price").value;
  const priceWei = ethers.utils.parseEther(priceEth);

  const tx = await contract.listNFT(tokenId, priceWei);
  await tx.wait();
  alert("NFT berhasil di-list");
}

async function buyNFT() {
  const tokenId = document.getElementById("buyTokenId").value;
  const priceEth = document.getElementById("buyPrice").value;

  const tx = await contract.buyNFT(tokenId, {
    value: ethers.utils.parseEther(priceEth)
  });
  await tx.wait();
  alert("NFT berhasil dibeli");
}
