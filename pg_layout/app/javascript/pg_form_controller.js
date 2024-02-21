import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  connect () {
    this.element.querySelectorAll('.form-select, .form-control').forEach((slct) => {
      slct.addEventListener('change', (e) => {
        if (e.target.value) {
          slct.classList.remove('is-invalid')
        }
      })
    })
  }
}
