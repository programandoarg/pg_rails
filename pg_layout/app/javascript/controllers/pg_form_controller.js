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
      const invalidFeedback = document.querySelector('.invalid-feedback')
      if (!invalidFeedback) {
        console.error(notBaseErrors.dataset.errors)
        Rollbar.error(notBaseErrors.dataset.errors)
        const errorTitle = this.element.querySelector('.error-title')
        errorTitle.innerText = 'Lo lamentamos mucho pero ocurrió algo inesperado. Por favor, intentá nuevamente o ponete en contacto con nosotros.'
        // FIXME: link a contacto
      }
    }
  }
}
