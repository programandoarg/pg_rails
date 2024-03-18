import { Controller } from '@hotwired/stimulus'

// Connects to data-controller="fadein_onload"
// Should add style: "display:none" to root element
export default class extends Controller {
  connect () {
    // this.element.classList.remove('invisible')

    if (this.element.complete) {
      this.loaded()
    } else {
      this.element.addEventListener('load', () => {
        this.loaded()
      }, { once: true })
    }
  }

  loaded () {
    this.element.classList.add('fade-in')
    this.element.style.display = 'block'
    this.element.parentElement.classList.remove('placeholder')
  }
}
