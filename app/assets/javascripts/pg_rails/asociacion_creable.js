window.AsociacionCreable = new function() {
  asociacion_creable = this;
  asociacion_creable.bindear = function(contexto) {
    $(contexto).find('.crear_asociado').click(function() {
      var boton_crear = this;
      $.get($(this).data('url') + ".js").done(function(response) {
        var modal = pg_rails.abrir_modal(response);
        modal.find('form').ajaxForm({
          dataType: 'json',
          success: function(responseJSON, statusText, xhr) {
            var input_oculto = $(boton_crear).closest('.form-group').find('input.oculto');
            var input_visible = $(boton_crear).closest('.form-group').find('input:not(.oculto)');
            input_oculto.val(responseJSON['id']);
            input_visible.val(responseJSON['to_s']);
            // var select = $(boton_crear).closest('.form-group').find('select');
            // select.html('<option value="' + responseJSON['id'] + '" selected>' + responseJSON['to_s'] + '</option>')
            // select.trigger('chosen:updated');
            $(modal).modal('hide');
            $(modal).modal('dispose');
            $(modal).remove();
            PgRails.showToast('Elemento creado.')
          },
          error: function(response, status, statusText) {
            for( var i in response.responseJSON) {
              pg_rails.showToast(response.responseJSON[i]);
            }
            modal.find('form input[type=submit]').attr('disabled', null)
          }
        });
      })
    });

    $(contexto).find('.borrar_seleccion').click(function() {
      var input_oculto = $(this).closest('.form-group').find('input.oculto');
      var input_visible = $(this).closest('.form-group').find('input:not(.oculto)');
      input_oculto.val(null);
      input_visible.val(null);
    });
    $(contexto).find('.seleccionar_asociado').click(function() {
      var boton_seleccionar = this;
      var url = new URL($(this).data('url'));
      url.searchParams.set("sin_layout", "true");
      $.get(url, null, null, 'html').done(function(response) {
        var modal = pg_rails.abrir_modal(response, "Seleccionar", { dialog_class: 'modal-xl modal-lg modal-seleccionar-asociado' });

        var elemento_seleccionado = function() {
          var id = $(this).closest('tr').data('id');
          if(!id) {
            console.error("La fila no tiene ID")
            return
          }
          var url = $(boton_seleccionar).data('url') + "/" + id + '.json';
          $.get(url).done(function(response) {
            var input_oculto = $(boton_seleccionar).closest('.form-group').find('input.oculto');
            var input_visible = $(boton_seleccionar).closest('.form-group').find('input:not(.oculto)');
            input_oculto.val(id);
            if( response.to_s ) {
              input_visible.val(response.to_s);
            } else {
              console.error('El JSON no tiene to_s')
              input_visible.val("#" + response.id);
            }
            // select.html('<option value="'+id+'">'+response.to_s+'</option>');
            $(modal).modal('hide');
            $(modal).modal('dispose');
            $(modal).remove();
          }).fail(function() {
            pg_rails.error_toast("Hubo un error");
          });
        }

        modal.find(SmartListing.config.class_name("main")).smart_listing()
        modal.find(SmartListing.config.class_name("controls")).smart_listing_controls()
        modal.find(SmartListing.config.class_name("main")).on('ajax:success', function(a,b) {
          $(this).find('td').click(elemento_seleccionado);
        })
        modal.find('td').click(elemento_seleccionado);
      })
    });
  }
}
