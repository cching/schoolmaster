handle_upload_click = ->
	button = $(this)
	unless button.is('.loading')
		button.display_loading_message()
		page = button.closest('.page')
		wrapper = page.children('.wrapper')
		
		$.get '/export_list_items/upload', (data) ->
			button.hide_loading_message()
			data = $(data)
			data.css(marginTop: "-#{$('#container').height()}px")
			$(data).prependTo(page).trigger('loaded').animate {
				marginTop: 0 }, MEDIUM_DURATION

handle_clear_export_list_click = ->
  button = $(this)
  button.display_loading_message('Clearing')
  $.post '/export_list_items/clear', csrf_param(), ->
    button.closest('.wrapper').find('.table a').remove()
    update_export_list_count(0)
    update_export_list_styles('')
    button.hide_loading_message()

window.update_export_list_count_and_styles = (data) ->
  if data.export_list_styles isnt undefined
    update_export_list_styles(data.export_list_styles)
  if data.export_list_count isnt undefined
    update_export_list_count(data.export_list_count)

update_export_list_count = (count) ->
  $('#navigation .export span').text(count)

window.update_export_list_styles = (styles) ->
  style = $('#export_list_styles')
  if style[0].styleSheet # IE
    style[0].styleSheet.cssText = styles
  else
    style.text(styles)

handle_export_all = (event) ->
  event.preventDefault()
  event.stopImmediatePropagation()
  button = $(this)
  button.display_loading_message()
  url = button.closest('.page').attr('data-path') + '/export'
  $.post url, (data) ->
    button.hide_loading_message()
    update_export_list_count_and_styles(data)

handle_toggle_export_list_item = (event) ->
  event.preventDefault()
  event.stopImmediatePropagation()
  button = $(this)
  classes = button.attr('class')
  if matches = classes.match(/students-select-(\d+)/)
    id = matches[1]
    data = $.extend(csrf_param(), { student_id: id })
    $.post '/export_list_items/toggle', data, (data) ->
      update_export_list_count_and_styles(data)
      if data.removed && button.closest('.wrapper').is('.export_list_items')
        button.closest('a').remove()

handle_export_load = ->
  update_waiting_link($(this))
  $(this).find('.waiting_link').display_loading_message()

update_waiting_link = (wrapper) ->
  if (button = wrapper.find('.waiting_link')).length
    $.get '/load_import_jobs', (data) ->
      data = $(data)
      if data.find('.download_link').length
        wrapper.find('.scroller').replaceWith(data.find('.scroller'))
      else
        setTimeout((-> update_waiting_link(wrapper)), 500)

$ ->
  
  $('#container').delegate 'span.export_list_button', 'click.toggle_export_list_item', handle_toggle_export_list_item
  $('#container').delegate 'span.export_all_button', 'click.export_all', handle_export_all
  
  $('#container').delegate 'a.clear_export_list', 'click.clear_export_list', handle_clear_export_list_click

  $('#container').delegate '.wrapper.export_list_items, .wrapper.export_list_items', 'loaded.refresh', handle_export_load
  
  $('#container').delegate 'a.upload', 'click.upload', handle_upload_click