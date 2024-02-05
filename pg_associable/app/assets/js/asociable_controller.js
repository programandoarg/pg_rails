import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static outlets = ['modal']

  lastValue = null

  connect (e) {
    console.log('connect asociable')

    // ID único para identificar el campo y el modal
    const elemId = Math.trunc(Math.random() * 1000000000)
    this.element.setAttribute('data-asociable-modal-outlet', `.modal-${elemId}`)
    this.element.classList.add(`asociable-${elemId}`)

    const that = this
    const modalLink = this.targets.element.querySelector('.modal-link')
    const path = modalLink.attributes.href.value
    modalLink.setAttribute('href', `${path}?id=${elemId}`)
    modalLink.onclick = (e) => {
      // Si ya hay un modal abierto lo abro y evito que se haga el get
      // Si no, dejo que se ejecute el comportamiento por default
      if (that.modalOutlets.length > 0) {
        e.preventDefault()
        that.modalOutlet.openModal()
      }
    }
    const input = this.element.querySelector('input[type=text]')
    if(input.value) {
      this.element.classList.add('filled')
    }

  }


  selectItem (e) {
    // TODO: text en data
    this.completarCampo(e.target.dataset.id, e.target.text)
  }
  completarCampo (id, text) {
    const textField = this.element.querySelector('input[type=text]')
    const hiddenField = this.element.querySelector('input[type=hidden]')
    if( id === undefined ) {
      id = null
    }
    hiddenField.value = id
    if (id) {
      textField.value = text
      this.element.classList.add('filled')
    } else {
      textField.value = null
      this.element.classList.remove('filled')
    }
  }

  disconnect (e) {
    console.log('disconnect asociable')
  }
}
