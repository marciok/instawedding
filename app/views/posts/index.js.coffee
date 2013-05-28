jQuery =>

  fullScreen = ->
    addEventListener "click", ->
      el = document.documentElement
      rfs = el.requestFullScreen or el.webkitRequestFullScreen or el.mozRequestFullScreen
      rfs.call el
  fullScreen()
  slider = new BuildSlider()
  remote = new RemoteControl()
  remote.subscribe()

  $('img').error -> $(this).hide()

class BuildSlider
  constructor: ->
    @slides = 
      <%= ActiveSupport::JSON.encode(
        @posts.map do |post|
          {
            image: post.image.standart,
            title: "<div class='caption'><img width='60px' src='#{post.image.profile}' /><h2>#{post.author}</h2><p>#{post.text}</p>",
            thumb: post.image.thumbnail
          }
        end
      ).html_safe %>

    @setup =
      slideshow: 1 # Slideshow on/off
      autoplay: 1 # Slideshow starts playing automatically
      stop_loop: 0 # Pauses slideshow on last slide
      start_slide: <% if @posts.count < 14 %>0<% else %>1<% end %>  # Start slide (0 is random)
      random: 0 # Randomize slide order (Ignores start slide)
      slide_interval: 7000 # Length between transitions
      transition: 6 # 0-None, 1-Fade, 2-Slide Top, 3-Slide Right, 4-Slide Bottom, 5-Slide Left, 6-Carousel Right, 7-Carousel Left
      transition_speed: 1000 # Speed of transition
      new_window: 0 # Image links open in new window/tab
      pause_hover: 0 # Pause slideshow on hover
      keyboard_nav: 1 # Keyboard navigation on/off
      performance: 2 # 0-Normal, 1-Hybrid speed/quality, 2-Optimizes image quality, 3-Optimizes transition speed // (Only works for Firefox/IE, not Webkit)
      image_protect: 1 # Disables image dragging and right click with Javascript
      # Size & Position						   
      min_width: 0 # Min width allowed (in pixels)
      min_height: 0 # Min height allowed (in pixels)
      vertical_center: 1 # Vertically center background
      horizontal_center: 1 # Horizontally center background
      fit_always: 1 # Image will never exceed browser width or height (Ignores min. dimensions)
      fit_portrait: 0 # Portrait images will not exceed browser height
      fit_landscape: 0 # Landscape images will not exceed browser width
      # Components							
      slide_links: false # Individual links for each slide (Options: false, 'num', 'name', 'blank')
      thumb_links: 1 # Individual thumb links for each slide
      thumbnail_navigation: 1 # Thumbnail navigation
      # Theme Options
      progress_bar: 1 # Timer for each slide
      mouse_scrub: 0

    @build()

  build: =>
    @clean()
    @setup.slides = @slides
    $.supersized(@setup)

  clean: =>
    $('#supersized').html('')
    $('#thumb-tray').html('')
    $('.caption-wrapper').html('')


  addSlide: =>
    console.info 'im on addslide'
    $.getJSON 'posts/last.json', (data) =>
      if data != undefined
        @slides.push({
          image: data.post.image
          title: "<div class='caption-wrapper'><img width='60px' src='#{data.post.profile}' /><h2>#{data.post.author}</h2><p>#{data.post.text}</p>",
          thumb: data.post.thumb
        })
      @build()

class RemoteControl

  constructor: -> 
    @client = new Faye.Client 'http://instsaw-faye.herokuapp.com/faye'

  subscribe: =>
    @client.subscribe '/commands', (command) ->
      console.info command
      switch command
        when 'play-toggle'
          api.playToggle()
        when 'next'
          api.nextSlide()
        when 'reload'
          location.reload()



