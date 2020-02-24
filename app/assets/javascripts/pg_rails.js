window.PgRails = new function() {
  self = this
  self.campo_dependiente_hacer = function(principal, dependiente, valor) {
    if( principal.val() == valor ) {
      dependiente.closest('.form-group').removeClass('ocultar')
    } else {
      dependiente.closest('.form-group').addClass('ocultar')
    }
  }
  self.encolumnar = function(principal, dependiente) {
    var fila = $('<div class="row">');
    fila = fila.insertBefore(principal.closest('.form-group'));
    var col1 = $('<div class="col-sm-6">');
    var col2 = $('<div class="col-sm-6">');
    col1.append(principal.closest('.form-group'));
    col2.append(dependiente.closest('.form-group'));
    fila.append(col1);
    fila.append(col2);
  }
  self.campo_dependiente = function(campo, depende_de, valor) {
    var principal = $('form.simple_form *[name*=' + depende_de + ']');
    var dependiente = $('form.simple_form *[name*=' + campo + ']');
    self.encolumnar(principal, dependiente)
    principal.change(function() {
      self.campo_dependiente_hacer(principal, dependiente, valor);
    })
    self.campo_dependiente_hacer(principal, dependiente, valor);
  }
  self.bindear = function() {
    $('table:has(.best_in_place)').css('table-layout', 'fixed');
    $(".best_in_place").best_in_place();
    $(".best_in_place").on('ajax:error', function(event, response) {
      self.showToast("error", response.responseText)
    });
    $(".best_in_place").on('best_in_place:activate', function(event, response) {
      var textarea = $(this).find('textarea');
      if( textarea.length > 0 ) {
        var valor = textarea.val();
        valor = valor.replace(/<br>/g, "\n")
        textarea.val(valor)
      }
    });
    $(".best_in_place").on('ajax:success', function(event, response) {
      self.showToast("success", "👍")
    });
    $.fn.datepicker.defaults.format = 'dd/mm/yyyy';

    $('.crear_asociado').click(function() {
      var boton_crear = this;
      $.get($(this).data('url') + ".js").done(function(response) {
        var modal = self.abrir_modal(response);
        modal.find('form').ajaxForm({
          dataType: 'json',
          success: function(responseJSON, statusText, xhr) {
            var select = $(boton_crear).closest('.form-group').find('select');
            select.append('<option value="' + responseJSON['id'] + '" selected>' + responseJSON['to_s'] + '</option>')
            select.trigger('chosen:updated');
            $(modal).modal('hide');
            PgRails.showToast('Elemento creado.')
          },
          error: function(responseText, statusText, xhr) {
            alert("mal");
            console.log(responseText);
            console.log(statusText);
          }
        });
      })
    });

    $('.datefield').datepicker({
      'format': 'dd/mm/yyyy',
      'todayBtn': 'linked',
      'autoclose': 'true',
      'language': 'es',
      'zIndexOffset': 2000,
    });
    $('.datefield').on('changeDate', function() {
      $(this).keydown();
    });
    if( typeof($.fn.selectize) == 'function' ) {
      $('select[multiple=multiple]').selectize();
    }
    if( typeof($.fn.chosen) == 'function' ) {
      $(".chosen-select").chosen();
    }
    $('form').dependent_fields();
    $('.exportar').click(function() {
      filtros = ''
      $('.filter').each(function(i, elem) {
        var input = $(elem).find('input,select');
        filtros += input.attr('name') + '=' + input.val() + '&'
      });

      var url_get = $(this).data('url') + "?"+filtros;
      window.location.href = url_get;
    })
  }

  self.insert_options = function(element, options, default_option, template_id, atributo_nombre) {
    if (options.length === 0) {
      default_option = '-';
    }

    var template_html;
    if( template_id != null ) {
      template_html = $(template_id).html();
    } else {
      template_html = '<option value="">{{default_option}}</option>{{#each array}}<option value="{{id}}">{{' + atributo_nombre + '}}</option>{{/each}}'
    }
    var template = Handlebars.compile(template_html);
    element.html(template({array: options, default_option: default_option}));
    element.trigger("chosen:updated");
  }


  self.abrir_modal = function(contenido) {
    var modal = $('<div class="modal"><div class="modal-dialog"><div class="modal-content"><div class="modal-body">');
    modal.find('.modal-body').html(contenido);
    $(modal).modal('show');
    return modal;
  }

  self.showToast = function (type, message) {
    
    if (type === "notice" || type === "success")
      type="success";
    else if (type === "alert" || type === "error")
      type="error";
    else if (type === "warning" )
      type="warning";
    else if (type === "info" )
      type="info";
    else {
      message = type;
      type = "success";
    }

    // Otro tipo que no use aca porque no encuentro el flash correspondiente es WARNING e INFO

    var shortCutFunction = type;

    title = "";

    toastr.options = {
      closeButton: true,
      debug: false,
      progressBar: true,
      preventDuplicates: false,
      positionClass: "toast-top-right",
      onclick: null,
      showDuration: "400",
      hideDuration: "1000",
      timeOut: "7000",
      extendedTimeOut: "1000",
      showEasing: "swing",
      hideEasing: "linear",
      showMethod: "fadeIn",
      hideMethod: "fadeOut"
    };

    $("#toastrOptions").text("Command: toastr["
            + shortCutFunction
            + "](\""
            + message
            + (title ? "\", \"" + title : '')
            + "\")\n\ntoastr.options = "
            + JSON.stringify(toastr.options, null, 2)
    );
    var $toast = toastr[shortCutFunction](message, title); // Wire up an event handler to a button in the toast, if it exists
  }

  window.jQuery.fn.dependent_fields = function() {
    var that = this;

    var update_dependent = function() {
      var target = this;
      var options = {};
      options[$(target).data('key')] = $(this).val();
      $.getJSON($(target).data('url'), options)
      .done(function(response) {
        var id = $(target).data('id')
        var siguiente_select = $("[data-id='"+id+"'] ~ select").first();
        self.insert_options(siguiente_select, response, 'Seleccione una opción', null, 'nombre');
        $(siguiente_select).trigger('change');
      }).fail(function(response) { });
    }

    var bind_events = function(target) {
      var main = $(target).find('select').last();
      var selectores = $(target).find('select').not(main); // Todos menos el último
      $(selectores).each(function(i, selector) {
        $(selector).on('change', update_dependent);
      })
    }

    // TODO: Polemic
    $(that).on('nested:fieldAdded', function(event){
      var field = event.field;
      bind_events(field);
    });

    $(that).find('.form-group.dependent_fields').each(function(i, field) {
      bind_events(field);
    })
  }
}

