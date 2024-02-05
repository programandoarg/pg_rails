import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static outlets = ['asociable']
  static targets = ['response', 'result']

  modalPuntero = null
  input = null
  lastValue = ''

  connect (e) {
    console.log('ModalController connected')
    const modal = this.targets.element
    this.modalPuntero = new bootstrap.Modal(modal)
    this.modalPuntero.show()

    this.input = this.element.querySelector('input[type=text]')

    let debounce = function(callback, wait) {
      let timerId;
      return (...args) => {
        clearTimeout(timerId);
        timerId = setTimeout(() => {
          callback(...args);
        }, wait);
      };
    }
    const doSearchBounce = debounce(() => {
      this.doSearch()
    }, 200)
    this.input.onkeyup = (e) => {
      doSearchBounce()
      // if(this.input.value.length == 0) {
      //   this.escribiAlgo()
      // }
    }
  }

  buscando() {
    this.resultTarget.innerHTML = `
<ul class="resultados list-group list-group-flush" tabindex="-1">
  <li class="list-group-item">
    <span class="fst-italic text-secondary">Buscando...</span>
  </li>
</ul>
`
  }
  doSearch() {
    if(this.input.value.length < 3) {
      return
    }
    if(this.input.value == this.lastValue) {
      return
    }
    this.lastValue = this.input.value

    let timerId = setTimeout(() => {
      this.buscando()
    }, 200)
    document.addEventListener("turbo:before-stream-render", function(e) {
      clearTimeout(timerId)
    })
    this.element.querySelector('form').requestSubmit()
    // let url = `${this.input.dataset.url}?id=${this.elemId}`
    // const form = document.createElement('form')
    // form.setAttribute('method', 'post')
    // form.setAttribute('action', url)
    // form.setAttribute('data-turbo-stream', true)
    // let partial = document.createElement('input')
    // partial.setAttribute('type', 'hidden')
    // partial.setAttribute('name', 'partial')
    // partial.setAttribute('value', 'pg_associable/resultados_inline')
    // form.appendChild(partial)
    // let query = document.createElement('input')
    // query.setAttribute('type', 'hidden')
    // query.setAttribute('name', 'query')
    // query.setAttribute('value', this.input.value)
    // form.appendChild(query)
    // document.body.prepend(form)
    // form.requestSubmit()
    // form.remove()
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
