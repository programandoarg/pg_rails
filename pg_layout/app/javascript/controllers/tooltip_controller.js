import { Controller } from '@hotwired/stimulus'
import * as bootstrap from 'bootstrap'

export default class extends Controller {
  tooltip = null

  connect () {
    if (this.element.dataset.bsTrigger === 'contextmenu') {
      this.element.addEventListener('contextmenu', (ev) => {
        ev.preventDefault()
        if (!this.tooltip) {
          this.tooltip = new bootstrap.Tooltip(this.element, {
            trigger: 'focus'
          })
          this.tooltip.show()
        }
      })
    } else {
      this.tooltip = new bootstrap.Tooltip(this.element)
    }
  }

  setContent (content) {
    this.tooltip.setContent({ '.tooltip-inner': content })
  }

  hide () {
    this.tooltip.hide()
  }

  disconnect () {
    if (this.tooltip) {
      this.tooltip.dispose()
    }
  }
}
