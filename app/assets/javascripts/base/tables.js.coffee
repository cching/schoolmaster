# Handle table header clicks.
handle_table_header_click = (event) ->
	$(this).siblings().removeClass('sorted reverse')
	if $(this).is('.sorted')
		$(this).toggleClass('reverse')
	else
		$(this).addClass('sorted')
	load_results($(this).closest('.wrapper'))

# If the table is sorted, insert the row in the correct position, otherwise
# just append it.
# @param {jQuery} table
# @param {String} row
window.insert_row = (table, row) ->
	table = $(table)
	row = $(row)
	id = row.attr('data-id')
	same_id = table.find("a[data-id='#{id}']")
	if same_id.length
		same_id.html(row.html())
	else
		table.append(row)
	update_count(table)
	table.find('input.search').trigger('keyup.search')

# Update the count of rows in the previous page.
window.update_count = (table) ->
	table = $(table)
	count = table.children('a').length
	page = $(table).closest('.page')
	path = page.attr('data-path')
	page.next('.page').find("a:urlInternal[href$='#{path}']")
		.find('span span').text(count)

# Find the row with data-id=id and remove it from the table.
# @param {jQuery} table
# @param {String} id
window.remove_row = (table, id) ->
	$(table).find("a[data-id='#{id}']").slideUp MEDIUM_DURATION, ->
		$(this).remove()
		update_count(table)

# Handle search button click.
handle_search_click = (event) ->
	self = $(this)
	wrapper = self.closest('.wrapper')
	table = wrapper.find('div.table')
	rows = $(table).find('a')
	search_field = $('<input type="text" class="search" />')
	clear_button = $('<i class="clear"></i>')
	width = self.width() - 20
	search_container = $('<div />').addClass('search_container')
	keydown_timeout = null
	search_container.append(search_field).append(clear_button).insertAfter(self)
	self.detach()

	clear_button.hide().fadeIn(SHORT_DURATION)
		.bind 'click.clear', ->
			$(this).siblings('.search').val('').trigger('blur.unsearch')
	search_field.css(width: width, opacity: 0)
		.animate({ width: '150px', opacity: 1 }, SHORT_DURATION, ->
			$(this).focus()
		).bind('keydown.search', ->
			clearTimeout(keydown_timeout)
			input = $(this)
			keydown_timeout = setTimeout (->
				value = input.val()
				if value != input.data('prev_val')
					input.data('prev_val', value)
					load_results(wrapper)
			), 500
		).bind 'blur.unsearch', ->
			unless $(this).val()
				load_results(wrapper)
				$(this).siblings('.clear').fadeOut TINY_DURATION, ->
					$(this).remove()
				$(this).animate { width: width, opacity: 0 }, TINY_DURATION, ->
					$(this).after(self)
					$(this).remove()

handle_options_filter_change = ->
	load_results($(this).closest('.wrapper'))

search_and_sort_data = (wrapper, table) ->
  data = {}
  
  if search = wrapper.find('.search_container input').val()
    data['search'] = search
  
  if (sorted = table.find('div .sorted')).length
    direction = if sorted.hasClass('reverse') then 'desc' else 'asc'
    column = sorted.attr('data-order-by')
    data['order'] = "#{column} #{direction}"
  
  data

window.load_results = (wrapper, print, callback) ->
	url = wrapper.closest('.page').attr('data-path')
	table = wrapper.find('.table')
	data = search_and_sort_data(wrapper, table)
	data['print'] = true if print
	
	load_content wrapper, data, url, (data) ->
		data = $(data)
		table = wrapper.find('div.table')
		table.append(data.find('.table a'))
		table.attr('data-offset', table.attr('data-limit'))
		replaced = table.find('div span.replace')
		replaced.first().after(data.find('.table div span.replace'))
		replaced.remove()

		select_path(wrapper.closest('.page'))
		selected = table.find('.selected')
		wrapper.find('div.scroller').scrollTo(selected) if selected.length
		wrapper.trigger('loaded')
		callback() if $.isFunction(callback)

handle_index_loaded = ->
  wrapper = $(this)
  scroller = wrapper.find('.scroller')
  if !scroller.data('infiniscroll') # Avoid attaching multiple scrol events after loaded is fired
    scroller.data('infiniscroll', true)
    table = scroller.find('.table')
    loading = false
    old_offset = 0
    scroller.on 'scroll.infiniscroll', (event) ->
      if !loading && scroller.scrollTop() / table.height() > 0.5
        loading = true
        load_more_records wrapper, table, (new_offset, more_records) ->
          if more_records
            old_offset = new_offset
          else
            scroller.off 'scroll.infiniscroll'
            infiniscroll_loading.detach()
          loading = false

load_more_records = (wrapper, table, callback) ->
  return if table.attr('data-limit') == 0
  data = search_and_sort_data(wrapper, table)
  data['offset'] = table.attr('data-offset')
  
  more_data = wrapper.find('.options_filter select').serialize()
  data = $.param data
  data = [data, more_data].join('&')
  
  infiniscroll_loading.insertAfter(table)
  $.get table.closest('.page').attr('data-path'), data, (data) ->
    data = $(data)
    infiniscroll_loading.detach()
    new_records = data.find('.table a')
    table.append(new_records)
    new_offset = data.find('.table').attr('data-offset')
    table.attr('data-offset', new_offset)
    callback(new_offset, !!new_records.length)
    table.trigger('infiniscrolled')

infiniscroll_loading = $('<div/>').addClass('infiniscroll_loading')

$ ->

	# Handle table header clicks.
	$('body').delegate 'div.table div span.sortable',
		'click.sort', handle_table_header_click

	# Handle search button clicks.
	$('#container').delegate 'a.search', 'click.search', handle_search_click

	# Prepare term filter.
	$('#container').delegate '.options_filter select', 'change.options_filter', handle_options_filter_change
	
	$('#container').delegate '.index.wrapper', 'loaded.prepare_infiniscroll', handle_index_loaded