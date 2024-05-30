// Es necesario que el consumer se setee antes de cargar la librería
// para que lo tomen los TurboCableStreamSourceElement's

import './set_consumer'

import '@hotwired/turbo-rails'

// TODO: testear con capybara
document.addEventListener('turbo:before-cache', () => {
  document.querySelectorAll('#flash .alert').forEach((el) => {
    el.remove()
  })
  document.querySelectorAll('.offcanvas-backdrop').forEach((el) => {
    el.remove()
  })
  document.querySelectorAll('.offcanvas').forEach((el) => {
    el.classList.remove('show')
  })
})

// document.addEventListener('turbo:before-stream-render', function () { console.log('turbo:before-stream-render') })
// document.addEventListener('turbo:render', function () { console.log('turbo:render') })
// document.addEventListener('turbo:before-render', function () { console.log('turbo:before-render') })
// document.addEventListener('turbo:before-frame-render', function () { console.log('turbo:before-frame-render') })
// document.addEventListener('turbo:frame-load', function () { console.log('turbo:frame-load') })
// document.addEventListener('turbo:before-fetch-request', function () { console.log('turbo:before-fetch-request') })
// document.addEventListener('turbo:fetch-request-error', function () { console.log('turbo:fetch-request-error') })
