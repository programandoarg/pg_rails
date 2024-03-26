import consumer from '../channels/consumer'
import CableReady from 'cable_ready'

const anycable = consumer.cable

if (anycable) {
  anycable.on('connect', ev => {
    if (ev.reconnect) {
      console.log('Welcome back!')
    } else {
      console.log('Welcome!')
    }
  })

  anycable.on('disconnect', ev => {
    if (ev.reason) {
      console.log(`Disconnected because: ${ev.reason}`)
    } else {
      console.log('Disconnected')
    }
  })
}

CableReady.initialize({ consumer })
