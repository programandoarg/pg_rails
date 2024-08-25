import './config'
import './channels'
import './controllers'
import './elements'

import { Turbo } from '@hotwired/turbo-rails'

document.addEventListener('pg:refresh-frame', (ev) => {
  Turbo.visit(window.location)
  setTimeout(() => {
    Turbo.cache.clear()
  }, 1000)
})

// FIXME: sirven de algo todos estos eventos?
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
  if (document.querySelector('.modal.show')) {
    ev.detail.fetchOptions.headers['Modal-Opened'] = true
  }
})
