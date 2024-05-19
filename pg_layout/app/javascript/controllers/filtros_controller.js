import { Controller } from '@hotwired/stimulus'

// Connects to data-controller="switcher"
export default class extends Controller {
  originalText = null
  textEl = null

  connect () {
    this.textEl = this.element.querySelector('.text')
    this.originalText = this.textEl.textContent
    this.element.addEventListener('click', () => { this.cambiarTexto() })
    this.cambiarTexto()
  }

  cambiarTexto () {
    if (this.element.getAttribute('aria-expanded') == 'true') {
      this.textEl.textContent = this.element.dataset.expandedText
    } else {
      this.textEl.textContent = this.originalText
    }
  }
}
