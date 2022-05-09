// contract address
// https://testnet.ftmscan.com/address/0x4dda0E92e210F579d1655fbfE62Ac1C05eEE3CCD#code

// mint code
import Web3 from "web3"
import contractABI from "./abi"

window.web3 = new Web3(window.ethereum);

const contract = await new window.web3.eth.Contract(
            contractABI, contractAddress
        );

const mintPrice = contract.methods.mintPrice().call();
console.log(mintPrice);

const price = 0.05; // nft mint price is 0.15ether

const tokenPrice = window.web3.utils.toWei(price + '', 'ether');

try {
            contract.methods.mint().send({
                from: window.ethereum.selectedAddress,
                gasPrice: '700000000000',
		value: tokenPrice
            }).on('receipt', (res) => {
                console.log('success')
            }).on('error', (error) => {
               console.log('error', error) 
            });
        } catch (error) {
           console.error(error);
        }