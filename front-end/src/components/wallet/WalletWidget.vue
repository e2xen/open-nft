<script>
import Web3 from 'web3'

export default {
  name: 'WalletWidget',
  data() {
    return {
      account: null,
      provider: null
    }
  },
  async created() {
    await this.handleButton()
  },
  methods: {
    async handleButton() {
      try {
        this.initWeb3()
      } catch (e) {
        console.log('Error happened during web3 init')
        console.log(e)
      }
    },
    initWeb3() {
      if (window.ethereum) {
        window.ethereum.request({method: 'eth_requestAccounts'}).then(() => {
          console.log('Connected to MetaMask!')
          this.provider = new Web3(window.ethereum)
        }).catch((e) => {
          alert('Error: Not connected')
          console.log(e)
        })
      } else {
        alert('Error: MetaMask not found in the browser')
      }
    },
    async getAccount() {
      const accounts = await ethereum.request({method: 'eth_accounts'})

      if (accounts.length === 0) {
        alert("Error: Account couldn't be loaded")
      } else {
        this.account = accounts[0]
      }
    }
  },
  watch: {
    provider(val) {
      if (val !== undefined) {
        this.getAccount()
      }
    }
  }
}
</script>

<template>
  <div>
    <button @click="handleButton" class="btn btn-connect" v-if="!account">
      <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/3/36/MetaMask_Fox.svg/1200px-MetaMask_Fox.svg.png"
           alt="Metamask">
      Connect wallet
    </button>
    <button class="btn btn-connect" v-else>
      <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/3/36/MetaMask_Fox.svg/1200px-MetaMask_Fox.svg.png"
           alt="Metamask">
      Account: {{ account.substr(0, 8) }}...
    </button>
  </div>
</template>

<style scoped>
button.btn-connect {
  color: #1773eb;
  padding: 10px 20px;
  background: #ffffff;
  border-radius: 10px;
  font-weight: 700;
}

button.btn-connect img {
  width: 20px;
  height: 20px;
}
</style>