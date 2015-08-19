# Create a page with the given path, load the url into the page, and add the
# selected class to links that match in the previous page.
# {String} path the path to load.
# {Function} callback
window.create_page = (path, data, method = 'GET') ->
	page = $('<div />').addClass('page current').attr('data-path', path)
	loading_message = $('<div />').addClass('loading_message')
	page.html loading_message.text('Loading')
	page.prependTo('#container').nextAll('.page').removeClass('current')
	prevPage = page.next('.page')
	if prevPage.is('.fullscreen')
		page.addClass('fullscreen')
		prevPage.animate { left: '-200px', right: '200px' }, MEDIUM_DURATION
		page.css(width: '200px', right: '-200px')
			.animate { right: 0 }, MEDIUM_DURATION
	else
		page.css(marginLeft: '-200px').animate { marginLeft: 0 }, MEDIUM_DURATION
	load_callback = ->
		page.find('.wrapper').trigger('loaded')
		select_path(page)
		width = page.children().width()
		if prevPage.is('.fullscreen')
			prevPage.animate { left: '-200px', width: '200px' }, SHORT_DURATION
			page.trigger('enter_fullscreen')
		else
			page.stop(false, true).animate {
				width: width,
				marginLeft: 0
			}, {
				duration: MEDIUM_DURATION,
				step: ensure_visible_header
			}
		animate_container_width_to(width) unless page.index()
	if $.isPlainObject(data) && !$.isEmptyObject(data)
		page.load path, data, load_callback
	else
		page.load path, load_callback

window.animate_in_new_content = (button, path) ->
	unless button.is('.loading')
		button.display_loading_message()
		page = button.closest('.page')
		wrapper = page.children('.wrapper')
		if button.attr('href').indexOf('/') isnt -1
			url = button.attr('href')
		else
			url = [page.attr('data-path'), path].join('/')

		$.get url, (data) ->
			button.hide_loading_message()
			data = $(data)
			data.css(marginTop: "-#{$('#container').height()}px")
			$(data).prependTo(page).trigger('loaded').animate {
				marginTop: 0 }, MEDIUM_DURATION

window.reload_old_content = (wrapper) ->
	url = wrapper.closest('.page').attr('data-path')
	wrapper.next('.wrapper').trigger('unloaded').remove()
	$.get url, (data) ->
		$(data).insertAfter(wrapper).trigger('loaded')
		wrapper.animate {
			marginTop: "-#{$('#container').height()}px" }, MEDIUM_DURATION, ->
				$(this).remove()

# Animates the page out and removes once completed.
# {jQuery} page the page to destroy.
window.destroy_page = (page) ->
	page.find('.wrapper').trigger('unloaded')
	page.addClass('destroyed').animate {
		width: '200px'
		marginLeft: '-200px'
	}, {
		duration: SHORT_DURATION
		step: ensure_visible_header
		complete: ->
			$(this).remove()
	}

# Animate the container to the new width and adjust the marginRight so it
# stays centered in the window.
# @param {Integer} new_width
window.animate_container_width_to = (new_width, center = false, login = false) ->
	new_width /= -2
	new_width = 0 if center
	container = $('#container')
	duration = if center || login then SHORT_DURATION else MEDIUM_DURATION
	container.stop().animate {
		marginRight: "#{new_width}px"
	}, {
		duration: duration,
		step: ensure_visible_header
	}

header = container = null
# If the header is off the page, set its position to static to keep it on the
# page.
window.ensure_visible_header = ->
	next = container.find('.page:not(#header)').last()
	if next.length && !next.is('.fullscreen') && next.offset().left < 200
		header.addClass('stuck').prependTo('#meta_container')
	else
		header.removeClass('stuck').appendTo('#container')

$ ->
	# Handle window resize.
	$(window).resize ensure_visible_header
	
	# Handle window focus.
	$(window).focus ensure_visible_header
	
	header = $('#header')
	container = $('#container')