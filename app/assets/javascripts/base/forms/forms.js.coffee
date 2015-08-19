# Display a loading message on the create or update and submit buttons. Post
# the data, if the form failed, display the new form with the errors. If the
# form succeeded, update the index and scroll the form up to reveal the show
# wrapper. If the type was create, update the url and wrapper data-path.
handle_form_submit = (event) ->
	form = $(this)
	return if form.attr('target') == '_blank'
	
	wrapper = form.closest('.wrapper')
	if wrapper.is('.edit, .update')
		message = 'Saving'
	else if wrapper.is('.import')
		message = 'Uploading'
	else if wrapper.is('.export_list_items')
		message = 'Exporting'
	else
		message = 'Creating'
		
	wrapper.find('a.create, a.update').display_loading_message(message)
	form.find(':submit').display_loading_message(message)
	form.find('.inline-errors, .errors').slideUp(SHORT_DURATION)
	
	file_inputs = form.find(':file')
	has_file = false
	file_inputs.each ->
		has_file = true if $(this).val()
	data = if has_file then form.serializeArray() else form.serialize()
	
	$.ajax this.action,
		data: data
		type: 'POST'
		files: file_inputs
		iframe: has_file
		processData: false
		dataType: 'text'
		success: (data) ->
			try
				data = $.parseJSON(data)
			catch e
			
			if $.isPlainObject(data)
				unescape_values(data)
			
			if data.success == true
				page = wrapper.parent()
				index = page.next('.page')
				
				if data.test_scores
					if data.skip_path_reload
						if !index.find('.wrapper.index').length
							index.find('.tests').replaceWith(data.test_scores)
							index = index.next('.page')
					else
						wrapper.next().find('.tests').replaceWith(data.test_scores)
						wrapper.animate {
							marginTop: "-#{$('#container').height()}px" }, MEDIUM_DURATION, ->
								$(this).remove()
					load_results(index.find('.wrapper'))

				if data.path
					unless data.skip_path_reload
						old_path = page.attr('data-path').split('/')[0..-2].join('/')
						if old_path == data.path.split('/')[0..-2].join('/')
							page.attr('data-path', data.path)
					push_state(data.path)

				unless index.is('.destroyed')
					if data.row
						insert_row(index.find('div.table'), data.row)
						select_path(index)
						index.find('.scroller').scrollTo('.selected')

					if data.page
						wrapper.next('.show.wrapper').trigger('unloaded').remove()
						page = $(data.page)
						$(data.page).insertAfter(wrapper).trigger('loaded')
						wrapper.animate {
							marginTop: "-#{$('#container').height()}px" }, MEDIUM_DURATION, ->
								$(this).remove()

			else if data.success == false
				page = $(data.page)
				errors = page.find('.inline-errors, .errors').hide()
				page.insertBefore(wrapper).trigger('loaded')
				wrapper.trigger('unloaded').remove()
				errors.slideDown(SHORT_DURATION)
					
			else
				wrapper.find('a.create, a.update, a.upload').hide_loading_message()
				form.find(':submit').hide_loading_message()
				
				if wrapper.is('.import') || wrapper.is('.export_list_items')
					update_export_list_count_and_styles data
					wrapper.next('.index.wrapper').trigger('unloaded').remove()
					$(data.page).insertAfter(wrapper).trigger('loaded')
					wrapper.animate {
						marginTop: "-#{$('#container').height()}px" }, MEDIUM_DURATION, ->
							$(this).remove()
					
				else
					page = $("<div class='page' data-path='#{form.attr('action')}' />")
					page.html(data).css(marginLeft: '-200px').prependTo('#container')
					push_state(form.attr('action'))
					width = page.children().width()
					page.animate { width: width, marginLeft: 0 },
						{ duration: SHORT_DURATION, step: ensure_visible_header }
					animate_container_width_to(width)
	
	event.preventDefault()
	return false

window.unescape_values = (hash) ->
	for key, value of hash
		if typeof value == 'string'
			hash[key] = $('<div />').html(value).text()
	
$ ->
	
	# Handle all form submits.
	$('#container').delegate 'form:not(.special_handler)', 'submit.submit', handle_form_submit