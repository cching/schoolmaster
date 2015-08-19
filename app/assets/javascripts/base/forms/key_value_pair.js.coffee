handle_key_value_pair_keydown = (event) ->
  $this = $(this)
  setTimeout (->
    if $this.closest('div').is('.key')
      if value = $this.val()
        name = "test_score[data][#{value}]"
        $this.closest('li').find('.value input').attr('name', name)
      else
        $this.removeAttr('name')
  ), 0

handle_add_column = (event) ->
  event.preventDefault()
  $this_li = $(this).closest('li')
  $new_column = $this_li.prev('li').clone()
  $new_column.find('input').val('').removeAttr('name')
  $new_column.hide().insertBefore($this_li).slideDown(SHORT_DURATION)

$ ->
  $('#container').delegate '.test_scores.wrapper form li.key_value_pair input',
    'keydown.handle_key_value_pair_keydown', handle_key_value_pair_keydown
  
  $('#container').delegate '.test_scores.wrapper form input.add_column',
    'click.handle_add_column', handle_add_column