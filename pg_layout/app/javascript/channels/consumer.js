// Action Cable provides the framework to deal with WebSockets in Rails.
// You can generate new channels where WebSocket features live using the `bin/rails generate channel` command.

import { createConsumer } from '@anycable/web'

let cableProtocol = document.head.querySelector('meta[name=actioncable-protocol]')
cableProtocol = cableProtocol && cableProtocol.content
cableProtocol = cableProtocol || 'actioncable-v1-ext-json'

export default createConsumer({
  protocol: cableProtocol
})
