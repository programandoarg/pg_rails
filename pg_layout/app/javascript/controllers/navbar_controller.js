import { Controller } from '@hotwired/stimulus'
import Cookies from './../utils/cookies'
import { fadeOut, fadeIn } from './../utils/utils'

export default class extends Controller {
  connect () {
    if (document.getElementById('sidebar').classList.contains('opened')) {
      document.querySelector('.navbar .navbar-brand').style.visibility = 'hidden'
    }
  }

  expandNavbar (e) {
    const icon = this.element.querySelector('i')
    if (document.getElementById('sidebar').classList.toggle('opened')) {
      icon.classList.add('bi-chevron-left')
      icon.classList.remove('bi-chevron-right')
      fadeOut(document.querySelector('.navbar .navbar-brand'))
    } else {
      icon.classList.remove('bi-chevron-left')
      icon.classList.add('bi-chevron-right')
      fadeIn(document.querySelector('.navbar .navbar-brand'))
    }
    const isOpened = document.getElementById('sidebar').classList.contains('opened')
    new Cookies().setCookie('navbar_expand', isOpened, 30)
  }
}
