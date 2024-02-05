// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import './controllers'
import * as bootstrap from 'bootstrap'

// TODO: unificar un pg_rails.js
import './../../../../pg_associable'
import './../../../../pg_layout'

// Bootstrap's toasts
document.addEventListener('turbo:load', function () {
  const toastElList = document.querySelectorAll('.toast:not(.hide):not(.show)')
  Array.from(toastElList).map(toastEl => new bootstrap.Toast(toastEl).show())

  // Select the node that will be observed for mutations
  const targetNode = document.getElementById('flash')

  // Options for the observer (which mutations to observe)
  const config = { attributes: true, childList: true, subtree: true }

  // Callback function to execute when mutations are observed
  const callback = (mutationList, observer) => {
    for (const mutation of mutationList) {
      if (mutation.type === 'childList') {
        console.log('A child node has been added or removed.')
        const toastElList = document.querySelectorAll('.toast:not(.hide):not(.show)')
        Array.from(toastElList).map(toastEl => new bootstrap.Toast(toastEl).show())
      } else if (mutation.type === 'attributes') {
        console.log(`The ${mutation.attributeName} attribute was modified.`)
      }
    }
  }

  // Create an observer instance linked to the callback function
  const observer = new MutationObserver(callback)

  // Start observing the target node for configured mutations
  observer.observe(targetNode, config)
})
