import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static outlets = ['modal']

  result = null
  elemId = null
  input = null
  lastValue = ''
  connect (e) {
    console.log('connect asociable_inline')
    const that = this
    // ID único para identificar el campo y el modal
    this.input = this.element.querySelector('input[type=text]')
    this.elemId = Math.trunc(Math.random() * 1000000000)
    this.element.classList.add(`asociable-${this.elemId}`)
    this.result = document.createElement('div')
    this.result.setAttribute('id', `resultados-${this.elemId}`)
    this.result.classList.add('resultados-wrapper')
    this.input.parentNode.appendChild(this.result)
    this.input.parentNode.appendChild(this.result)
    this.element.querySelector('.pencil').onclick = (e) => {
      that.input.focus()
    }
    if(this.input.value) {
      this.element.classList.add('filled')
    }
    // const button = this.element.querySelector('button')

    // button.onclick = () => {
    //   // crear form, submitear y borrar

    // }

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
      that.doSearch()
    }, 200)

    this.input.addEventListener('blur', (e) => {
      this.input.placeholder = ""
      // this.element.classList.remove('focus')
      // setTimeout(() => {
      //   that.hideResults()
      // }, 100)
    })
    this.input.onfocus = (e) => {
      // this.element.classList.add('focus')
      this.input.select()
      if(this.input.value.length == 0) {
        this.escribiAlgo()
      }
      // this.showResults()
    }
    this.input.onkeyup = (e) => {
      doSearchBounce()
      if(this.input.value.length == 0) {
        this.escribiAlgo()
      }
    }
    this.input.onkeydown = (e) => {
      if(e.keyCode == 13) {
        doSearchBounce()
        e.preventDefault();
        return false;
      }
    }
  }
  // showResults() {
  //   this.result.style.display = 'block'
  // }
  // hideResults() {
  //   this.result.style.display = 'none'
  // }
  buscando() {
    this.result.innerHTML = `
<div class="resultados" tabindex="-1">
  <div class="fst-italic text-secondary">Buscando...</div>
</div>
`
  }
  escribiAlgo() {
    this.input.placeholder = "Escribí algo para buscar"
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
    let url = `${this.input.dataset.url}?id=${this.elemId}`
    const form = document.createElement('form')
    form.setAttribute('method', 'post')
    form.setAttribute('action', url)
    form.setAttribute('data-turbo-stream', true)
    let partial = document.createElement('input')
    partial.setAttribute('type', 'hidden')
    partial.setAttribute('name', 'partial')
    partial.setAttribute('value', 'pg_associable/resultados_inline')
    form.appendChild(partial)
    let query = document.createElement('input')
    query.setAttribute('type', 'hidden')
    query.setAttribute('name', 'query')
    query.setAttribute('value', this.input.value)
    form.appendChild(query)
    document.body.prepend(form)
    form.requestSubmit()
    form.remove()
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
      this.element.classList.remove('filled')
      textField.value = null
    }
  }

  selectItem (e) {
    console.log('select')
    // TODO: text en data
    this.completarCampo(e.target.dataset.id, e.target.text)
    this.result.innerHTML = ''
  }


  disconnect (e) {
    console.log('disconnect asociable_inline')
  }
}
