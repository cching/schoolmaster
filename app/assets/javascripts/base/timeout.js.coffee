# Reload the page.
reload_page = ->
	window.location.reload()

window.login_timeout = setTimeout(reload_page, 3*60*60*1000)
reset_timeout = ->
	clearTimeout(window.login_timeout)
	window.login_timeout = setTimeout(reload_page, 3*60*60*1000)

$ ->
	
	# Handle ajax requests.
	$('#container').bind 'ajaxSend', reset_timeout