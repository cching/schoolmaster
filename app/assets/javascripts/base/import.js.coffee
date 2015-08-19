handle_import_click = ->
	animate_in_new_content($(this), 'import')

handle_import_load = (event) ->
	update_jobs_tables($(this))

update_jobs_tables = (wrapper) ->
	if wrapper.find('#pending_table').length
		url = wrapper.closest('.page').attr('data-path') + '/import'
		$.get url, (data) ->
			wrapper.find('#import_status').replaceWith($(data).find('#import_status'))
			setTimeout((-> update_jobs_tables(wrapper)), 500)

$ ->
	
	# Handle print button clicks.
	$('#container').delegate 'a.import', 'click.import', handle_import_click
	
	# Handle new import screens.
	$('#container').delegate '.wrapper.import', 'loaded.refresh', handle_import_load