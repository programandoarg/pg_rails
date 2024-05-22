import { Controller } from '@hotwired/stimulus'

// Connects to data-controller="clear-timeout"
export default class extends Controller {
  connect () {
    this.element.dataset.timeoutId.split(',').forEach((el) => {
      const timeoutId = parseInt(el)
      clearTimeout(timeoutId)
      console.log(`clearedTimeout: ${timeoutId}`)
    })
    this.element.remove()
  }
}
