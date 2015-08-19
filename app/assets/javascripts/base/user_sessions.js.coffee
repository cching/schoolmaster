# If the login was successful, replace the login form with the navigation
# menu and load the initial path. If it was not successful, display the form
# with errors.
handle_login_form_submit = (event) ->
	$(this).find(':submit').display_loading_message('Logging In')
	$(this).find('.inline-errors, .errors').slideUp(SHORT_DURATION)
		
	$.post this.action, $(this).serialize(), (data) ->
		page = $(data.page)
		if page.is('#navigation') # Form success.
			try # IE barfs here
				update_export_list_styles(data.export_list_styles)
			$('#header').append(page).animate({width: '200px'}, SHORT_DURATION)
			animate_container_width_to(200, true)
			navigation_height = $('#header #navigation').outerHeight()
			$('#header #navigation').css(marginTop: "-#{navigation_height}px")
			$('#header #navigation').insertAfter('#header h1')
			$('#header #new_user_session').animate {
				opacity: 0, marginTop: '100%' }, MEDIUM_DURATION, ->
					$('#header .user_sessions.wrapper').remove()
			$('#header #navigation').animate {marginTop: 0}, MEDIUM_DURATION, ->
				load_initial_path()
		else # Form failure.
			errors = page.find('.inline_errors, .errors').hide()
			$('#header .wrapper').remove()
			$('#header').append(page)
			errors.slideDown(SHORT_DURATION)

	event.preventDefault()
	return false

# Load login form.
window.load_login_form = ->
	$('#header').append($('<div />').addClass('loading_message').text('Loading'))
	$.get '/login', (data) ->
		clearTimeout(window.login_timeout)
		$('#header .loading_message').remove()
		animate_container_width_to(100, false, true)
		$('#header').append(data).animate({width: '300px'}, SHORT_DURATION)

# Request the logout page and hard refresh the page.
window.handle_logout = ->
	$('#navigation .logout a').display_loading_message('Logging Out')
	$.get '/logout', -> location.href = '/'

$ ->
	
	# Handle login form submissions.
	$('#header').delegate 'form#new_user_session', 'submit.login',
		handle_login_form_submit
	
	# Make sure login forms are handled by handle_login_form_submit only.
	$('#container').undelegate 'form#new_user_session', 'submit.submit'