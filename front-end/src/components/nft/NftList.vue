<script>
import NftCard from "@/components/nft/NftCard";

export default {
  name: 'NftList',
  components: {
    NftCard
  },
  props: {
    nfts: {
      type: Array,
      required: true
    },
    sellingMode: {
      type: Boolean,
      required: false,
      default: false
    }
  },
}
</script>

<template>
  <div v-if="nfts.length > 0" class="list-nfts">
    <NftCard v-for="nft in nfts" :author="nft.author" :description="nft.description"
             :prices="nft.prices"
             :img="nft.img" :sellingMode="sellingMode" :id="nft.id" :key="nft.id"/>
  </div>
  <div class="empty mt-5 text-center" v-else>
    <h1>🚀🌖🚀</h1>
    <h4 class="font-weight-bold">It's definitely time to buy something on the market!</h4>
    <p>Nothing to show...</p>
  </div>
</template>

<style scoped>
.list-nfts {
  display: flex;
  flex-wrap: wrap;
  margin-left: -0.9375rem;
  margin-right: -0.9375rem;
}
</style>