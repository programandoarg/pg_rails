import { Controller } from '@hotwired/stimulus'
import Cookies from './cookies'

export default class extends Controller {
  expandNavbar (e) {
    document.getElementById('sidebar').classList.toggle('opened')
    const isOpened = document.getElementById('sidebar').classList.contains('opened')
    new Cookies().setCookie('navbar_expand', isOpened, 30)
  }
}
