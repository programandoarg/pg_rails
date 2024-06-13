import { Controller } from '@hotwired/stimulus'
import { post } from '@rails/request.js'
import { Rollbar } from 'rollbar'

// Connects to data-controller="notifications"
export default class extends Controller {
  timeoutId = null

  connect () {
    this.element.addEventListener('shown.bs.collapse', event => {
      this.timeoutId = setTimeout(() => {
        this.markAsSeen()
      }, 2000)
      document.addEventListener('turbo:load', () => { this.cancelTimeout() })
    })
    this.element.addEventListener('hide.bs.collapse', event => {
      clearTimeout(this.timeoutId)
    })
  }

  async markAsSeen () {
    const ids = []
    document.querySelectorAll('.notification')
      .forEach((e) => { ids.push(e.dataset.id) })
    const response = await post('/u/notifications/mark_as_seen',
      { query: { ids }, responseKind: 'turbo-stream' })

    if (response.ok) {
      document.querySelectorAll('.notification.unseen').forEach(
        (notif) => {
          notif.classList.remove('unseen')
        }
      )
      document.querySelector('.notifications-unseen-mark').remove()
    } else {
      const text = await response.text
      Rollbar.error('Error marking as seen: ', text)
    }
  }

  cancelTimeout () {
    if (this.timeoutId) {
      clearTimeout(this.timeoutId)
    }
  }
}
