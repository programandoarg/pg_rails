import { Controller } from '@hotwired/stimulus'
import * as React from "react"
import { renderToStaticMarkup } from "react-dom/server"

export default class extends Controller {
  static outlets = ['modal']

  lastValue = null
  result = null
  elemId = null
  input = null

  connect (e) {
    console.log('connect asociable')
    const that = this

    // ID único para identificar el campo y el modal
    this.elemId = Math.trunc(Math.random() * 1000000000)

    this.input = this.element.querySelector('input[type=text]')

    this.element.setAttribute('data-asociable-modal-outlet', `.modal-${this.elemId}`)
    this.element.classList.add(`asociable-${this.elemId}`)

    this.result = document.createElement('div')
    // FIXME: resultados-inline
    this.result.setAttribute('id', `resultados-inline-${this.elemId}`)
    this.result.classList.add('resultados-wrapper')
    this.input.parentNode.appendChild(this.result);

    const modalLink = this.element.querySelector('.modal-link')
    const path = modalLink.attributes.href.value
    modalLink.setAttribute('href', `${path}?id=${this.elemId}`)
    modalLink.onclick = (e) => {
      // Si ya hay un modal abierto lo abro y evito que se haga el get
      // Si no, dejo que se ejecute el comportamiento por default
      if (that.modalOutlets.length > 0) {
        e.preventDefault()
        that.modalOutlet.openModal()
      }
    }
    const input = this.element.querySelector('input[type=text]')
    if (input.value) {
      this.element.classList.add('filled')
    }
    this.element.querySelector('.pencil').onclick = (e) => {
      console.log("pencil")
      input.focus()
    }


    const debounce = function (callback, wait) {
      let timerId
      return (...args) => {
        clearTimeout(timerId)
        timerId = setTimeout(() => {
          callback(...args)
        }, wait)
      }
    }
    const doSearchBounce = debounce((force) => {
      that.doSearch(force)
    }, 200)

    this.input.addEventListener('blur', (e) => {
      this.input.placeholder = ''
    })
    this.input.onfocus = (e) => {
      this.input.select()
      if (this.input.value.length === 0) {
        this.escribiAlgo()
      }
    }
    this.input.onkeyup = (e) => {
      if (this.input.value.length === 0) {
        this.escribiAlgo()
      }
      if (e.keyCode === 13) {
        doSearchBounce(true)
      } else {
        doSearchBounce()
      }
    }
    this.input.onkeydown = (e) => {
      if (e.keyCode === 13) {
        e.preventDefault()
        return false
      }
    }
  }

  crearItem() {
    const modalLink = this.element.querySelector('.modal-link')
    const url = modalLink.attributes.href.value
    let elem = (
      <form method="get" action={url} data-turbo-stream="true">
        <input type="hidden" name="id" value={this.elemId} />
      </form>
    )
    let form = document.createElement('div')
    form.innerHTML = renderToStaticMarkup(elem)
    document.body.prepend(form)
    form.childNodes[0].requestSubmit()
    form.remove()
  }

  escribiAlgo () {
    this.input.placeholder = 'Escribí algo para buscar'
  }

  buscando () {
    this.result.innerHTML = renderToStaticMarkup(
      <div className="resultados" tabIndex={-1}>
        <div className="fst-italic text-secondary">Buscando...</div>
      </div>
    )
  }

  selectItem (e) {
    if(e.target.dataset.object) {
      this.completarCampo(JSON.parse(e.target.dataset.object))
    } else {
      this.completarCampo(null)
    }
    this.result.innerHTML = ''
  }


  doSearch (force = false) {
    if (!force && this.input.value.length < 3) {
      return
    }
    if (!force && this.input.value === this.lastValue) {
      return
    }
    this.lastValue = this.input.value

    const timerId = setTimeout(() => {
      this.buscando()
    }, 200)
    document.addEventListener('turbo:before-stream-render', function (e) {
      clearTimeout(timerId)
    })
    let elem = (
      <form method="post" action={this.input.dataset.url} data-turbo-stream="true">
        <input type="hidden" name="id" value={this.elemId} />
        <input type="hidden" name="partial" value="pg_associable/resultados_inline" />
        <input type="hidden" name="resultados" value="resultados-inline" />
        <input type="hidden" name="query" value={this.input.value} />
      </form>
    )
    let form = document.createElement('div')
    form.innerHTML = renderToStaticMarkup(elem)
    document.body.prepend(form)
    form.childNodes[0].requestSubmit()
    form.remove()
  }

  completarCampo (object) {
    const textField = this.element.querySelector('input[type=text]')
    const hiddenField = this.element.querySelector('input[type=hidden]')
    if (object) {
      hiddenField.value = object.id
      textField.value = object.to_s
      this.element.classList.add('filled')
      this.element.dataset.object = object
      const event = new CustomEvent("pg_associable:changed", { detail: object });
      this.element.dispatchEvent(event)
    } else {
      textField.value = null
      hiddenField.value = null
      this.element.classList.remove('filled')
      this.element.dataset.object = null
      const event = new CustomEvent("pg_associable:changed");
      this.element.dispatchEvent(event)
    }
    this.result.innerHTML = ''
  }

  disconnect (e) {
    console.log('disconnect asociable')
  }
}
