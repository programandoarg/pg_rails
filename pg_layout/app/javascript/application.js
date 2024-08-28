import './config'
import './channels'
import './controllers'
import './elements'

import { Turbo } from '@hotwired/turbo-rails'

document.addEventListener('pg:record-created', (ev) => {
  Turbo.visit(window.location)
  setTimeout(() => {
    Turbo.cache.clear()
  }, 1000)
})

document.addEventListener('pg:record-updated', (ev) => {
  Turbo.visit(window.location)
  setTimeout(() => {
    Turbo.cache.clear()
  }, 1000)
})

document.addEventListener('pg:record-destroyed', (ev) => {
  Turbo.visit(window.location)
  setTimeout(() => {
    Turbo.cache.clear()
  }, 1000)
})

document.addEventListener('turbo:before-fetch-request', (ev) => {
  // Si es POST, quito la opción text/vnd.turbo-stream.html para que
  // on successful redirect no haya posibilidad de que se abra un modal
  if (ev.detail.fetchOptions.method === 'post') {
    ev.detail.fetchOptions.headers.Accept = "text/html, application/xhtml+xml"
  }

  if (document.querySelector('.modal.show')) {
    ev.detail.fetchOptions.headers['Modal-Opened'] = true
  }
})
