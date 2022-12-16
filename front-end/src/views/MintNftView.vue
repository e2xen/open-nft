<script>
import Moralis from "moralis";
import {v4 as uuidv4} from 'uuid';
import Web3 from "web3";
import {ABI_CONTRACT} from "@/const";
import NftLoader from "@/components/nft/NftLoader";

export default {
  name: 'MintNftView',
  components: {NftLoader},
  props: {},
  data() {
    return {
      author: '',
      description: '',
      prices: {
        eth: '',
        usdc: ''
      },
      file: null,
      provider: null,
      contract: null,
      loadingInProcess: false
    }
  },
  async created() {
    try {
      await Moralis.start({
        apiKey: process.env.VUE_APP_MORALIS_API_KEY,
      })
    } catch (e) {
      console.log(e)
    }

    if (window.ethereum) {
      window.ethereum.request({method: 'eth_requestAccounts'}).then(() => {
        console.log('Connected to MetaMask!')
        this.provider = new Web3(window.ethereum)
        this.contract = new this.provider.eth.Contract(ABI_CONTRACT, process.env.VUE_APP_WEB3_CONTRACT_ADDRESS)
      }).catch((e) => {
        alert('Error: Not connected')
        console.log(e)
      })
    } else {
      alert('Error: MetaMask not found in the browser')
    }
  },
  methods: {
    previewFile(event) {
      this.file = null
      if (event.target.files.length > 0) {
        this.file = event.target.files[0]
      }
    },
    submitForm() {
      this.loadingInProcess = true
      const reader = new FileReader()
      reader.readAsBinaryString(this.file)
      reader.onload = async (e) => {
        await this.uploadImgToIpfs(e.target.result)
        this.loadingInProcess = false
      }
    },
    async uploadImgToIpfs(imgBinary) {
      const imageExt = this.file.name.split('.').pop()

      const responseImg = await Moralis.EvmApi.ipfs.uploadFolder({
        abi: [
          {
            path: uuidv4() + '.' + imageExt,
            content: btoa(imgBinary)
          }
        ]
      })

      console.log('Img is uploaded to IPFS', responseImg)
      await this.uploadMetaToIpfs(responseImg.result[0].path)
    },
    async uploadMetaToIpfs(link) {
      const uploadMeta = [
        {
          path: uuidv4(),
          content: {
            author: this.author,
            description: this.description,
            link: link
          }
        }
      ]
      const response = await Moralis.EvmApi.ipfs.uploadFolder({abi: uploadMeta})
      console.log(response)

      const uriWithPrefix = new URL(response.result[0].path).pathname
      const uri = uriWithPrefix.substring(6, uriWithPrefix.length)

      if (this.contract) {
        const account = await this.getAccount()

        if (account) {
          this.contract.methods.safeMint(uri, this.prices.eth, this.prices.usdc).send({from: account}).then(result => {
            alert("Successfully minted! Take a look at the market :)")
            console.log(result)
          }).catch(e => {
            alert("Error occurred :(")
            console.log(e)
          })
        } else {
          alert('Metamask account not found')
        }
      } else {
        alert('Uploaded to IPFS, but contract not found')
      }
    },
    async getAccount() {
      const accounts = await ethereum.request({method: 'eth_accounts'})

      if (accounts.length === 0) {
        alert("Error: Account couldn't be loaded")
        return null
      } else {
        return accounts[0]
      }
    }
  }
}
</script>

<template>
  <div class="container">
    <div class="row mt-5">
      <div class="col-lg-12">
        <h1>👾👨‍💻👾</h1>
        <h1 class="font-weight-bold">Create your own NFT!</h1>

        <div class="form-box mt-5">
          <h2>Mint NFT</h2>
          <form @submit.prevent>
            <div class="user-box">
              <input :value="author" @input="(event) => this.author = event.target.value" type="text"
                     id="mint_form_author" name="author" autocomplete="off" required="true">
              <label for="mint_form_author">Author</label>
            </div>
            <div class="user-box">
              <input :value="description" @input="(event) => this.description = event.target.value" type="text"
                     id="mint_form_description" name="description" autocomplete="off">
              <label for="mint_form_description">Description</label>
            </div>
            <div class="prices">
              <div class="user-box">
                <input type="number" :value="prices.eth" @input="(event) => this.prices.eth = event.target.value"
                       id="mint_form_price_eth" name="price_eth" autocomplete="off">
                <label for="mint_form_price_eth">Price in ETH</label>
              </div>
              <div class="user-box">
                <input type="number" :value="prices.usdc" @input="(event) => this.prices.usdc = event.target.value"
                       id="mint_form_price_usdc" name="price_usdc" autocomplete="off">
                <label for="mint_form_price_usdc">Price in USDC</label>
              </div>
            </div>
            <div class="user-box">
              <input @change="previewFile" type="file" id="mint_form_file" name="file" autocomplete="off">
              <label for="mint_form_file">Image</label>
            </div>

            <a href="#" @click="submitForm">
              <span></span>
              <span></span>
              <span></span>
              <span></span>
              Submit
            </a>
          </form>
        </div>
      </div>
    </div>

    <NftLoader v-if="loadingInProcess"/>
  </div>
</template>

<style scoped>
.form-box {
  padding: 40px;
  background: #0c131d;
  box-sizing: border-box;
  box-shadow: 0 15px 25px rgba(0, 0, 0, .6);
  border-radius: 10px;
}

.form-box h2 {
  margin: 0 0 30px;
  padding: 0;
  color: #fff;
  text-align: center;
}

.form-box .user-box {
  position: relative;
}

.form-box .user-box input {
  width: 100%;
  padding: 10px 0;
  font-size: 16px;
  color: #fff;
  margin-bottom: 30px;
  border: none;
  border-bottom: 1px solid #fff;
  outline: none;
  background: transparent;
}

.form-box .user-box input[type="file"] {
  border-bottom: none;
}

.form-box .user-box label {
  position: absolute;
  top: 0;
  left: 0;
  padding: 10px 0;
  font-size: 16px;
  color: #fff;
  pointer-events: none;
  transition: .5s;
}

.form-box .prices {
  display: flex;
}

.form-box .prices .user-box {
  width: 150px;
}

.form-box .prices .user-box:last-child {
  margin-left: 10px;
}

.form-box .user-box input:focus ~ label,
.form-box .user-box input:valid ~ label {
  top: -20px;
  left: 0;
  color: #ffffff;
  font-size: 12px;
}

.form-box form a {
  position: relative;
  display: inline-block;
  padding: 10px 20px;
  color: #ffffff;
  font-size: 16px;
  text-decoration: none;
  text-transform: uppercase;
  overflow: hidden;
  transition: .5s;
  margin-top: 40px;
  letter-spacing: 4px
}

.form-box a:hover {
  background: #0c131d;
  color: #fff;
  border-radius: 5px;
  box-shadow: 0 0 5px #ffffff;
}

.form-box a span {
  position: absolute;
  display: block;
}

.form-box a span:nth-child(1) {
  top: 0;
  left: -100%;
  width: 100%;
  height: 2px;
  background: linear-gradient(90deg, transparent, #ffffff);
  animation: btn-anim1 1s linear infinite;
}

@keyframes btn-anim1 {
  0% {
    left: -100%;
  }
  50%, 100% {
    left: 100%;
  }
}

.form-box a span:nth-child(2) {
  top: -100%;
  right: 0;
  width: 2px;
  height: 100%;
  background: linear-gradient(180deg, transparent, #ffffff);
  animation: btn-anim2 1s linear infinite;
  animation-delay: .25s
}

@keyframes btn-anim2 {
  0% {
    top: -100%;
  }
  50%, 100% {
    top: 100%;
  }
}

.form-box a span:nth-child(3) {
  bottom: 0;
  right: -100%;
  width: 100%;
  height: 2px;
  background: linear-gradient(270deg, transparent, #ffffff);
  animation: btn-anim3 1s linear infinite;
  animation-delay: .5s
}

@keyframes btn-anim3 {
  0% {
    right: -100%;
  }
  50%, 100% {
    right: 100%;
  }
}

.form-box a span:nth-child(4) {
  bottom: -100%;
  left: 0;
  width: 2px;
  height: 100%;
  background: linear-gradient(360deg, transparent, #ffffff);
  animation: btn-anim4 1s linear infinite;
  animation-delay: .75s
}

@keyframes btn-anim4 {
  0% {
    bottom: -100%;
  }
  50%, 100% {
    bottom: 100%;
  }
}
</style>