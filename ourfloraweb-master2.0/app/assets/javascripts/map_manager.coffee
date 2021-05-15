@MapManager = (la,lo) ->
  _map = null
  _geoMarker = null
  _lat = la
  _lon = lo


  # Initialize our google maps object and return it
  initialize: ->
    # Bind events for expanding side menu
    $('#expand-menu').on 'click', ->
      $('#expand-menu').toggleClass('selected')
      $('#inner-container').toggleClass('menu-visible')

    # If we're on mobile, contract the side menu when the user taps the map
    if HOMESCREEN_INSTALLED
      $('#inner-container.ios').addClass('homescreen')

    # Handle the about popup
    $('#about').on 'click', -> 
      $('#overlay-dark,#popover-about-outer').css('display', 'block')
      # After a delay of 50 ms, add the class to allow the CSS transition to kick in at the next render loop
      setTimeout( ->
        $('#overlay-dark,#popover-about-outer').addClass('selected')
      , 50)

    $("#popover-about-outer #overlay-close").on 'click', ->
      $('#overlay-dark, #popover-about-outer').removeClass('selected')
      setTimeout( ->
        $('#overlay-dark, #popover-about-outer').css('display', 'none')
      , 200)

    if IS_MOBILE
      $('#map-canvas').on 'click', ->
        $('#expand-menu').removeClass('selected')
        $('#inner-container').removeClass('menu-visible')

    # Bind events for map type selection buttons
    $('#mapview-satellite').on 'click', ->
      unless $('#mapview-satellite').hasClass('selected')
        _map.setMapTypeId(google.maps.MapTypeId.SATELLITE);
        $('#mapview-standard').removeClass('selected');
        $('#mapview-satellite').addClass('selected');

    $('#mapview-standard').on 'click', ->
      unless $('#mapview-standard').hasClass('selected')
        # Cache the zoom to prevent zoomout when changing mapIdType
        zoom = _map.getZoom()
        _map.setMapTypeId(google.maps.MapTypeId.ROADMAP);
        $('#mapview-satellite').removeClass('selected');
        $('#mapview-standard').addClass('selected');
        _map.setZoom(zoom)

#set the latitude and longitude here
    # _map = new google.maps.Map $('#map-canvas')[0],
      # center:
      #   lat: 39.92,  
      #   lng: 116.46
      # zoom: 19,
      # disableDefaultUI: true,
      # mapTypeId: google.maps.MapTypeId.SATELLITE

    latlng = new google.maps.LatLng(_lat, _lon)
    _map = new google.maps.Map($('#map-canvas')[0],{
      center: latlng,
      zoom: 19,
      disableDefaultUI: true,
      disableDoubleClickZoom: true,
      mapTypeId: google.maps.MapTypeId.SATELLITE
    })

    # Add a current location marker to the map
    _geoMarker = new GeolocationMarker _map

    # Re center the map over the current position on click
    $('#current-location').on 'click', ->
      _map.panTo _geoMarker.getPosition()



    return _map
