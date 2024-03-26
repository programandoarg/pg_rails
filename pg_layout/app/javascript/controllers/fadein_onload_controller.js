import { Controller } from '@hotwired/stimulus'

// To be used by img_placeholder helper
export default class extends Controller {
  connect () {
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
