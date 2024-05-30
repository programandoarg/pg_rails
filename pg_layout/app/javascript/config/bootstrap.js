import * as bootstrap from 'bootstrap'

document.addEventListener('turbo:load', bindAndObserveToasts)
document.addEventListener('turbo:render', bindAndObserveToasts)

// TODO: testear con capybara
function bindToastElements () {
  const toastQuery = '.pg-toast:not(.hide):not(.show)'

  const toastElList = document.querySelectorAll(toastQuery)
  Array.from(toastElList).map(toastEl => {
    toastEl.addEventListener('hidden.bs.toast', () => {
      toastEl.remove()
    })
    return new bootstrap.Toast(toastEl).show()
  })
}

function bindAndObserveToasts () {
  bindToastElements()

  // Select the node that will be observed for mutations
  const targetNode = document.getElementById('flash')

  // Options for the observer (which mutations to observe)
  const config = { attributes: true, childList: true, subtree: true }

  // Callback function to execute when mutations are observed
  const callback = (mutationList, observer) => {
    for (const mutation of mutationList) {
      if (mutation.type === 'childList') {
        bindToastElements()
      }
    }
  }

  // Create an observer instance linked to the callback function
  const observer = new MutationObserver(callback)

  // Start observing the target node for configured mutations
  observer.observe(targetNode, config)
}
