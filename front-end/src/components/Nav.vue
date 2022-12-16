<script>
import WalletWidget from "@/components/wallet/WalletWidget"

export default {
  name: 'Nav',
  components: {WalletWidget},
  props: {}
}
</script>

<template>
  <nav class="main-nav">
    <div class="container">
      <div class="row align-items-center">
        <div class="col-lg-4 text-left">
          <router-link to="/" class="navbar-brand">
            <img src="https://cryptologos.cc/logos/high-performance-blockchain-hpb-logo.png"
                 class="d-inline-block align-top project-logo" alt="Logo">
          </router-link>
        </div>
        <div class="col-lg-4 text-center">
          <router-link to="/">Market</router-link>
          <router-link to="/collection">My NFTs</router-link>
          <router-link to="/mint">Mint NFT</router-link>
        </div>
        <div class="col-lg-4 text-right">
          <WalletWidget/>
        </div>
      </div>
    </div>
  </nav>
</template>

<style scoped>

nav.main-nav {
  background: linear-gradient(90deg, #09C6F9, #045DE9);
  color: #fff;
  padding: 20px 30px;
}

nav a {
  font-weight: 300;
  color: #ffffff;
  margin-right: 15px;
}

nav a.router-link-exact-active {
  font-weight: bold;
  color: #ffffff;
}

.align-items-center {
  align-items: center;
}

img.project-logo {
  border-radius: 15px;
  height: 30px;
  width: 30px;
}
</style>