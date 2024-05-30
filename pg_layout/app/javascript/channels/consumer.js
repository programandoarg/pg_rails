// Action Cable provides the framework to deal with WebSockets in Rails.
// You can generate new channels where WebSocket features live using the `bin/rails generate channel` command.

import { createConsumer } from '@anycable/web'
import Rollbar from 'rollbar'

let cableProtocol = document.head.querySelector('meta[name=actioncable-protocol]')
cableProtocol = cableProtocol && cableProtocol.content
cableProtocol = cableProtocol || 'actioncable-v1-ext-json'

const consumer = createConsumer({
  protocol: cableProtocol
})

const anycable = consumer.cable

if (anycable) {
  anycable.on('connect', ev => {
    document.head.dataset.cableConnected = true
    if (ev.reconnect) {
      console.log('Welcome back!')
    } else {
      console.log('Welcome!')
    }
  })

  anycable.on('disconnect', ev => {
    document.head.dataset.cableConnected = false
    // document.head.dataset.cableDisconnectedEvent = ev
    if (ev.reason) {
      if (ev.reason === 'transport_closed') {
        // no hago nada (?
      } else {
        Rollbar.warning(`Disconnected because: ${ev.reason}`)
      }
      console.log(`Disconnected because: ${ev.reason}`)
    } else {
      Rollbar.warning('Disconnected for unknown reason')
      console.log('Disconnected for unknown reason')
    }
  })
}

// Para desconectar
// anycable.disconnect()

export default consumer
