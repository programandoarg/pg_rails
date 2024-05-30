import consumer from '../../channels/consumer'
import { setConsumer } from '@hotwired/turbo-rails/app/javascript/turbo/cable.js'

setConsumer(consumer)
