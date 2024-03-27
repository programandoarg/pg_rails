import AsociableController from './app/javascript/asociable_controller'
import ModalController from './app/javascript/modal_controller'

if (window.Stimulus) {
  window.Stimulus.register('asociable', AsociableController)
  window.Stimulus.register('modal', ModalController)
} else {
  console.error('window.Stimulus must be set')
}
