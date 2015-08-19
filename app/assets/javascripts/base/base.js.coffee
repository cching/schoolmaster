window.MEDIUM_DURATION  = 500
window.SHORT_DURATION   = 250
window.TINY_DURATION    = 125
window.MICRO_DURATION   = 75

window.csrf_param = ->
	hash = {}
	hash[$('head meta[name=csrf-param]').attr('content')] = $('head meta[name=csrf-token]').attr('content')
	hash