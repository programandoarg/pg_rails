import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  connect() {
    this.showRemove()
  }

  addItem () {
    // Save a unique timestamp to ensure the key of the associated array is unique.
    let time = new Date().getTime();
    // Save the data id attribute into a variable. This corresponds to `new_object.object_id`.
    let linkId = this.element.dataset.id;
    // Create a new regular expression needed to find any instance of the `new_object.object_id` used in the fields data attribute if there's a value in `linkId`.
    let regexp = linkId ? new RegExp(linkId, "g") : null;
    // Replace all instances of the `new_object.object_id` with `time`, and save markup into a variable if there's a value in `regexp`.
    let newFields = regexp ? this.element.dataset.fields.replace(regexp, time) : null;
    // Add the new markup to the form if there are fields to add.
    newFields ? this.element.insertAdjacentHTML("beforebegin", newFields) : null;
    this.element.closest('form').dispatchEvent(new Event('nestedField:added'))
    this.showRemove()
  }

  quitar () {
    let parent = this.element.closest('.nested-fields')
    parent.style.display = 'none'
    parent.classList.add('removed')
    parent.querySelector('[name*=destroy]').value = 'true'
    this.element.closest('form').dispatchEvent(new Event('nestedField:removed'))
    this.showRemove()
  }
  showRemove() {
    let container = this.element.closest('.nested-container')
    if( container.dataset.required == 'true' ) {
      if(container.querySelectorAll('.nested-fields:not(.removed)').length == 1) {
        container.querySelectorAll('.link-to-remove').forEach((e) => {
          e.style.visibility = 'hidden'
        })
      } else {
        container.querySelectorAll('.link-to-remove').forEach((e) => {
          e.style.visibility = ''
        })
      }
    }
  }
}
