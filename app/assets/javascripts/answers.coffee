$ ->
  $('btn').click =>
    $(@).toggleClass('btn-danger').toggleClass('btn-primary')
    false 
