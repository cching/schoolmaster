$ ->
	
	# Replace the text in this to the message passed as an argument or the
	# default 'Loading' and animates periods (., .., ...) after the message.
	# @param {String} message
	$.fn.display_loading_message = (message = 'Loading') ->
		this.each ->
			self = $(this).addClass('loading')
			method = if self.is(':submit') then 'val' else 'text'
			self.on 'click.loading_disable', (event) ->
				event.stopImmediatePropagation()
				event.preventDefault()
			self.attr('data-previous-text': self[method]())
			periods = ''
			update_text = ->
				self[method]("#{message}#{periods}")
				periods = if periods.length > 2 then '' else "#{periods}."
				self.data('loading_message_timeout', setTimeout(update_text, 500))
			update_text()
	
	# Reverses the effect of display_loading_message by replacing the original
	# text.
	$.fn.hide_loading_message = ->
		this.each ->
			$(this).removeClass('loading').off('click.loading_disable')
			clearTimeout($(this).data('loading_message_timeout'))
			method = if $(this).is(':submit') then 'val' else 'text'
			$(this)[method]($(this).attr('data-previous-text'))
