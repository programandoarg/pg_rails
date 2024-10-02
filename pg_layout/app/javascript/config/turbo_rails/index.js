// Es necesario que el consumer se setee antes de cargar la librería
// para que lo tomen los TurboCableStreamSourceElement's

import './set_consumer'
import './progress_bar'
import '@hotwired/turbo-rails'
import { flashMessage } from 'pg_rails/utils'
import Rollbar from 'rollbar'

// TODO: testear con capybara
document.addEventListener('turbo:before-cache', () => {
  document.querySelectorAll('#flash .alert').forEach((el) => {
    // FIXME: en los destroy desde main frame, turbo llama a before-cache
    // después de renderear el redirect, por eso no puedo hacer el remove
    //
    // el.remove()
  })
  document.querySelectorAll('.offcanvas-backdrop').forEach((el) => {
    el.remove()
  })
  document.querySelectorAll('.offcanvas').forEach((el) => {
    el.classList.remove('show')
  })
})

document.addEventListener('turbo:frame-missing', async (ev) => {
  const text = await ev.detail.response.text()
  Rollbar.error('turbo:frame-missing', text, ev.detail)
  console.error('turbo:frame-missing', text, ev.detail)
  ev.preventDefault()
  const html = `
    <div>
      <div class="mb-1">
        Ocurrió algo inesperado
      </div>
      Por favor, intentá nuevamente
      <br>
      o <a class="text-decoration-underline" href="/contacto" data-turbo="false">dejá un mensaje</a>
      para que te avisemos
      <br>
      cuando el problema esté resuelto 🙏
    </div>
  `

  flashMessage(html, 'alert')
})
// document.addEventListener('turbo:before-stream-render', function () { console.log('turbo:before-stream-render') })
// document.addEventListener('turbo:render', function () { console.log('turbo:render') })
// document.addEventListener('turbo:before-render', function () { console.log('turbo:before-render') })
// document.addEventListener('turbo:before-frame-render', function () { console.log('turbo:before-frame-render') })
// document.addEventListener('turbo:frame-load', function () { console.log('turbo:frame-load') })
// document.addEventListener('turbo:before-fetch-request', function () { console.log('turbo:before-fetch-request') })
// document.addEventListener('turbo:fetch-request-error', function () { console.log('turbo:fetch-request-error') })
