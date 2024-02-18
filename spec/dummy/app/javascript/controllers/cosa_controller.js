import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  connect () {
    this.element.querySelector('.cosa_categoria_de_cosa')
                .addEventListener('pg_associable:changed', (e) => {
                  if(e.detail) {
                    console.log(`Elegiste ${e.detail.nombre}`)
                  } else {
                    console.log("borraste las cosas")
                  }
                })
  }
}
