<script>
export default {
  name: 'NftLoader'
}
</script>

<template>
  <div>
    <div class="modal nft-loader" tabindex="-1" role="dialog">
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <div class="modal-body">
            <img class="img-loader" src="https://i.pinimg.com/originals/3e/f0/e6/3ef0e69f3c889c1307330c36a501eb12.gif" alt="loader">
          </div>
          <div class="text-center mb-2">
            <h1>🌠🌠🌠</h1>
            <h5 class="modal-title">Magic of blockchain is happening...</h5>
          </div>
        </div>
      </div>
    </div>
    <div class="popup-fade"></div>
  </div>
</template>

<style scoped>
div.nft-loader {
  display: block;
  border: none;
}

.popup-fade:before {
  content: '';
  background: #000;
  position: fixed;
  left: 0;
  top: 0;
  width: 100%;
  height: 100%;
  opacity: 0.3;
  z-index: 1;
}

img.img-loader {
  max-width: 100%;
  width: 45px;
  height: 45px;
}
</style>