import { Controller } from '@hotwired/stimulus'
import * as bootstrap from 'bootstrap'

export default class extends Controller {
  static outlets = ['asociable']
  static targets = ['response', 'result', 'searchInput', 'searchForm']

  modalPuntero = null
  lastValue = ''

  connect (e) {
    console.log('ModalController connected')
    const modal = this.targets.element
    this.modalPuntero = new bootstrap.Modal(modal)
    this.modalPuntero.show()

    if (this.searchInputTargets.length > 0) {
      this.bindSearchInput()
    }
  }

  debounce (callback, wait) {
    let timerId
    return (...args) => {
      clearTimeout(timerId)
      timerId = setTimeout(() => {
        callback(...args)
      }, wait)
    }
  }

  bindSearchInput () {
    const doSearchBounce = this.debounce((force) => {
      this.doSearch(force)
    }, 200)
    this.searchInputTarget.onkeydown = (e) => {
      if (e.keyCode === 13) {
        e.preventDefault()
        return false
      }
    }
    this.searchInputTarget.onkeyup = (e) => {
      if (e.keyCode === 13) {
        doSearchBounce(true)
      } else {
        doSearchBounce()
      }
    }
  }

  buscando () {
    this.resultTarget.innerHTML = `
<ul class="resultados list-group list-group-flush" tabindex="-1">
  <li class="list-group-item">
    <span class="fst-italic text-secondary">Buscando...</span>
  </li>
</ul>
`
  }

  doSearch (force = false) {
    if (!force && this.searchInputTarget.value.length < 3) {
      return
    }
    if (!force && this.searchInputTarget.value === this.lastValue) {
      return
    }
    this.lastValue = this.searchInputTarget.value

    const timerId = setTimeout(() => {
      this.buscando()
    }, 200)
    document.addEventListener('turbo:before-stream-render', function (e) {
      clearTimeout(timerId)
    })
    this.searchFormTarget.requestSubmit()
  }

  selectItem (e) {
    const asociable = this.asociableOutlet
    // TODO: text en data
    asociable.completarCampo(e.target.dataset.id, e.target.text)
    this.remove()
  }

  responseTargetConnected (e) {
    const newObject = JSON.parse(e.dataset.response)
    const asociable = this.asociableOutlet
    asociable.completarCampo(newObject.id, newObject.to_s)
    this.remove()
  }

  remove () {
    this.targets.element.remove()
  }

  openModal () {
    this.modalPuntero.show()
  }

  toggleCrearElegir (e) {
    const content = this.element.querySelector('.modal-content')
    const state = content.dataset.state
    const newValue = state === 'new-item' ? 'select-item' : 'new-item'
    content.setAttribute('data-state', newValue)
  }

  disconnect (e) {
    console.log('ModalController disconnected')
    this.modalPuntero.dispose()
    document.querySelectorAll('.modal-backdrop').forEach(e => { e.remove() })
  }

  buscar () {
    alert('buscar')
  }
}
