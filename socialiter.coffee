class Socialiter
	insertedScripts = {}
	firstScript = document.getElementsByTagName('script')[0]
	constructor: (@opts) ->
		
		@socialHandlers = {}
		@registeredsocialHandlers = {}

		@root = document.getElementById(@opts.root)

		@socialHandlers['fb-like'] = @handler_fb
		@socialHandlers['g-plusone'] = @handler_gp
		@socialHandlers['twitter-follow-button'] = @handler_tw


	init: ->
		self = this
		onmousemove = false
		elems = []
		elems.push a for a in @root.getElementsByTagName('div')
		elems.push a for a in @root.getElementsByTagName('a')
		for elem, c in elems
			if 'socialiter-' != elem.attributes.class.value.substr(0, 11)
				continue
			
			elem.parentNode.socialiterIndex = c;
			@registeredsocialHandlers[c] = elem;
			elem.parentNode.onmousemove = `function() {self.mousemoveHandler.apply(self, [this.socialiterIndex])}`

			
		null
	mousemoveHandler: (c) ->
		elem = @registeredsocialHandlers[c]
		elem.parentNode.onmousemove = undefined

		type = elem.attributes.class.value.substr(11)
		if !@socialHandlers[type]
			console.log 'Unhandled Type', type
			return null
		elem.className = 'socialiter ' + type
		@socialHandlers[type].apply(this, elem)

		#console.log this


			


	handler_fb: (elem) ->
		Socialiter.insertScript '//connect.facebook.net/en_US/all.js#xfbml=1&appId='+@opts.fbapp, 'facebook-jssdk'

	handler_gp: (elem) ->
		Socialiter.insertScript 'https://apis.google.com/js/plusone.js'

	handler_tw: (elem) ->
		Socialiter.insertScript '//platform.twitter.com/widgets.js', 'twitter-wjs'

	@insertScript: (src, id) ->
		#console.log(src, id)
		if insertedScripts[src]
			return null
		script = document.createElement('script')
		script.src = src;
		script.id  = id;
		script.async = true;

		firstScript.parentNode.insertBefore(script, @firstScript)

		insertedScripts[src] = script;


window.Socialiter = Socialiter
