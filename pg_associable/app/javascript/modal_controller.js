import { Controller } from '@hotwired/stimulus'
import * as bootstrap from 'bootstrap'

export default class extends Controller {
  static outlets = ['asociable']

  modalPuntero = null
  history = []

  connect (e) {
    this.modalPuntero = new bootstrap.Modal(this.element)
    if (this.element.dataset.removeOnHide) {
      this.element.addEventListener('hidden.bs.modal', (e) => {
        this.element.remove()
      })
    }
    this.modalPuntero.show()

    this.element.addEventListener('turbo:frame-render', (ev) => {
      if (ev.detail.fetchResponse.response.ok && ev.target.id === 'modal_content') {
        this.history.push(ev.target.src)
      }
    })

    this.element.addEventListener('pg:record-created', (ev) => {
      const el = ev.data
      if (this.asociableOutlets.length > 0) {
        const newObject = JSON.parse(el.dataset.response)
        this.asociableOutlet.completarCampo(newObject)
        ev.stopPropagation()
      }
      this.back(ev)
    })

    this.element.addEventListener('pg:refresh-frame', (ev) => {
      this.back(ev)
    })

    this.element.addEventListener('pg:record-updated', (ev) => {
      this.back(ev)
    })

    this.element.addEventListener('pg:record-destroyed', (ev) => {
      this.back(ev)
    })

    document.addEventListener('turbo:before-cache', () => {
      this.element.remove()
    }, { once: true })
  }

  back (ev) {
    this.history.pop()
    // FIXME: esto no funciona, si voy al edit y luego al show y luego al destroy, vuelve al edit
    if (this.history.length > 0) {
      const url = this.history[this.history.length - 1]
      const frame = this.element.querySelector('#modal_content')
      frame.src = url
      frame.innerHTML = '<div style="min-height: 30em">Cargando...</div>'
      ev.stopPropagation()
    } else {
      this.modalPuntero.hide()
    }
  }

  openModal () {
    this.modalPuntero.show()
  }

  remove () {
    this.element.remove()
  }

  disconnect (e) {
    this.modalPuntero.hide()
    document.dispatchEvent(new Event('hidden.bs.modal'))
    this.modalPuntero.dispose()
  }
}
