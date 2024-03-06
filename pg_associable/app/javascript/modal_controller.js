import { Controller } from '@hotwired/stimulus'
import * as bootstrap from 'bootstrap'

export default class extends Controller {
  static outlets = ['asociable']
  static targets = ['response']

  modalPuntero = null

  connect (e) {
    this.modalPuntero = new bootstrap.Modal(this.element)
    this.modalPuntero.show()
  }

  responseTargetConnected (e) {
    const newObject = JSON.parse(e.dataset.response)
    this.asociableOutlet.completarCampo(newObject)
    this.element.remove()
  }

  openModal () {
    this.modalPuntero.show()
  }

  disconnect (e) {
    this.modalPuntero.hide()
    this.modalPuntero.dispose()
  }
}
