import { Controller } from '@hotwired/stimulus'
import { fadeIn, fadeOut } from 'pg_rails/utils'

export default class extends Controller {
  connect () {
    const asociable = this.element.querySelector('.cosa_categoria_de_cosa')
    if (asociable) {
      asociable.addEventListener('pg_associable:changed', (e) => {
        if (e.detail) {
          console.log(`Elegiste ${e.detail.nombre}`)
        } else {
          console.log('borraste las cosas')
        }
      })
    }
  }

  doFadeIn () {
    fadeIn(this.element.querySelector('h1'))
  }

  doFadeOut () {
    fadeOut(this.element.querySelector('h1'))
  }
}
