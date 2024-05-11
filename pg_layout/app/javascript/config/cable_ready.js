import consumer from '../channels/consumer'
import CableReady from 'cable_ready'

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
      Rollbar.warning(`Disconnected because: ${ev.reason}`)
      console.log(`Disconnected because: ${ev.reason}`)
    } else {
      Rollbar.warning('Disconnected for unknown reason')
      console.log('Disconnected for unknown reason')
    }
  })
}

CableReady.initialize({ consumer })
