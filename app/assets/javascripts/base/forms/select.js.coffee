# Creates a token input that replaces check boxes.
prepare_multiple = ->
		
	# Unbind the blur handler when the form gets destroyed.
	$(this).closest('.wrapper').on 'unloaded', ->
		$('body').off 'click.blur_multiple_search'
	
	# For each token input.
	$(this).find('li.token, li.search_select').each ->
		element = $(this)
		list = element.find('fieldset ol.choices-group')
		results = element.find('fieldset ol.results')
		
		type = element.find('legend label').text()
			.toLowerCase()
			.replace(' ', '_')
			.replace('*', '')
			.replace(/([^s])$/, '$1s')
			.replace('classes', 'periods')
			.replace 'parents', ->
				element.closest('.wrapper').attr('data-name')
			
		name = element.find('input:hidden').attr('name')
		id = element.find('input:hidden').attr('id').replace(/_none/, '_id')
		single = element.is('.search_select')
		depends_on = element.attr('data-depends-on')
		
		# Clear button handler.
		element.delegate 'label', 'click.delete', (event) ->
			event.preventDefault()
			if $(event.target).is('i')
				$(this).closest('li').remove()
		
		# Store the search input.
		search_input = element.find('.search_field input').autoInputWidth()
		
		# Dump current selections when school changes.
		if depends_on
			depends_on_path = depends_on.replace(/([^s])$/, '$1s')
			depends_select_value = ->
				list.closest('form').find(":input[id$='#{depends_on}_id']").val()
		
		# Whenever a key is pressed or focused
		search_input.on 'keydown focus click', (event) ->
			list.addClass('searching')
			
			# Handle up and down key presses.
			if event.which == 40 || event.which == 38
				method = if event.which == 40 then 'next' else 'prev'
				previous = results.find('.hover')
				previous.siblings('li').removeClass('hover')
				if previous.length
					next = previous[method]('.result')
					if next.length
						next.addClass('hover')
						previous.removeClass('hover')
						results.scrollTo(next)
				else
					results.find('li:first').addClass('hover')
			
			# Handle enter key presses when there is a hovered result.
			else if event.which == 13
				if results.find('.hover').click().length
					event.preventDefault()
			
			# Hide results when the field is tabbed away from.
			else if event.which == 9
				results.hide()
			
			# All other keys, mostly interested in content keys.
			else
				self = $(this)
				clearTimeout(window.select_search_timeout) if window.select_search_timeout
				window.select_search_timeout = setTimeout (->
					results.text('').show()
					if self.val()
						result_text = 'Loading.'
						url = "/#{type}"
						url = "/#{depends_on_path}/#{depends_select_value()}" + url if depends_on
						$.getJSON url, { search: self.val(), term: 'All' }, (data) ->
							if data.length
								results.text('')
								$.each data, (index, record) ->
									$("<li class='result' data-id='#{record.id}' />")
										.text(record.name)
										.mouseover(-> $(this).addClass('hover'))
										.mouseleave(-> $(this).removeClass('hover'))
										.mousedown(-> $(this).addClass('active'))
										.mouseup(-> $(this).removeClass('active'))
										.appendTo(results)
										.click (event) ->
											inserted = list.find("input[value='#{record.id}']")
											if !inserted.length || single
												list.find('li.choice').remove() if single
												choice = $('<label />')
													.append("<input type='hidden' id='#{id}' name='#{name}' value='#{record.id}' />")
													.append(record.name)
												if depends_on == 'district'
													choice.append("<input type='hidden' id='district_id' value='#{record.district_id}' />")
												choice.append('<i />') unless single
												$('<li class="choice" />').html(choice).insertBefore(search_input.parent())
											else
												list.scrollTo(inserted, { onAfter: ->
													inserted.closest('label')
														.fadeTo(TINY_DURATION, 0)
														.fadeTo(TINY_DURATION, 1)
														.fadeTo(TINY_DURATION, 0)
														.fadeTo(TINY_DURATION, 1)
												})
											
											search_input.val('').focus()
										
							else
								results.html($('<li class="none" />').text('No results.'))
					else
						result_text = 'Type to search.'
					
					# No results for found or were left for entering.
					if result_text
						results.html($('<li class="none" />').text(result_text))
				), 0
		
		# Whenever the token area is clicked on, make it seem like the whole thing
		# is a text input.
		list.on 'click.focus', ->
			$(this).find('.search_field input').focus()
		
		# Attach this click handler to the body to handle blur cases.
		$('body').on 'click.blur_multiple_search', (event) ->
			
			# Do not blur if the clicked element was the list itself or within the
			# list or results.
			unless list.get(0) == event.target or
				$.contains(list.get(0), event.target) or
				$.contains(results.get(0), event.target)
					results.hide()
					list.removeClass('searching')

$ ->
	
	# When the wrapper loads that may contain check boxes.
	$('body').delegate '.wrapper.edit, .wrapper.new, .wrapper.update, .wrapper.create, .wrapper.export_list_items',
		'loaded.multiple', prepare_multiple