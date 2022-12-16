<script>
import Web3 from "web3";
import {ABI_CONTRACT, ABI_USDC_CONTRACT} from "@/const";
import NftLoader from "@/components/nft/NftLoader";

export default {
  name: 'NftCard',
  components: {NftLoader},
  props: {
    id: {
      type: String,
      required: true
    },
    img: {
      type: String,
      required: true
    },
    author: {
      type: String,
      required: true
    },
    description: {
      type: String,
      required: true
    },
    prices: {
      type: Object,
      required: true
    },
    sellingMode: {
      type: Boolean,
      required: false,
      default: false
    }
  },
  async created() {
    if (window.ethereum) {
      window.ethereum.request({method: 'eth_requestAccounts'}).then(async () => {
        console.log('Connected to MetaMask!')
        this.provider = new Web3(window.ethereum)
        this.contract = new this.provider.eth.Contract(ABI_CONTRACT, process.env.VUE_APP_WEB3_CONTRACT_ADDRESS)
        this.usdcContract =
            new this.provider.eth.Contract(ABI_USDC_CONTRACT, process.env.VUE_APP_WEB3_USDC_CONTRACT_ADDRESS)
      }).catch((e) => {
        alert('Error: Not connected')
        console.log(e)
      })
    } else {
      alert('Error: MetaMask not found in the browser')
    }
  },
  data() {
    return {
      provider: null,
      contract: null,
      usdcContract: null,
      transactionInProcess: false
    }
  },
  methods: {
    async burn() {
      this.transactionInProcess = true
      const account = await this.getAccount()

      if (account) {
        const res = await this.contract.methods.burn(this.id).send({from: account})
        console.log(res)
        alert('Successfully burned NFT!')
      }

      this.transactionInProcess = false
    },
    async getAccount() {
      const accounts = await ethereum.request({method: 'eth_accounts'})

      if (accounts.length === 0) {
        alert("Error: Account couldn't be loaded")
        return null
      } else {
        return accounts[0]
      }
    },
    async buyEth() {
      this.transactionInProcess = true
      const account = await this.getAccount()

      const resp = await this.contract.methods.buyEth(this.id).send({from: account, value: this.prices.eth})
      alert('Congrats! Now you become the owner :)')
      this.transactionInProcess = false
    },
    async buyUsdc() {
      this.transactionInProcess = true
      const account = await this.getAccount()

      const respApprove = await this.usdcContract.methods.approve(process.env.VUE_APP_WEB3_CONTRACT_ADDRESS, this.prices.usdc)
          .send({from: account})
      const resp = await this.contract.methods.buyUSDC(this.id).send({from: account})
      alert('Congrats! Now you become the owner :)')
      this.transactionInProcess = false
    }
  }
}
</script>

<template>
  <div class="nft-item">
    <div class="img">
      <img
          :src="img"
          alt="">
    </div>
    <div class="author text-left mt-1">
      <p class="text-muted mb-0">{{ author }}</p>
    </div>
    <div class="about">
      <h5 class="text-left font-weight-bold">{{ description }}</h5>
    </div>
    <div class="prices mt-2" v-if="sellingMode">
      <div @click="buyEth" class="price price-eth">
        <button class="text-center font-weight-bold">
          <img style="max-width: 20px; max-height: 20px;"
               src="https://cdn.cdnlogo.com/logos/e/81/ethereum-eth.svg"/>
          <span v-text="prices.eth"></span>
        </button>
      </div>
      <div class="price price-usdc">
        <button @click="buyUsdc" class="text-center font-weight-bold">
          <img style="max-width: 20px; max-height: 20px; margin-right: 2px;"
               src="https://cryptologos.cc/logos/usd-coin-usdc-logo.png"/>
          <span v-text="prices.usdc"></span>
        </button>
      </div>
    </div>
    <div class="control mt-2" v-else>
      <div class="burn">
        <button @click="burn()" class="btn btn-danger">
          🔥 Burn
        </button>
      </div>
    </div>

    <NftLoader v-if="transactionInProcess" />
  </div>
</template>

<style scoped>

button {
  cursor: pointer;
}

div.nft-item {
  display: inline-block;
  margin: 10px;
  width: calc(25% - 20px);
  border-radius: 25px;
}

div.nft-item div.img img {
  position: relative;
  max-width: 100%;
  max-height: 100%;
  border-radius: 20px;
}

div.nft-item div.prices {
  display: flex;
}

div.nft-item div.prices div.price {
  padding: 1px 0;
  border-radius: 10px;
  color: #ffffff;
  margin: 0 2px;
  flex: 1;
  background: #1890ff;
}

div.nft-item div.prices div.price button {
  padding: 10px;
  background: none;
  border: none;
  color: #ffffff;
}

div.nft-item div.prices div.price:hover {
  background: linear-gradient(90deg, #09C6F9, #045DE9);
  transition: 1s all ease-out;
}

div.nft-item div.prices div.price-eth {
  background: #627eea;
}

div.nft-item div.prices div.price-usdc {
  background: #3980ce;
}

div.nft-item div.control {
  display: flex;
}

div.nft-item div.control div.burn {
  margin: 0 2px;
  flex: 1;
}

div.nft-item div.control button {
  width: 100%;
}
</style>