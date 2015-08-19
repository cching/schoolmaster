handle_input_blur = (event) ->
  event.preventDefault()
  event.stopImmediatePropagation()
  value = $(this).val().replace(/\n/g, '<br />')
  $(this).siblings('.holder').html(value)
  handle_blur_submit.apply(this)

handle_blur_submit = (event) ->
  form = $(this).closest('form')
  $.post form.attr('action'), form.serialize()

$ ->
  
  $('#container').delegate('.wrapper.students .notes textarea,' +
    '.wrapper.students .interventions textarea',
    'blur.blur_submit', handle_input_blur)
  
  $('#container').delegate('.wrapper.students .interventions input',
    'change.blur_submit', handle_blur_submit)

  $('#container').delegate('.wrapper.students .tests a', 'click.edit_test_score', (event) ->
    event.preventDefault()
  )