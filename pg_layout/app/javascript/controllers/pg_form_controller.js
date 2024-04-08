import { Controller } from '@hotwired/stimulus'
import Rollbar from 'rollbar'

export default class extends Controller {
  connect () {
    this.element.querySelectorAll('.form-select, .form-control').forEach((slct) => {
      slct.addEventListener('change', (e) => {
        if (e.target.value) {
          slct.classList.remove('is-invalid')
        }
      })
    })
    const notBaseErrors = this.element.querySelector('.not_base_errors')

    if (notBaseErrors) {
      const invalidFields = document.querySelector('.form-control.is-invalid,.form-select.is-invalid')
      if (!invalidFields) {
        console.error(notBaseErrors.dataset.errors)
        Rollbar.error(notBaseErrors.dataset.errors)
        const errorTitle = this.element.querySelector('.error-title')
        errorTitle.innerText = 'Lo lamentamos mucho pero ocurrió algo inesperado'
      }
    }
  }
}
