<script>
import NftList from "@/components/nft/NftList";
import Web3 from "web3";
import {ABI_CONTRACT} from "@/const";
import axios from "axios";
import PageLoader from "@/components/utils/PageLoader";

export default {
  name: 'UserCollectionView',
  components: {
    PageLoader,
    NftList,
  },
  async created() {
    if (window.ethereum) {
      window.ethereum.request({method: 'eth_requestAccounts'}).then(async () => {
        console.log('Connected to MetaMask!')
        this.provider = new Web3(window.ethereum)
        this.contract = new this.provider.eth.Contract(ABI_CONTRACT, process.env.VUE_APP_WEB3_CONTRACT_ADDRESS)
        await this.loadUserNfts()
      }).catch((e) => {
        alert('Error: Not connected')
        console.log(e)
      })
    } else {
      alert('Error: MetaMask not found in the browser')
    }
  },
  methods: {
    async loadUserNfts() {
      if (this.contract) {
        const balance = await this.getUserBalance()
        const account = await this.getAccount()

        if (balance && account) {
          for (let i = 0; i < balance; i++) {
            const tokenId = await this.contract.methods.tokenOfOwnerByIndex(account, i).call()
            const metaUrl = await this.contract.methods.tokenURI(tokenId).call()
            const tokenPriceEth = await this.contract.methods.tokenPriceEth(tokenId).call()
            const tokenPriceUsdc = await this.contract.methods.tokenPriceUSDC(tokenId).call()

            axios.get(metaUrl).then(r => {
              const data = r.data
              this.nfts.push(
                  {
                    'id': tokenId,
                    'img': data.link,
                    'author': data.author,
                    'description': data.description,
                    'prices': {
                      'eth': tokenPriceEth,
                      'usdc': tokenPriceUsdc
                    }
                  }
              )
            }).catch(e => {
              console.log('Error for tokenId=' + tokenId + "." + e)
            })
          }
        }
      } else {
        alert('Error during contract init')
      }

      this.loading = false
    },
    async getUserBalance() {
      const account = await this.getAccount()

      if (account) {
        return await this.contract.methods.balanceOf(account).call()
      } else {
        return null
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
  },
  data() {
    return {
      loading: true,
      provider: null,
      contract: null,
      nfts: []
    }
  }
}
</script>

<template>
  <div>
    <div class="gallery">
      <div class="container">
        <div class="row">
          <div class="col-lg-12 text-left mt-5">
            <h1 class="font-weight-bold">Your collection 🌌</h1>
          </div>
        </div>

        <NftList class="mb-5" v-if="!loading" :nfts="nfts"/>
        <PageLoader v-else/>
      </div>
    </div>
  </div>
</template>
