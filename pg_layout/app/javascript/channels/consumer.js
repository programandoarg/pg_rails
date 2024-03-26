// Action Cable provides the framework to deal with WebSockets in Rails.
// You can generate new channels where WebSocket features live using the `bin/rails generate channel` command.

import { createConsumer } from '@anycable/web'

export default createConsumer({
  protocol: 'actioncable-v1-ext-json'
})
