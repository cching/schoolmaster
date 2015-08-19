window.loading_message = $('<div class="loading_message">Loading</div>')

window.load_content = (wrapper, data, url, callback) ->
	scroller = wrapper.children('div.scroller')
	buttons = wrapper.find('.title a:not(.back)')
	if data
	  more_data = wrapper.find('.options_filter select').serialize()
		data = $.param data
		data = [data, more_data].join('&')
	
	scroller.find('a').remove()
	loading_message.appendTo(wrapper.find('.scroller'))
	buttons.fadeTo(TINY_DURATION, 0.5).on 'click.term_disable', (event) ->
		event.stopImmediatePropagation()
		event.preventDefault()
	
	wrapper.data('load_content_xhr').abort() if wrapper.data('load_content_xhr')
	xhr = $.get url, data, (data) ->
		callback(data) if $.isFunction(callback)
		buttons.fadeTo(TINY_DURATION, 1).off('click.term_disable')
		loading_message.remove()
		wrapper.trigger('loaded')
	wrapper.data('load_content_xhr', xhr)