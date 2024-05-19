import { Controller } from '@hotwired/stimulus'

// Connects to data-controller="switcher"
export default class extends Controller {
  connect () {
    if (this.element.checked) {
      this.show()
    }
    this.element.setAttribute('data-action', `${this.element.getAttribute('data-action') || ''} switcher#show`)
  }

  show () {
    const elemToShow = document.querySelector(this.element.dataset.target)
    this.getSiblings(elemToShow).forEach((el) => {
      el.classList.add('d-none')
      el.classList.remove('d-block')
    })
    elemToShow.classList.remove('d-none')
    elemToShow.classList.add('d-block')
  }

  getSiblings (el) {
    const childrenArray = [...el.parentNode.children]
    return childrenArray.filter(child => child !== el)
  }
}
