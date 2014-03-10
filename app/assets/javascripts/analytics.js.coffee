###
Workaround for Rails 4 Turbolinks http://stackoverflow.com/questions/18632644/google-analytics-with-rails-4
###

$(document).on 'page:change', ->
 if window._gaq?
  _gaq.push ['_trackPageview']
 else if window.pageTracker?
  pageTracker._trackPageview()