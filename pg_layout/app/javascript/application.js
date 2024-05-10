import Rollbar from 'rollbar'

import './config'
import './channels'
import './controllers'

// Bootstrap's toasts
import * as bootstrap from 'bootstrap'

let rollbarToken = document.head.querySelector('meta[name=rollbar-token]')
rollbarToken = rollbarToken && rollbarToken.content

let rollbarEnv = document.head.querySelector('meta[name=rollbar-env]')
rollbarEnv = rollbarEnv && rollbarEnv.content
rollbarEnv = rollbarEnv || 'unknown'

window.Rollbar = Rollbar

Rollbar.init()

Rollbar.global({
  itemsPerMinute: 2,
  maxItems: 5
})
Rollbar.configure({
  enabled: !!rollbarToken,
  accessToken: rollbarToken,
  captureUncaught: true,
  captureUnhandledRejections: true,
  reportLevel: 'warning',
  payload: {
    environment: rollbarEnv
  }
})

document.addEventListener('turbo:load', bindToasts)
document.addEventListener('turbo:render', bindToasts)

document.addEventListener('turbo:before-cache', () => {
  document.querySelectorAll('.offcanvas-backdrop').forEach((el) => {
    el.remove()
  })
  document.querySelectorAll('.offcanvas').forEach((el) => {
    el.classList.remove('show')
  })
})

function bindToasts () {
  const toastQuery = '.pg-toast:not(.hide):not(.show)'

  const toastElList = document.querySelectorAll(toastQuery)
  Array.from(toastElList).map(toastEl => { 
    new bootstrap.Toast(toastEl).show()
    toastEl.addEventListener('hidden.bs.toast', () => {
      toastEl.remove()
    })
  })

  // Select the node that will be observed for mutations
  const targetNode = document.getElementById('flash')

  // Options for the observer (which mutations to observe)
  const config = { attributes: true, childList: true, subtree: true }

  // Callback function to execute when mutations are observed
  const callback = (mutationList, observer) => {
    for (const mutation of mutationList) {
      if (mutation.type === 'childList') {
        // console.log('A child node has been added or removed.')
        const toastElList = document.querySelectorAll(toastQuery)
        Array.from(toastElList).map(toastEl => {
          new bootstrap.Toast(toastEl).show()
          toastEl.addEventListener('hidden.bs.toast', () => {
            toastEl.remove()
          })
        })
      } else if (mutation.type === 'attributes') {
        // console.log(`The ${mutation.attributeName} attribute was modified.`)
      }
    }
  }

  // Create an observer instance linked to the callback function
  const observer = new MutationObserver(callback)

  // Start observing the target node for configured mutations
  observer.observe(targetNode, config)
}

// document.addEventListener('turbo:before-stream-render', function () { console.log('turbo:before-stream-render') })
// document.addEventListener('turbo:render', function () { console.log('turbo:render') })
// document.addEventListener('turbo:before-render', function () { console.log('turbo:before-render') })
// document.addEventListener('turbo:before-frame-render', function () { console.log('turbo:before-frame-render') })
// document.addEventListener('turbo:frame-load', function () { console.log('turbo:frame-load') })
// document.addEventListener('turbo:before-fetch-request', function () { console.log('turbo:before-fetch-request') })
// document.addEventListener('turbo:fetch-request-error', function () { console.log('turbo:fetch-request-error') })
