import { Controller } from '@hotwired/stimulus'
import Cookies from './../utils/cookies'

export default class extends Controller {
  expandNavbar (e) {
    const icon = this.element.querySelector('i')
    if (document.getElementById('sidebar').classList.toggle('opened')) {
      icon.classList.add('bi-chevron-left')
      icon.classList.remove('bi-chevron-right')
    } else {
      icon.classList.remove('bi-chevron-left')
      icon.classList.add('bi-chevron-right')
    }
    const isOpened = document.getElementById('sidebar').classList.contains('opened')
    new Cookies().setCookie('navbar_expand', isOpened, 30)
  }
}
