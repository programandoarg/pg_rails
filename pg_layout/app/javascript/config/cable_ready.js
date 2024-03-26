import consumer from '../channels/consumer'
import CableReady from 'cable_ready'

if (consumer.cable) {
  consumer.cable.on('connect', ev => {
    if (ev.reconnect) {
      // console.log('Welcome back!')
      // toastDo('Reconectado', 'info')
      toastDo('Conectado nuevamente!', 'info')
    } else {
      // console.log('Welcome!')
    }
  })

  consumer.cable.on('disconnect', ev => {
    if (ev.reason) {
      toastDo('Parece que hay problemas con la conexión a internet', 'danger')
      toastDo(`Disconnected because: ${ev.reason}`, 'danger')
      console.log(`Disconnected because: ${ev.reason}`)
    } else {
      toastDo('Disconnected', 'danger')
      // console.log('Disconnected')
    }
  })
}

// FIXME: mover a utils
function toastDo (message, type) {
  const html = ` <div class="toast bg-${type}-subtle" role="alert" data-bs-autohide="true" data-xturbo-temporary="true" aria-live="assertive" aria-atomic="true">
      <div class="toast-body">
        ${message}
      </div>
    </div>`
  document.querySelector('#flash').innerHTML = html
}
CableReady.initialize({ consumer })
