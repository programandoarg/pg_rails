import Rollbar from 'rollbar'

// TODO: testear con capybara, si se puede
let rollbarToken = document.head.querySelector('meta[name=rollbar-token]')
rollbarToken = rollbarToken && rollbarToken.content

let rollbarEnv = document.head.querySelector('meta[name=rollbar-env]')
rollbarEnv = rollbarEnv && rollbarEnv.content
rollbarEnv = rollbarEnv || 'unknown'

window.Rollbar = Rollbar

Rollbar.init()

Rollbar.global({
  itemsPerMinute: 2,
  maxItems: 5
})
Rollbar.configure({
  enabled: !!rollbarToken,
  accessToken: rollbarToken,
  captureUncaught: true,
  captureUnhandledRejections: true,
  reportLevel: 'warning',
  payload: {
    environment: rollbarEnv
  }
})
