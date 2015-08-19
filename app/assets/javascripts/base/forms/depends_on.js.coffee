prepare_depends_on = ->
	
	$(this).find('select [data-depends-on]').each ->
		dependent = $(this)
		parent = dependent.closest('select')
		dependent_id = dependent.attr('data-depends-id')
		depends_on = "data-#{dependent.attr('data-depends-on').replace('_', '-')}"
		independent = $("[#{depends_on}]").closest('select')
		independent.change ->
			if $(this).find(':selected').attr(depends_on) == dependent_id
				dependent.appendTo(parent)
			else
				dependent.detach()
		independent.trigger('change')
		
$ ->

	# When the wrapper loads that may contain check boxes.
	$('body').delegate '.wrapper.edit, .wrapper.new, .wrapper.update, .wrapper.create',
		'loaded.depends_on', prepare_depends_on