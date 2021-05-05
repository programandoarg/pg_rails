//= require pg_rails/validaciones
//= require pg_rails/asociacion_creable

window.PgRails = new function() {
  pg_rails = this
  pg_rails.campo_dependiente_hacer = function(principal, dependiente, valor) {
    if( principal.val() == valor ) {
      dependiente.closest('.form-group').removeClass('ocultar')
    } else {
      dependiente.closest('.form-group').addClass('ocultar')
    }
  }
  pg_rails.encolumnar = function(principal, dependiente) {
    var fila = $('<div class="row">');
    fila = fila.insertBefore(principal.closest('.form-group'));
    var col1 = $('<div class="col-sm-6">');
    var col2 = $('<div class="col-sm-6">');
    col1.append(principal.closest('.form-group'));
    col2.append(dependiente.closest('.form-group'));
    fila.append(col1);
    fila.append(col2);
  }
  pg_rails.campo_dependiente = function(campo, depende_de, valor) {
    var principal = $('form.simple_form *[name*=' + depende_de + ']');
    var dependiente = $('form.simple_form *[name*=' + campo + ']');
    pg_rails.encolumnar(principal, dependiente)
    principal.change(function() {
      pg_rails.campo_dependiente_hacer(principal, dependiente, valor);
    })
    pg_rails.campo_dependiente_hacer(principal, dependiente, valor);
  }
  pg_rails.bindear = function(contexto) {
    if(contexto == null) {
      contexto = $('body');
    } else {
      contexto = $(contexto);
    }
    AsociacionCreable.bindear(contexto);
    $(contexto).find('.listado a[data-method=delete]').click(function(e) {
      var boton = this;
      e.preventDefault();
      e.stopPropagation();
      var url = $(this).attr('href');
      var confirmar = $(this).data('confirm');
      if(!confirmar) {
        confirmar = "¿Estás seguro?"
      }
      if( confirm(confirmar) ) {
        $.ajax(url, {
          dataType: 'json',
          method: 'DELETE',
        }).done(function(response) {
          if($(boton).closest('.smart-listing').length > 0) {
            $(boton).closest('.smart-listing').smart_listing().reload()
          } else {
            window.location.reload();
          }
          pg_rails.showToast("Elemento borrado");
        }).fail(function(response) {
          pg_rails.error_toast(response.responseJSON.error);
        });
      }
    })
    $('.tooltip').remove();
    $("[rel=tooltip]").tooltip({ boundary: 'window' });
    $(contexto).find("[rel=tooltip]").tooltip();
    $(contexto).find('form.pg-form').each(function(i,e) {
      $(e).validate();
    });
    if( typeof $.fn.best_in_place == 'function' ) {
      $(contexto).find('table:has(.best_in_place)').css('table-layout', 'fixed');
      $(contexto).find(".best_in_place").best_in_place();
      $(contexto).find(".best_in_place").on('ajax:error', function(event, response) {
        pg_rails.showToast("error", response.responseText)
      });
      $(contexto).find(".best_in_place").on('best_in_place:activate', function(event, response) {
        var textarea = $(this).find('textarea');
        if( textarea.length > 0 ) {
          var valor = textarea.val();
          valor = valor.replace(/<br>/g, "\n")
          textarea.val(valor)
        }
      });
    }
    // $(".best_in_place").on('ajax:success', function(event, response) {
    //   pg_rails.showToast("success", "👍")
    // });
    if( typeof $.fn.datepicker == 'function' ) {
      $.fn.datepicker.defaults.format = 'dd/mm/yyyy';
      $(contexto).find('.datefield').datepicker({
        'format': 'dd/mm/yyyy',
        'todayBtn': 'linked',
        'autoclose': 'true',
        'language': 'es',
        'zIndexOffset': 2000,
      });
      $(contexto).find('.datefield').on('changeDate', function() {
        $(this).keydown();
      });
    }

    if( typeof($.fn.selectize) == 'function' ) {
      $(contexto).find('select[multiple=multiple]').selectize();
    }
    if( typeof($.fn.chosen) == 'function' ) {
      $(contexto).find(".chosen-select:visible").chosen('destroy');
      $(contexto).find(".chosen-select:visible").chosen();
      contexto.on('shown.bs.collapse', function() {
        // Cuando hay un chosen en un collapse, lo inicializo al mostrarse
        contexto.find('.chosen-select:visible').chosen();
      })
    }
    $(contexto).find('form').dependent_fields();
    $(contexto).find('.exportar').click(function() {
      filtros = ''
      $('.filter').each(function(i, elem) {
        var input = $(elem).find('input,select');
        filtros += input.attr('name') + '=' + input.val() + '&'
      });

      var url_get = $(this).data('url') + "?"+filtros;
      window.location.href = url_get;
    })
    contexto.find('.pg_ajax_link:not(.bindeado)').each(function(i, elem) {
      $(this).addClass('bindeado');
      $(this).click(function() {
        $.get($(this).data('url'))
      })
    });
  }

  pg_rails.insert_options = function(element, options, default_option, template_id, atributo_nombre) {
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

  pg_rails.abrir_modal = function(contenido, titulo = '', opciones = {}) {
    var header = '<div class="modal-header">' +
    '  <h5 class="modal-title">' + titulo + '</h5>' +
    '  <button type="button" class="close" data-dismiss="modal" aria-label="Close">' +
    '    <span aria-hidden="true">&times;</span>' +
    '  </button>' +
    '</div>';
    if( opciones['dialog_class'] ) {
      var dialog_class = 'modal-dialog ' + opciones['dialog_class'];
    } else {
      var dialog_class = 'modal-dialog';
    }
    var modal = $('<div class="modal"><div class="' + dialog_class + '"><div class="modal-content">' + header + '<div class="modal-body">');
    modal.find('.modal-body').html(contenido);
    $('body').append(modal);
    modal.on('hidden.bs.modal', function() {
      // $(this).modal('dispose');
      $(this).remove();
    })
    modal.modal('show');
    return modal;
  }

  pg_rails.error_toast = function(message) {
    pg_rails.showToast("error", message);
  }

  pg_rails.showToast = function (type, message) {
    var title = null;
    if (type === "notice" || type === "success") {
      type="success";
      title = "Notificación";
    } else if (type === "alert" || type === "error") {
      type="error";
      title = "Error";
    } else if (type === "warning" ) {
      type="warning";
      title = "Advertencia";
    } else if (type === "info" ) {
      type="info";
      title = "Notificación";
    } else {
      message = type;
      title = "Notificación";
      type = "success";
    }

    if (typeof $.fn.toast == "function") {
      var template_html = "\
        <div class='toast toast-{{type}}' role='alert' aria-live='assertive' aria-atomic='true'>\
          <div class='toast-header'>\
            <strong class='mr-auto'>{{title}}</strong>\
            <button type='button' class='ml-2 mb-1 close' data-dismiss='toast' aria-label='Close'>\
              <span aria-hidden='true'>&times;</span>\
            </button>\
          </div>\
          <div class='toast-body'>\
            {{message}}\
          </div>\
        </div>";

      var template = Handlebars.compile(template_html);
      var toast = $(template({message: message, title: title, type: type}));
      $("#toast-container").append(toast);
      $(toast).toast({
        delay: 3000,
        // autohide: false,
      });
      $(toast).toast('show');
      $(toast).on('hidden.bs.toast', function () {
        $(toast).remove();
      })
    } else {
      if (window.toastr) {
        var shortCutFunction = type;

        title = "";

        window.toastr.options = {
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
        var $toast = window.toastr[shortCutFunction](message, title);
      } else {
        alert(message);
      }
    }
  }

  window.jQuery.fn.ocultar_campo = function() {
    this.hide();
    this.find('.chosen-select').addClass('ignore-validation');
    this.find("input:not(.keep-disabled), select:not(.keep-disabled)").attr("disabled",true);
    this.find("input, select").trigger("change"); //Esto es por si hay dependencias internas que se acomoden
  }

  window.jQuery.fn.mostrar_campo = function() {
    this.show();
    this.find('.chosen-select').removeClass('ignore-validation');
    this.find("input:not(.keep-disabled), select:not(.keep-disabled)").attr("disabled",false);
    this.find("input, select").trigger("change"); //Esto es por si hay dependencias internas que se acomoden
  }

  window.jQuery.fn.dependent_fields = function() {
    var that = this;

    var update_dependent = function() {
      var target = this;
      var options = {};
      options[$(target).data('key')] = $(this).val().toString();
      $.getJSON($(target).data('url'), options)
      .done(function(response) {
        // var id = $(target).data('id')
        // var siguiente_select = $("[data-id='"+id+"'] ~ select").first();
        var siguiente_select = $(target).nextAll('select').first()
        pg_rails.insert_options(siguiente_select, response, 'Seleccione una opción', null, 'to_s');
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

$(document).on('nested:fieldAdded', function(event){
  PgRails.bindear(event.field);
});


// para que no se submiteen los forms al apretar enter en inputs que no son de submit
$(document).ready(function() {
  $(window).keydown(function(event){
    if(event.keyCode == 13) {
      if( event.target.tagName == 'INPUT' && $(event.target).attr('type') != 'submit') {
        event.preventDefault();
        return false;
      }
    }
  });
});
