import { createRouter, createWebHistory } from 'vue-router'
import GalleryView from "@/views/GalleryView";
import MintNftView from "@/views/MintNftView";
import UserCollectionView from "@/views/UserCollectionView";

const routes = [
  {
    path: '/',
    name: 'gallery',
    component: GalleryView
  },
  {
    path: '/mint',
    name: 'mint',
    component: MintNftView
  },
  {
    path: '/collection',
    name: 'collection',
    component: UserCollectionView
  }
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes
})

export default router
