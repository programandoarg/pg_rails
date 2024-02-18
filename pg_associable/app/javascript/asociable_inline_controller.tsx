import { Controller } from '@hotwired/stimulus'
import * as React from "react"
import { renderToStaticMarkup } from "react-dom/server"

export default class extends Controller {
  static outlets = ['modal']

  result = null
  elemId = null
  input = null
  lastValue = ''
  connect () {
    console.log('connect asociable_inline')
    const that = this
    // ID único para identificar el campo y el modal
    this.input = this.element.querySelector('input[type=text]')
    this.elemId = Math.trunc(Math.random() * 1000000000)
    this.element.classList.add(`asociable-${this.elemId}`)
    this.result = document.createElement('div')
    this.result.setAttribute('id', `resultados-${this.elemId}`)
    this.result.classList.add('resultados-wrapper')
    this.input.parentNode.appendChild(this.result);
    (this.element.querySelector('.pencil') as HTMLElement).onclick = (e) => {
      that.input.focus()
    }
    if (this.input.value) {
      this.element.classList.add('filled')
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

  buscando () {
    this.result.innerHTML = renderToStaticMarkup(
      <div className="resultados" tabIndex={-1}>
        <div className="fst-italic text-secondary">Buscando...</div>
      </div>
    )
  }

  escribiAlgo () {
    this.input.placeholder = 'Escribí algo para buscar'
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
    const textField = this.element.querySelector('input[type=text]') as HTMLInputElement
    const hiddenField = this.element.querySelector('input[type=hidden]') as HTMLInputElement
    if (object) {
      this.element.classList.add('filled')
      hiddenField.value = object.id
      textField.value = object.to_s
      const event = new CustomEvent("pg_associable:changed", { detail: object });
      this.element.dispatchEvent(event)
    } else {
      this.element.classList.remove('filled')
      hiddenField.value = null
      textField.value = null
      const event = new CustomEvent("pg_associable:changed");
      this.element.dispatchEvent(event)
    }
  }

  selectItem (e) {
    if(e.target.dataset.object) {
      this.completarCampo(JSON.parse(e.target.dataset.object))
    } else {
      this.completarCampo(null)
    }
    this.result.innerHTML = ''
  }

  disconnect () {
    console.log('disconnect asociable_inline')
  }
}
