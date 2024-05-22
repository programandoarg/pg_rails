import { Controller } from '@hotwired/stimulus'
import * as React from 'react'
import { renderToStaticMarkup } from 'react-dom/server'

export default class extends Controller {
  static outlets = ['modal']

  lastValue = null
  subWrapper = null
  elemId = null
  input = null
  originalPlaceholder = null
  savedInputState = null

  connect () {
    // ID único para identificar el campo y el modal
    this.elemId = Math.trunc(Math.random() * 1000000000)

    this.input = this.element.querySelector('input[type=text]')

    this.element.setAttribute('data-asociable-modal-outlet', `.modal-${this.elemId}`)
    this.element.classList.add(`asociable-${this.elemId}`)

    const result = document.createElement('div')
    result.classList.add('resultados-wrapper')
    this.subWrapper = document.createElement('div')
    this.subWrapper.setAttribute('id', `resultados-inline-${this.elemId}`)
    this.subWrapper.classList.add('sub-wrapper')
    this.subWrapper.classList.add('position-absolute')
    this.subWrapper.classList.add('z-1')
    result.appendChild(this.subWrapper)
    this.input.parentNode.appendChild(result)

    const callback = (mutationList) => {
      for (const mutation of mutationList) {
        if (mutation.type === 'childList') {
          this.autoScroll()
        }
      }
    }
    const observer = new MutationObserver(callback)
    const config = { attributes: false, childList: true, subtree: true }
    observer.observe(this.subWrapper, config)

    this.resetResultados()

    const input = this.element.querySelector('input[type=text]')
    this.originalPlaceholder = input.placeholder
    const hiddenField = this.element.querySelector('input[type=hidden]')
    if (hiddenField.value) {
      this.element.classList.add('filled')
      input.setAttribute('readonly', 'true')
    }
    this.element.querySelector('.pencil').onclick = () => {
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
      this.doSearch(force)
    }, 900)

    this.input.addEventListener('blur', () => {
      this.input.placeholder = this.originalPlaceholder
      if (!this.element.classList.contains('filled')) {
        this.savedInputState = this.input.value
        this.input.value = null
      }
    })
    this.input.onfocus = () => {
      if (this.savedInputState && !this.input.value) {
        this.input.value = this.savedInputState
      }
      this.input.select()
      if (this.input.value.length === 0) {
        this.escribiAlgo()
      }
      this.autoScroll()
    }
    this.input.onkeyup = (e) => {
      if (this.input.value.length === 0) {
        this.escribiAlgo()
      }

      if ([37, 38, 39, 40].includes(e.keyCode)) {
        // Arrow keys, do nothing
      } else {
        if ([27].includes(e.keyCode)) {
          // ESC
          document.activeElement?.blur && document.activeElement.blur()
        } else {
          if (e.keyCode === 13) { // Enter
            doSearchBounce(true)
          } else {
            doSearchBounce()
          }
        }
      }
    }
    this.input.onkeydown = (e) => {
      if (e.keyCode === 13) { // Enter
        e.preventDefault()
        return false
      }
      if (this.element.classList.contains('filled')) {
        if (e.keyCode === 8 || e.keyCode === 46) { // Supr or Backspace
          this.completarCampo(null)
        }
      }
    }
    this.setMaxHeight()
  }

  autoScroll () {
    if (!this.element.closest('.modal')) {
      const wHeight = window.visualViewport.height
      const scrollTop = document.scrollingElement.scrollTop
      const viewPortBottom = scrollTop + wHeight
      const swHeight = parseInt(this.subWrapper.getBoundingClientRect().height) + 20
      const inputBottom = this.input.getBoundingClientRect().bottom + scrollTop
      const swBottom = inputBottom + swHeight

      if (swBottom > viewPortBottom) {
        const offset = swBottom - viewPortBottom
        document.scrollingElement.scroll({ top: scrollTop + offset })
      }
    }
  }

  resetResultados () {
    this.lastValue = null
    const rows = []
    if (this.element.dataset.puedeCrear) {
      rows.push(
        <a key="new" href="javascript:void(0)"
           className="list-group-item"
           data-action="asociable#crearItem"
        >
          Nuevo
        </a>
      )
    }
    if (this.element.dataset.preload) {
      JSON.parse(this.element.dataset.preload).forEach((object) => {
        rows.push(
          <a key={object.id} href="javascript:void(0)"
             className="list-group-item"
             data-action="asociable#selectItem"
             data-id={object.id}
             data-object={JSON.stringify(object)}
          >
            {object.to_s}
          </a>
        )
      })
    }
    this.subWrapper.innerHTML = renderToStaticMarkup(
      <div className="resultados" tabIndex={-1}>
        <ul className="list-group list-group-flush">
          {rows}
        </ul>
      </div>
    )
  }

  mostrarError () {
    if (this.element.querySelector('.resultados .spinner-border')) {
      Rollbar.error('Time out de asociable.js')
      // TODO: link a contacto
      this.subWrapper.innerHTML = renderToStaticMarkup(
        <div className="resultados" tabIndex={-1}>
          <div className="text-center p-2 text-danger d-flex align-items-center">
            <i className="bi-exclamation-circle me-2"></i>
            Ocurrió algo inesperado. Por favor, intentá nuevamente o ponete en contacto con nosotros.
          </div>
        </div>
      )
    }
  }

  setMaxHeight () {
    let maxHeight
    if (!this.element.closest('.modal')) {
      const scrollTop = document.scrollingElement.scrollTop
      const inputY = this.input.getBoundingClientRect().bottom + scrollTop
      const bodyHeight = document.body.getBoundingClientRect().height
      maxHeight = bodyHeight - inputY
      if (maxHeight < 200) {
        maxHeight = 200
      }
      if (maxHeight > 400) {
        maxHeight = 400
      }
      if (bodyHeight < inputY + maxHeight) {
        document.body.style.height = `${inputY + maxHeight}px`
      }
    } else {
      maxHeight = 200
    }
    this.subWrapper.style.maxHeight = `${maxHeight - 20}px`
  }

  crearItem () {
    // Si ya hay un modal abierto lo abro y retorno
    if (this.modalOutlets.length > 0) {
      this.modalOutlet.openModal()
      return
    }

    const elem = (
      <form method="get" action={this.input.dataset.urlModal} data-turbo-stream="true">
        <input type="hidden" name="id" value={this.elemId} />
      </form>
    )
    const form = document.createElement('div')
    form.innerHTML = renderToStaticMarkup(elem)
    document.body.prepend(form)
    form.childNodes[0].requestSubmit()
    form.remove()
  }

  escribiAlgo () {
    this.input.placeholder = this.element.dataset.placeholder || 'Escribí algo para buscar'
  }

  buscando () {
    this.subWrapper.innerHTML = renderToStaticMarkup(
      <div className="resultados text-center p-2" tabIndex={-1}>
        <span className="spinner-border" role="status"></span>
      </div>
    )
  }

  selectItem (e) {
    if (e.target.dataset.object) {
      this.completarCampo(e.target)
    } else {
      this.completarCampo(null)
    }
  }

  doSearch (force = false) {
    if (this.element.classList.contains('filled')) {
      return
    }
    if (!force && this.input.value.length < 3) {
      this.resetResultados()
      return
    }
    if (!force && this.input.value === this.lastValue) {
      return
    }
    this.lastValue = this.input.value

    const timerBuscandoId = setTimeout(() => {
      // console.log(`timed out ${timerBuscandoId}`)
      this.buscando()
    }, 200)
    // console.log(`setTimeOut ${timerBuscandoId}`)
    document.addEventListener('turbo:before-stream-render', (i) => {
      // console.log(`clear before stream render ${timerBuscandoId}`)
      clearTimeout(timerBuscandoId)
    }, { once: true })
    const timerErrorId = setTimeout(() => {
      this.mostrarError()
    }, 15000)
    const timeouts = `${timerBuscandoId},${timerErrorId}`

    const elem = (
      <form method="post" action={this.input.dataset.urlSearch} data-turbo-stream="true">
        <input type="hidden" name="id" value={this.elemId} />
        <input type="hidden" name="query" value={this.input.value} />
        <input type="hidden" name="timeout_id" value={timeouts} />
        <input type="hidden" name="puede_crear" value={this.element.dataset.puedeCrear} />
      </form>
    )
    const form = document.createElement('div')
    form.innerHTML = renderToStaticMarkup(elem)
    document.body.prepend(form)
    form.childNodes[0].requestSubmit()
    form.remove()
  }

  completarCampo (target) {
    // FIXME: savedInputState = null
    const textField = this.element.querySelector('input[type=text]')
    const hiddenField = this.element.querySelector('input[type=hidden]')

    if (target && target.dataset.fieldName) { hiddenField.name = target.dataset.fieldName }

    if (target) {
      const object = JSON.parse(target.dataset.object)
      hiddenField.value = object.id
      textField.value = object.to_s
      textField.setAttribute('readonly', 'true')
      this.element.classList.add('filled')
      this.element.dataset.object = object
      const event = new CustomEvent('pg_associable:changed', { detail: object })
      this.element.dispatchEvent(event)
    } else {
      hiddenField.value = null
      textField.value = null
      textField.removeAttribute('readonly')
      this.element.classList.remove('filled')
      this.element.dataset.object = null
      const event = new CustomEvent('pg_associable:changed')
      this.element.dispatchEvent(event)
    }
    this.resetResultados()
  }
}
