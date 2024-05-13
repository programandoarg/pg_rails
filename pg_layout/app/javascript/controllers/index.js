import { application } from './application'

import NavbarController from './navbar_controller'
import NestedController from './nested_controller'
import PgFormController from './pg_form_controller'
import FadeinOnloadController from './fadein_onload_controller'
import ClearTimeoutController from "./clear_timeout_controller"

application.register('navbar', NavbarController)
application.register('nested', NestedController)
application.register('pg_form', PgFormController)
application.register('fadein_onload', FadeinOnloadController)
application.register("clear-timeout", ClearTimeoutController)
