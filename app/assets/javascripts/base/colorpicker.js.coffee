prepare_colorpicker = ->
	$(this).find('#bus_route_color_value, #field_color').ColorPicker(
		onSubmit: (hsb, hex, rgb, el, parent) ->
			$(el).val(hex)
			$(el).ColorPickerHide()
		onBeforeShow: ->
			$(this).ColorPickerSetColor(this.value)
	).bind 'keyup.colorpicker', ->
		$(this).ColorPickerSetColor(this.value)

$ ->
	
	$('#container').delegate '.edit.wrapper, .new.wrapper, .create.wrapper, .new.wrapper',
		'loaded.colorpicker', prepare_colorpicker