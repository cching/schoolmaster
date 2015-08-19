# Curry the push state method.
window.push_state = (url, data) ->
	setTimeout (->
		History.pushState(data, null, url)
	), 0

# Return url without the protocol or host.
window.url_to_path = (url) ->
	url.replace("#{location.protocol}//#{location.host}", '')

# Retrieves the initial path from the meta tag and loads that url into
# history.
window.load_initial_path = ->
	initial_path = History.getHash() || $('head meta[name="initial_path"]').attr('content')
	initial_path = initial_path.replace(/^\./, '')
	window.location.hash = ''
	push_state(initial_path)

# Replace the current state with the href of the link that was clicked and
# ensure that the default behavior does not occur.
handle_link_click = (event) ->
	push_state(this.href)
	event.preventDefault()
	return false

# When a page is clicked, not an anchor or submit button, focus that page.
handle_page_click = (event) ->
	if $(event.target).is(':not(a:urlInternal, :submit, .cancel, input)')
		push_state $(this).attr('data-path')

# Retrieve the current path, handle special cases for certain paths,
# otherwise load the path.
handle_state_change = ->
	url = History.getState().url
	data = History.getState().data
	path = url_to_path(url)
	switch path
		when '/login' then push_state('/')
		when '/logout' then handle_logout()
		when '' then load_path('/', data)
		else load_path(path, data)

# Find the most matching page for the given path, remove unnecessary pages,
# and create the necessary pages.
# @param {String} path the path to load.
load_path = (path, data) ->
	$('.page').stop(true, true)
	index = path == '/'
	parts = if index then [''] else path.split('/')
	section = parts.length
	while section--
		current = "/#{parts[1..section].join('/')}"
		page = $(".page[data-path='#{current}']")
		if page.length
			
			# Handle two part links.
			if parts.length - section > 2
				one_more_path = "/#{parts[1..(section + 2)].join('/')}"
				one_more_link = page.find("a:urlInternal[href$='#{one_more_path}']")
				section++ if one_more_link.length
			
			animate_container_width_to(page.width(), index)
			page.trigger('enter_fullscreen') if page.is('.fullscreen')
			page.prevAll('.page').each ->
				destroy_page($(this))
			page.addClass('current')
			while ++section < parts.length
				create_page "/#{parts[1..section].join('/')}", data
			
			select_path(page)
			break

# Removes all selected classes from elements in page and adds the class to
# links that end in path.
# @param {Sring} page
window.select_path = (page) ->
	path = page.prevAll('.page:not(.destroyed)').first().attr('data-path')
	page.find('.selected').removeClass('selected')
	page.find("a:urlInternal[href$='#{path}']").addClass('selected') if path

$ ->
	# Handle internal link clicks.
	$('#container').delegate 'a:urlInternal:not([data-xhr="false"], .edit, .destroy)', 'click.link', handle_link_click
	
	# Go back when a page is clicked.
	$('#container').delegate '.page', 'click.page', handle_page_click
	
	# Handle window state changes.
	$(window).on 'statechange', handle_state_change
	
	# User is logged in.
	if $('#header #navigation').length
		load_initial_path()
	
	# User is not logged in.
	else
		load_login_form()