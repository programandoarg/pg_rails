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
    this.element.querySelectorAll('.btn-check').forEach((slct) => {
      slct.addEventListener('change', (e) => {
        let invalid = e.target.closest('.is-invalid')
        if (invalid) {
          invalid.classList.remove('is-invalid')
        }
      })
    })
    const errorTitle = this.element.querySelector('.error-title')
    if (errorTitle) {
      const invalidField = document.querySelector('.is-invalid')
      const baseAlert = document.querySelector('.alert-danger')
      if (!invalidField && !baseAlert) {
        const errorTitle = this.element.querySelector('.error-title')
        // TODO!: testear con capybara
        errorTitle.innerText = 'Ocurrió algo inesperado. Por favor, intentá nuevamente o ponete en contacto con nosotros.'
        // TODO!: link a contacto
        const form = this.element.querySelector('form')
        const errorMsg = `${form.id} - ${form.action} - ${form.dataset.errors}`
        console.error(errorMsg)
        Rollbar.error(errorMsg)
      }
    }
  }
}
