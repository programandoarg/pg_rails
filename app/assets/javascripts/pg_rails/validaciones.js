//= require jquery-validation

$.extend( $.validator.messages, {
  required: "Este campo es obligatorio.",
  remote: "Por favor, completá este campo.",
  email: "Por favor, escribí una dirección de correo válida.",
  url: "Por favor, escribí una URL válida.",
  date: "Por favor, escribí una fecha válida.",
  dateISO: "Por favor, escribí una fecha (ISO) válida.",
  number: "Por favor, escribí un número entero válido.",
  digits: "Por favor, escribí sólo dígitos.",
  creditcard: "Por favor, escribí un número de tarjeta válido.",
  equalTo: "Por favor, escribí el mismo valor de nuevo.",
  extension: "Por favor, escribí un valor con una extensión aceptada.",
  maxlength: $.validator.format( "Por favor, no escribas más de {0} caracteres." ),
  minlength: $.validator.format( "Por favor, no escribas menos de {0} caracteres." ),
  rangelength: $.validator.format( "Por favor, escribí un valor entre {0} y {1} caracteres." ),
  range: $.validator.format( "Por favor, escribí un valor entre {0} y {1}." ),
  max: $.validator.format( "Por favor, escribí un valor menor o igual a {0}." ),
  min: $.validator.format( "Por favor, escribí un valor mayor o igual a {0}." ),
  nifES: "Por favor, escribí un NIF válido.",
  nieES: "Por favor, escribí un NIE válido.",
  cifES: "Por favor, escribí un CIF válido."
} );

$.validator.setDefaults({
  ignore: ":hidden:not(select.chosen-select):not(.hidden-validation-field),.ignore-validation",
  errorPlacement: function(error, element) {
    var group = element.closest('.form-group');
    if( group ) {
      if( group.hasClass('row') ) {
        error.appendTo( element.parent() );
      } else {
        error.appendTo( element.closest('.form-group') );
      }
    } else {
      error.appendTo( element.parent() );
    }
  }
})
$.validator.addMethod("nestedPresence", function(value, element) {
  return $(element).closest('.nested-container').find('.fields:not(.removed)').length > 0
}, "Este campo es obligatorio.");
$.validator.addClassRules("nested_presence", { nestedPresence: true });
