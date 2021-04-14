// Datepicker para los editores de fecha de best_in_place
// Es una copia modificada de best_in_place.jquery-ui

BestInPlaceEditor.forms.date = {
    activateForm: function () {
        'use strict';
        var that = this,
            output = jQuery(document.createElement('form'))
                .addClass('form_in_place')
                .attr('action', 'javascript:void(0);')
                .attr('style', 'display:inline'),
            input_elt = jQuery(document.createElement('input'))
                .attr('type', 'text')
                .attr('name', this.attributeName)
                .attr('value', this.sanitizeValue(this.display_value));
                // .attr('value', this.sanitizeValue(moment(this.display_value).format('DD/MM/YYYY')));
        if (this.inner_class !== null) {
            input_elt.addClass(this.inner_class);
        }
        output.append(input_elt);

        this.element.html(output);
        this.setHtmlAttributes();
        this.element.find('input')[0].select();
        this.element.find("form").bind('submit', {editor: this}, BestInPlaceEditor.forms.input.submitHandler);
        this.element.find("input").bind('keyup', {editor: this}, BestInPlaceEditor.forms.input.keyupHandler);

        this.element.find('input')
            .datepicker({
                'format': 'dd/mm/yyyy',
                'todayBtn': 'linked',
                'autoclose': 'true',
                'language': 'es',
              }).on('changeDate', function () {
              $(this).datepicker('destroy');
              that.update();
            }).datepicker('show');
    },

    getValue: function () {
        'use strict';
        return this.sanitizeValue(this.element.find("input").val());
    },

    submitHandler: function (event) {
        'use strict';
        event.data.editor.update();
    },

    keyupHandler: function (event) {
        'use strict';
        if (event.keyCode === 27) {
            event.data.editor.abort();
        }
    }
}


