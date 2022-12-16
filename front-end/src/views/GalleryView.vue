<script>
import Nav from "@/components/Nav"
import NftCard from "@/components/nft/NftCard";
import NftList from "@/components/nft/NftList";
import Web3 from "web3";
import {ABI_CONTRACT} from "@/const";
import PageLoader from "@/components/utils/PageLoader";
import axios from "axios";

export default {
  name: 'GalleryView',
  components: {
    PageLoader,
    NftCard,
    NftList,
    Nav,
  },
  async created() {
    if (window.ethereum) {
      window.ethereum.request({method: 'eth_requestAccounts'}).then(async () => {
        console.log('Connected to MetaMask!')
        this.provider = new Web3(window.ethereum)
        this.contract = new this.provider.eth.Contract(ABI_CONTRACT, process.env.VUE_APP_WEB3_CONTRACT_ADDRESS)
        await this.loadAllNfts()
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
      nfts: [],
      loading: true,
      searchQuery: ''
    }
  },
  methods: {
    async loadAllNfts() {
      const account = this.getAccount()

      if (account) {
        const totalSupply = await this.contract.methods.totalSupply().call()
        for (let i = 0; i < totalSupply; i++) {
          const tokenId = await this.contract.methods.tokenByIndex(i).call()
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

      this.loading = false
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
  computed: {
    nftsFiltered() {
      return [...this.nfts].filter(x => x.author.includes(this.searchQuery) || x.description.includes(this.searchQuery))
    }
  }
}
</script>

<template>
  <div>
    <div class="mt-5">
      <div class="container">
        <div class="row">
          <div class="col-lg-12">
            <div class="platform-info text-center">
              <h1>The OpenNFT marketplace for communities 🔥</h1>
              <p class="text-muted">Create. Own. Sell. Buy.</p>
              <div class="search mt-3">
                <form @submit.prevent>
                  <div class="input-group">
                    <input :value="searchQuery" @input="(event) => this.searchQuery = event.target.value"
                           class="form-control border rounded-pill" type="search" placeholder="Search among NFTs..."
                           id="search-input">
                    <button class="btn bg-white border-bottom-0 rounded-pill ms-n5"
                            type="button">
                      <i class="fa fa-search"></i>
                    </button>
                  </div>
                </form>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="gallery">
      <div class="container">
        <div class="row">
          <div class="col-lg-12 text-left mt-5">
            <h1 class="font-weight-bold">Gallery 🌈</h1>
          </div>
        </div>

        <NftList class="mb-5" v-if="!loading && searchQuery.length === 0" :nfts="nfts" v-bind:selling-mode="true"/>
        <NftList class="mb-5" v-else-if="!loading && searchQuery.length > 0" :nfts="nftsFiltered"
                 v-bind:selling-mode="true"/>
        <PageLoader v-else/>
      </div>
    </div>
  </div>
</template>

<style scoped>
div.platform-info {
  margin: 0 auto;
  width: 50%;
}
</style>
