class PgEventElement extends HTMLElement {
  connectedCallback () {
    if (this.dataset.eventName === 'pg:refresh-frame') {
      const frame = this.closest('turbo-frame[src]')
      // FIXME: solucionar de mejor manera
      if (frame && frame.id !== 'modal_content') {
        frame.reload()
      } else {
        this.bubbleEvent()
      }
    } else {
      this.bubbleEvent()
    }
  }

  bubbleEvent () {
    const event = new MessageEvent(this.dataset.eventName, { bubbles: true, data: this })
    this.dispatchEvent(event)
  }

  disconnectedCallback () {
  }
}

if (customElements.get('pg-event') === undefined) {
  customElements.define('pg-event', PgEventElement)
}
