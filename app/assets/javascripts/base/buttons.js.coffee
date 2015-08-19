# If cancel is clicked on a new or create page, simply focus its parent
# page. If it is an edit page, hide the form and bring up the show wrapper.
handle_cancel_click = (event) ->
	wrapper = $(this).closest('.wrapper')
	if wrapper.is('.new, .create, .export_list_items:not(.upload)')
		push_state $(this).closest('.page').next('.page').attr('data-path')
	else if wrapper.is('.import')
		$(this).display_loading_message();
		reload_old_content(wrapper)
	else
		wrapper.trigger('unloaded')
			.animate { marginTop: "-#{$('#container').height()}px" }, SHORT_DURATION, ->
				$(this).remove()

handle_back_click = (event) ->
	event.preventDefault()
	event.stopImmediatePropagation()
	parts = History.getState().url.split('/')
	parts.pop()
	push_state parts.join('/')

handle_print_click = (event) ->
	event.preventDefault()
	button = $(this)
	wrapper = button.closest('.wrapper')
	if wrapper.is('.students.test_scores')
		window.print()
	else
		button.display_loading_message('Printing')
		load_results wrapper, true, ->
			window.print()
			button.hide_loading_message()

handle_help_click = ->
	animate_in_new_content($(this), 'help')

# When an edit button is clicked, display a loading message within that
# button, load the form, and animate it in to replace the show wrapper.
handle_edit_click = (event) ->
	animate_in_new_content($(this), 'edit')

# After clicking the delete button, show a confirmation message in the
# button. After a second click, destroy the record and remove the page. If
# the user clicks somewhere else, put the button in its previous state.
handle_destroy_click = (event) ->
	event.preventDefault()
	self = $(this)
	destroy_confirm.apply(this, [(data) ->
		if data.success
			wrapper = self.closest('.wrapper')
			if wrapper.is('.test_scores')
				reload_old_content(wrapper)
			else
				index = self.closest('.page').next('.page')
				push_state index.attr('data-path')
				remove_row(index.find('div.table'), data.id)
			
		else
			page = $(data.page)
			page.find('.inline-errors, .errors').hide()
			wrapper = self.closest('.wrapper')
			wrapper.replaceWith(page)
			page.trigger('loaded').find('.inline-errors, .errors')
				.slideDown(SHORT_DURATION)
	])

# Abstract some destroy logic so it can be reused.
window.destroy_confirm = (callback) ->
	self = $(this)
	self.text('Are you sure?').addClass('confirm')
	self.bind 'click.confirm', (event) ->
		
		event.stopImmediatePropagation()
		event.preventDefault()
		
		self.unbind('click.confirm').display_loading_message('Deleting')
		$(this).find('.inline-errors, .errors').slideUp(SHORT_DURATION)
		
		$('body').unbind('click.unconfirm')
		path = self.attr('href')
		
		destroy_path path, callback
			
					
	$('body').bind 'click.unconfirm', (event) ->
		if $(event.target).is(self)
			event.preventDefault()
		else
			self.unbind('click.confirm').removeClass('confirm').text('Delete')
			$('body').unbind('click.unconfirm')

handle_direction_click = (event) ->
	event.preventDefault()
	event.stopImmediatePropagation()
	direction = if $(this).is('.next') then 'next' else 'prev'
	page = $(this).closest('.page')
	wrapper = page.children('.wrapper')
	old_url = page.attr('data-path')
	index = page.next('.page')
	old_row = index.find(".table a[href='#{old_url}']")
	new_row = old_row[direction + 'All']('a:not(.level_breaker)').first()
	if url = new_row.attr('href')
		wrapper.remove()
		page.append(loading_message)
		$.get url, (data) ->
			loading_message.remove()
			push_state(url)
			page.attr('data-path', url)
			select_path(index)
			page.append(data)

# Generate the necessary form data to destroy a resource and post that to
# the given path and callback.
destroy_path = (path, callback = null) ->
	form_data = csrf_param()
	form_data['_method'] = 'delete'
	$.post path, form_data, (data) ->
		callback(data) if $.isFunction(callback)

# Handle create and update button clicks.
handle_submit_click = (event) ->
	$(this).closest('.wrapper').find('form').submit()
	
$ ->
	
	# Handle cancel button clicks.
	$('#container').delegate 'a.cancel', 'click.cancel', handle_cancel_click
	
	# Handle back button clicks.
	$('#container').delegate 'a.back', 'click.back', handle_back_click
	
	# Handle print button clicks.
	$('#container').delegate 'a.print', 'click.print', handle_print_click
	
	# Handle edit button clicks.
	$('#container').delegate 'a.edit', 'click.edit', handle_edit_click
	
	$('#container').delegate 'a.help', 'click.help', handle_help_click
	
	$('#container').delegate 'a.previous, a.next', 'click.direction', handle_direction_click
	
	# Handle create and update button clicks.
	$('#container').delegate 'a.update, a.create, a.upload', 'click.submit',
		handle_submit_click
	
	# Handle destroy button clicks.
	$('#container').delegate '.title a.destroy', 'click.destroy', handle_destroy_click