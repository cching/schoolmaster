handle_fullscreen_click = ->
	page = $(this).closest('.page')
	if page.is('.fullscreen')
		$('.page:not(#header)').trigger 'exit_fullscreen'
	else
		page.trigger 'enter_fullscreen'

enter_fullscreen = (event, callback) ->
	page = $(this)
	page.find('.title a.fullscreen').text('Exit Fullscreen')
	offset = page.offset()
	width = page.width()
	$('#meta_container').addClass('fullscreen')
	page.addClass('fullscreen').css
		width: ''
		top: offset.top
		left: offset.left
		right: $(window).width() - offset.left - width
	page.animate {
		top: 0
		left: 0
		right: 0
	}, SHORT_DURATION, ->
		callback() if $.isFunction(callback)
	unless page.children('.wrapper').is('.index')
		page.find('a').not('[href="javascript:;"]').on 'click.exit_fullscreen_first', (event) ->
			self = $(this)
			page.trigger 'exit_fullscreen', ->
				self.trigger 'click'

exit_fullscreen = (event) ->
	page = $(this)
	$('#meta_container').removeClass('fullscreen')
	page.find('.title a.fullscreen').text('Fullscreen')
	page.find('a').off 'click.exit_fullscreen_first'
	page.removeClass('fullscreen').css
		width: page.children().width()
		left: ''
		right: ''
	animate_container_width_to(page.children().width()) unless page.index()

$ ->
	$('#container').delegate 'a.fullscreen', 'click.fullscreen', handle_fullscreen_click
	
	$('#container').delegate '.page', 'enter_fullscreen', enter_fullscreen
	$('#container').delegate '.page', 'exit_fullscreen', exit_fullscreen