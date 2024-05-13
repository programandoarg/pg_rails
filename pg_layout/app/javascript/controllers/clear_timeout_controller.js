import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="clear-timeout"
export default class extends Controller {
  connect() {
    let timeoutId = parseInt(this.element.dataset.timeoutId)
    clearTimeout(timeoutId)
    console.log(`clearedTimeout: ${timeoutId}`)
    this.element.remove()
  }
}
