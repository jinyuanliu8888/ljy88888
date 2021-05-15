# Define SpeciesManager in the global window space as window.SpeciesManager
@SpeciesManager = ->
  # Private variables, functions and backbone objects
  _speciesOuterListView = null
  _trailOuterListView = null
  _familyOuterListView = null

  _speciesRaw = null
  _trailsRaw = null
  _familiesRaw = null

  _map = null
  _trailPath = null
  _trailPoints = []
  # Store a reference to the currently open google maps pin window
  _openInfoBox = null
  # Store a reference to the most recently selected location so that we can place it in a tweet
  _recentLocation = null
  # Store all markers for efficiency when hiding everything
  _markers = []
  # Use markerclusterer.js to cluster groups of markers together
  _markerClusterer = null

  # Redefine the template interpolation character used by underscore (to @ from %) to prevent conflicts with rails ERB
  _.templateSettings =
    evaluate:    /\<\@(.+?)\@\>/g,
    interpolate: /\<\@=(.+?)\@\>/g,
    escape:      /\<\@-(.+?)\@\>/g

  # Closes the currently open info box
  closeInfoBox = (infoBox, now = false) ->
    if infoBox
      $('.species-infobox-outer').removeClass('visible')
      if now
        infoBox.close()
      else
        setTimeout ->
          infoBox.close()
        , 300


  # VIEWS -------------------------------------------------------------------------------
  # View for selected species shown in the center of the screen
  SpeciesPopoverView = Backbone.View.extend(
    # Id and class name for popover view
    className: if IS_MOBILE then 'popover-inner-mobile' else 'popover-inner'
    id: 'popover-inner'
    # Select the underscore template to use, found in view/_map.html.erb
    template: _.template($('#species-popover-template').html())

    events:
      'click .picture': 'fullscreenPicture'

    initialize: ->
      self = @

      # Don't close the window if the user clicked inside, only if they clicked on the grey part outside
      $('#popover-outer').on 'click', '#popover-inner', (e) ->
        e.stopPropagation()

      $('#popover-outer').on 'click', (e) ->
        self.closeOverlay()

    # Define javascript events for popover
    events:
      'click #overlay-close' : 'closeOverlay'
      'click #highlight-map' : 'showOnMap'

    # Open a picture in a new tab
    fullscreenPicture: (e) ->
      window.open(url,'_blank');

    # Fade out the overlay and set display to none to prevent invisible z index problems
    closeOverlay: ->
      self = @
      $('#overlay-dark-species, #popover-outer').removeClass('selected')
      setTimeout ->
        $('#overlay-dark-species,#popover-outer').css('display', 'none')
        # After we've faded out the popover, remove it from the DOM
        self.remove()
      , 200

    # Highlights the popover species on the map
    showOnMap: ->
      # Hide all markers
      _familyOuterListView.hideAll()

      # Show markers for this species
      @model.trigger('show')
      @model.trigger('fitMapToScreen')
      @closeOverlay()

      # Close the side menu when exiting the overlay if we're on mobile
      if IS_MOBILE
        $('#expand-menu').removeClass('selected')
        $('#inner-container').removeClass('menu-visible')

    render: ->
      # Render the element from the template and model
      @$el.html @template(@model.toJSON())
      # Cache self to use inside the timeout block
      self = @
      # Set display to block from none
      $('#overlay-dark-species,#popover-outer').css('display', 'block')
      # After a delay of 50 ms, add the class to allow the CSS transition to kick in at the next render loop
      setTimeout ->
        $('#overlay-dark-species,#popover-outer').addClass('selected')
        # Initialize the share widget
        new Share ".share-button",
          url: "campusflora.sydneybiology.org/species/#{self.model.get('slug')}"
          title: "#{self.model.get('genusSpecies')}"
          description: "#{self.model.get('genusSpecies')} @campusflora - campusflora.sydneybiology.org/species/#{self.model.get('slug')}"
          ui:
            button_text: 'Share'
          networks:
            facebook:
              image: "http://campusflora.sydneybiology.org/#{if self.model.get('images').length > 0 then self.model.get('images')[0].image_url else IMG_NOT_FOUND_ORIGINAL}"
            pinterest:
              enabled: false
            twitter:
              description: "I found #{self.model.get('genusSpecies')} on campus! via @CampusFloraOz campusflora.sydneybiology.org/species/#{self.model.get('slug')}"
        # Bind photoswipe on the image gallery
        if self.model.get('images').length > 0
          bindPhotoSwipe '.images'
      , 50
      this
  )

  SpeciesLocationPopoverView = Backbone.View.extend(
    # Id and class name for popover view
    className: if IS_MOBILE then 'popover-inner-mobile' else 'popover-inner'
    id: 'popover-inner'
    # Select the underscore template to use, found in view/_map.html.erb
    template: _.template($('#species-location-popover-template').html())

    events:
      'click .picture': 'fullscreenPicture'

    initialize: ->
      self = @

      # Don't close the window if the user clicked inside, only if they clicked on the grey part outside
      $('#popover-outer').on 'click', '#popover-inner', (e) ->
        e.stopPropagation()

      $('#popover-outer').on 'click', (e) ->
        self.closeOverlay()

    # Define javascript events for popover
    events:
      'click #overlay-close' : 'closeOverlay'
      'click #highlight-map' : 'showOnMap'

    # Open a picture in a new tab
    fullscreenPicture: (e) ->
      window.open(url,'_blank');

    # Fade out the overlay and set display to none to prevent invisible z index problems
    closeOverlay: ->
      self = @
      $('#overlay-dark-species, #popover-outer').removeClass('selected')
      setTimeout ->
        $('#overlay-dark-species,#popover-outer').css('display', 'none')
        # After we've faded out the popover, remove it from the DOM
        self.remove()
      , 200

    # Highlights the popover species on the map
    showOnMap: ->
      # Hide all markers
      _familyOuterListView.hideAll()

      # Show markers for this species
      @model.get('backboneModel').trigger('show')
      @model.get('backboneModel').trigger('fitMapToScreen')
      @closeOverlay()

      # Close the side menu when exiting the overlay if we're on mobile
      if IS_MOBILE
        $('#expand-menu').removeClass('selected')
        $('#inner-container').removeClass('menu-visible')

    render: ->
      # Render the element from the template and model
      @$el.html @template(@model.toJSON())
      # Cache self to use inside the timeout block
      self = @
      # Set display to block from none
      $('#overlay-dark-species,#popover-outer').css('display', 'block')
      # After a delay of 50 ms, add the class to allow the CSS transition to kick in at the next render loop
      setTimeout ->
        $('#overlay-dark-species,#popover-outer').addClass('selected')
        # Initialize the share widget
        new Share ".share-button",
          url: "campusflora.sydneybiology.org/species/#{self.model.get('slug')}"
          title: "#{self.model.get('genusSpecies')}"
          description: "#{self.model.get('genusSpecies')} @campusflora - campusflora.sydneybiology.org/species/#{self.model.get('slug')}"
          ui:
            button_text: 'Share'
          networks:
            facebook:
              image: "http://campusflora.sydneybiology.org/#{if self.model.get('images').length > 0 then self.model.get('images')[0].image_url else IMG_NOT_FOUND_ORIGINAL}"
            pinterest:
              enabled: false
            twitter:
              description: "I found #{self.model.get('genusSpecies')} on campus! via @CampusFloraOz campusflora.sydneybiology.org/species/#{self.model.get('slug')}"
        # Bind photoswipe on the image gallery
        if self.model.get('images').length > 0
          bindPhotoSwipe '.images'
      , 50
      this
  )

  SpeciesMapView = Backbone.View.extend(
    # Cache the parent model so we can access species data in each sub location
    parentModel: null

    # Initialize google maps objects and set the parent model
    initMapComponents: (parentModel, listView) ->
      self = @

      @parentModel = parentModel
      # Define google maps info window (little box that pops up when you click a marker)
      infoTemplate = _.template($('#species-infobox-template').html())
      # Add arborplan id to our attributes
      attributes = _.extend({}, @parentModel.attributes, @model.attributes)
      attributes.species_information = @parentModel.get('information')
      attributes.location_information = @model.get('information')
      attributes.backboneModel = @parentModel
      attributes['arborplan_id'] = @model.get('arborplan_id')
      attributes['id'] = @model.get('id')

      # Initialize the little popup box when you click the marker
      @infoBox = new InfoBox(
        content: infoTemplate(attributes)
        pixelOffset: new google.maps.Size(-146, -105)
        closeBoxURL: ''
      )

      # Override the appear functionality of infobox so we can animate it's appearance
      google.maps.event.addListener @infoBox, 'domready', ->
        $('.species-infobox-outer').addClass('visible')

      # Define google maps marker (red balloon over species on map)
      @marker = new google.maps.Marker(
        position: new google.maps.LatLng(@model.get('lat'), @model.get('lon'));
        map: _map
        title: @parentModel.get('genusSpecies')
      )

      @marker.attributes = @model.attributes

      _markers.push @marker

      # Add click event listener for the map pins
      google.maps.event.addListener @marker, "click", ->
        closeInfoBox(_openInfoBox, true)
        self.infoBox.open _map, self.marker
        _openInfoBox = self.infoBox
        _recentLocation = "(#{self.model.get('lat')}, #{self.model.get('lon')})"
        # Prevent the event from bubbling up so the infoBox will stay open
        return false

      # Bind the click event on the new infobox to show the popover
      google.maps.event.addListener @infoBox, 'domready', ->
        $("#infobox-#{self.model.get('id')}").on 'click', ->
          self.model.set('tweetLocation', _recentLocation)
          popover = new SpeciesLocationPopoverView({model: new SpeciesModel(attributes)})
          $('#popover-outer').append(popover.render().el)

    # Methods for hiding and showing google maps markers
    hideMarker: ->
      @marker.setMap(null)

    showMarker: ->
      @marker.setMap(_map)
  )

  # View for species in menu list
  SpeciesListView = Backbone.View.extend(
    # Set class name for generated view
    className: 'list-row'
    # Select the underscore template to use, found in view/_species.html.erb
    template: _.template($('#list-row-template').html())
    # Store google maps data
    mapViews: null
    # Define javascript events
    events:
      'click': 'listItemClicked'

    initialize: ->
      # Initialize the array to prevent sharing of data between extended views
      @mapViews = []
      # If there are locations defined for these species, set up new species map views
      for location in @model.get('species_locations')
        # Create a new SpeciesMapView with location data
        mapView = new SpeciesMapView(model: new LocationModel(location))
        # Set up google maps components associated with the species map view
        mapView.initMapComponents @model, @
        # Save the mapview into the array in this model
        @mapViews.push(mapView)

      # Bind the hide and show events for the model to propogate to the views
      @model.on 'hide', @hidePins, @
      @model.on 'show', @showPins, @
      @model.on 'fitMapToScreen', @fitMapToScreen, @
      @model.on 'showListView', @showListView, @

    listItemClicked: ->
      firstLocation = @model.get('species_locations')[0]
      _recentLocation = "(#{firstLocation.lat}, #{firstLocation.lon})"
      @showPopover()


    # When clicked, show the central popover with the corresponding data
    showPopover: ->
      # Pass the location of the selected species to the model so the user can tweet about it
      @model.set('tweetLocation', _recentLocation)
      popover = new SpeciesPopoverView({model: @model})
      $('#popover-outer').append(popover.render().el)
      # TODO: push a new browser history state to navigate to this species

    hidePins: ->
      for mapView in @mapViews
        mapView.hideMarker()

    showPins: ->
      for mapView in @mapViews
        mapView.showMarker()

    # Zooms and pans the google map to fit all currently showing markers
    fitMapToScreen: ->
      # Create a new boundary object
      bounds = new google.maps.LatLngBounds()
      # Extend the outside of the boundaries to fit the pins
      for mapView in @mapViews
         bounds.extend mapView.marker.getPosition()
      # Center the map to the geometric center of all markers
      #_map.setCenter bounds.getCenter()
      # Fit boundaries
      _map.fitBounds bounds
      # Remove one zoom level to ensure no marker is on the edge.
      #_map.setZoom(_map.getZoom() - 1)
      # Set a minimum zoom to prevent excessive zoom in if there's only 1 marker
      if _map.getZoom() > 19 then _map.setZoom 19
      # Set a max zoom to prevent excessive zoom if the markers are across a wide area
      #if _map.getZoom() < 17 then _map.setZoom 17

    showListView: ->
      @$el.removeClass 'hidden'

    render: ->
      # Add the species to the species list
      @$el.html @template(@model.toJSON())
      # Render the pin on the map
      this
  )

  # The outer backbone view for the species list
  SpeciesOuterListView = Backbone.View.extend(
    el: '#menu-content-species'

    events:
      'keypress .search-box' : 'searchEvent'
      'click .icon-cancel-circled' : 'clearSearch'

    # Define methods to be run at initialization time
    initialize: ->
      # Create a new species collection to hold the data
      @collection = new speciesCollection(_speciesRaw);
      # Whenever a new object is added to the collection, render it's corresponding view
      @collection.bind 'add', @appendItem
      # Call this view's render() function to render all the initial models that might have been added
      @render()

    render: ->
      # For each model in the collection, render and append them to the list view
      _(@collection.models).each (model) ->
        @appendItem model;
      , @

    appendItem: (model) ->
      # Create a new species view based on the model data
      view = new SpeciesListView({model: model})
      # Since we need to group the list by family, check if a family outer grouped element already exists
      $className = "list-family-#{model.get('family').name.replace(' ', '').toLowerCase()}"
      $selector = $(".#{$className}")
      $familyElement = null
      # If there isn't a family subheading, create one and append it to the list box
      if $selector.length > 0
        $familyElement = $selector
      else
        @$el.append("<div class=\"#{$className} list-subheader\">#{model.get('family').name}</div>")
        $selector = $(".#{$className}")

      # Render the species view in the outer container
      @$el.append(view.render().el)

    clearSearch: ->
      @$el.find('.search-box').val('')
      # Just search for blank to clear the search
      @searchCollection('')

    searchEvent: (event) ->
      # Get the new character being typed and append it to the current value of the input box
      newchar = String.fromCharCode(event.charCode || event.keyCode)
      value = @$el.find('.search-box').val()
      # If the character pressed was backspace, remove one char from the end of the string, else append it
      terms = if event.keyCode == 8 then value.substring(0, value.length - 1) else terms = "#{@$el.find('.search-box').val()}#{newchar}"
      @searchCollection(terms)

    # Uses lunr full text search to search the collection for models, based on the search field
    searchCollection: (terms) ->
      # If the user has just deleted all their search terms, show the empty search box and close button
      unless (terms.length > 0)
        @$el.find('.search-box-outer i.icon-search').removeClass 'hidden'
        @$el.find('.search-box-outer i.icon-cancel-circled').addClass 'hidden'
        $('.list-row').removeClass 'hidden'
        $('.list-subheader').removeClass 'hidden'
        return

      # Hide the search icon if the user has typed letters into the box
      @$el.find('.search-box-outer i.icon-search').addClass 'hidden'
      # Show the clear textbox icon
      @$el.find('.search-box-outer i.icon-cancel-circled').removeClass 'hidden'
      results = @collection.search terms
      $('.list-row').addClass 'hidden'
      $('.list-subheader').addClass 'hidden'
      for model in results
        model.trigger 'showListView'
  )

  # View for families in list
  FamilyListView = Backbone.View.extend(
    # Set class name for generated view
    className: 'family-row'
    # Select the underscore template to use, found in view/_species.html.erb
    template: _.template($('#family-row-template').html())
    # Define javascript events
    events:
      'click' : 'toggleFamily'

    # Whether or not this row is selected - (showing family species on the map)
    selected: true

    initialize: ->
      # Bind listener functions for the parent model
      @model.on('hide', @hide, @)
      @model.on('show', @show, @)

    # Called when all families are being hidden - just set selected to false and uncheck checkbox
    hide: ->
      @$el.find('.checkbox').removeClass 'selected'
      @selected = false

    # Called when all families are being hidden - just set selected to false and uncheck checkbox
    show: ->
      @$el.find('.checkbox').addClass 'selected'
      @selected = true

    # Hides / displays the species managed by this family on the map
    toggleFamily: ->
      # Remove selected class from the checkbox inside this view
      if @selected then @$el.find('.checkbox').removeClass 'selected' else @$el.find('.checkbox').addClass 'selected'

      # Loop through and hide or show the species markers
      speciesModels = []
      for speciesObject in @model.get('species')
        found = _speciesOuterListView.collection.where({id: speciesObject.id})
        if found.length > 0
          for speciesModel in found
            speciesModels.push speciesModel

      for speciesModel in speciesModels
        if @selected then speciesModel.trigger('hide') else speciesModel.trigger('show')

      # Flip the selected bool
      @selected = !@selected

    addSpecies: (species) ->
      @species.push(species)

    render: ->
      # Add the family to the families list
      @$el.html @template(@model.toJSON())
      this
  )

  # The outer backbone view for the species list
  FamilyOuterListView = Backbone.View.extend(
    el: '#menu-content-families'

    events:
      'click #family-select-all': 'selectAll'
      'click #family-unselect-all': 'hideAll'

    # Define methods to be run at initialization time
    initialize: ->
      # Create a new species collection to hold the data
      @collection = new familiesCollection(_familiesRaw);
      # Whenever a new object is added to the collection, render it's corresponding view
      @collection.bind 'add', @appendItem
      # Call this view's render() function to render all the initial models that might have been added
      @render()

    render: ->
      # For each model in the collection, render and append them to the list view
      _(@collection.models).each (model) ->
        @appendItem model;
      , @

    appendItem: (model) ->
      # Create a new species view based on the model data
      view = new FamilyListView({model: model})
      # Render the species view in the outer container
      @$el.append(view.render().el)

    selectAll: ->
      # First, show all markers
      for marker in _markers
        marker.setMap(_map)

      # Then, mark all families as selected
      @collection.each (model) ->
        model.trigger('show')

      if _trailPath then _trailPath.setMap(null)

    hideAll: ->
      # First, hide all markers
      for marker in _markers
        marker.setMap(null)
        closeInfoBox(_openInfoBox)

      if _trailPath then _trailPath.setMap(null)
      # Then, uncheck all selected families
      @collection.each (model) ->
        model.trigger('hide')
  )

  # View for selected species shown in the center of the screen
  TrailPopoverView = Backbone.View.extend(
    # Id and class name for popover view
    className: if IS_MOBILE then 'popover-inner-mobile' else 'popover-inner'
    id: 'popover-inner'
    # Select the underscore template to use, found in view/_map.html.erb
    template: _.template($('#trail-popover-template').html())

    events:
      'click .picture': 'fullscreenPicture'

    initialize: ->
      self = @

      # Don't close the window if the user clicked inside, only if they clicked on the grey part outside
      $('#popover-outer').on 'click', '#popover-inner', (e) ->
        e.stopPropagation()

      $('#popover-outer').on 'click', (e) ->
        self.closeOverlay()

    # Define javascript events for popover
    events:
      'click #overlay-close' : 'closeOverlay'
      'click #highlight-map' : 'showOnMap'

    # Open a picture in a new tab
    fullscreenPicture: (e) ->
      # window.open(url,'_blank');

    # Fade out the overlay and set display to none to prevent invisible z index problems
    closeOverlay: ->
      self = @
      $('#overlay-dark-trail, #popover-outer').removeClass('selected')
      setTimeout ->
        $('#overlay-dark-trail,#popover-outer').css('display', 'none')
        # After we've faded out the popover, remove it from the DOM
        self.remove()
      , 200

    # Highlights the popover species on the map
    showOnMap: ->
      # Hide all markers
      _familyOuterListView.hideAll()

      @model.trigger('toggleTrail')
      @closeOverlay()

      # Close the side menu when exiting the overlay if we're on mobile
      if IS_MOBILE
        $('#expand-menu').removeClass('selected')
        $('#inner-container').removeClass('menu-visible')

    render: ->
      # Render the element from the template and model
      @$el.html @template(@model.toJSON())
      # Cache self to use inside the timeout block
      self = @
      # Set display to block from none
      $('#overlay-dark-trail,#popover-outer').css('display', 'block')
      # After a delay of 50 ms, add the class to allow the CSS transition to kick in at the next render loop
      setTimeout ->
        $('#overlay-dark-trail,#popover-outer').addClass('selected')
        # Initialize the share widget
        new Share ".share-button",
          url: "campusflora.sydneybiology.org/trails/#{self.model.get('slug')}"
          title: "#{self.model.get('name')}"
          description: "#{self.model.get('name')} @campusflora - campusflora.sydneybiology.org/trails/#{self.model.get('slug')}"
          ui:
            button_text: 'Share'
          networks:
            facebook:
              image: "http://campusflora.sydneybiology.org/#{IMG_NOT_FOUND_ORIGINAL}"
            pinterest:
              enabled: false
            twitter:
              description: "I found #{self.model.get('name')} on campus! via @CampusFloraOz campusflora.sydneybiology.org/trails/#{self.model.get('slug')}"
      , 50
      this
  )

  # The view for each row in the trails menu
  TrailListView = Backbone.View.extend(
    # Set class name for generated view
    className: 'trail-row'
    # Set outer container for these rows to live in
    outerContainer: '#menu-content-trails'
    # Select the underscore template to use, found in view/_species.html.erb
    template: _.template($('#trail-row-template').html())
    # Define javascript events
    events:
      'click .information' : 'showPopover'
      'click' : 'toggleTrail'

    initialize: ->
      @model.on 'toggleTrail', @toggleTrail, @
      @render()

    # When clicked, show the central popover with the corresponding data
    showPopover: (event) ->
      # Pass the location of the selected species to the model so the user can tweet about it
      @model.set('tweetLocation', _recentLocation)
      popover = new TrailPopoverView({model: @model})
      $('#popover-outer').append(popover.render().el)
      # TODO: push a new browser history state to navigate to this species
      event.stopImmediatePropagation();

    # Hides / displays the species managed by this family on the map
    toggleTrail: (event) ->
      # If it's already selected, toggle off by removing selected class from the checkbox inside this view
      if @$el.find('.checkbox').hasClass('selected')
        @$el.find('.checkbox').removeClass('selected')
        # Show all remaining markers
        _familyOuterListView.selectAll()

      else
        # Re draw the line between the points on the trail
        drawTrailLine = () =>
          if (_trailPath)
            _trailPath.setMap(null)
            _trailPath = null

          _trailPath = new google.maps.Polyline
            strokeColor: '#69D2E7'
            strokeOpacity: 1.0
            strokeWeight: 5

          path = _trailPath.getPath()

          for point in _trailPoints
            path.push(point.getPosition())

          _trailPath.setMap(_map)

        # Unselect all other trails
        @$el.parent().find('.trail-row .checkbox').removeClass('selected')

        # Remove all markers from the map
        _familyOuterListView.hideAll()

        for mapMarker in _markers
          mapMarker.setMap(null)

        for mapMarker in _trailPoints
          mapMarker.setMap(null)

        _trailPoints = []

        # Push all the points into a polyline
        for point in @model.get('points')
          if point.type == 'species'
            for mapMarker in _markers
              if point.species_location_id == mapMarker.attributes.id
                mapMarker.setMap(_map)
                _trailPoints.push(mapMarker)
          else if point.type == 'point'
            marker = new google.maps.Marker
              map: _map
              animation: google.maps.Animation.DROP
              position:
                lat: parseFloat(point.lat)
                lng: parseFloat(point.lon)
              icon: 'http://maps.google.com/mapfiles/kml/paddle/blu-circle-lv.png'

            _trailPoints.push(marker)

        drawTrailLine()
        @$el.find('.checkbox').addClass('selected')

    render: ->
      # Render and return the trail element
      @$el.html @template(@model.toJSON())
      this
  )

  # The outer backbone view for the species list
  TrailOuterListView = Backbone.View.extend(
    el: '#menu-content-trails'

    # Define methods to be run at initialization time
    initialize: ->
      # Create a new species collection to hold the data
      @collection = new trailsCollection(_trailsRaw);
      # Whenever a new object is added to the collection, render it's corresponding view
      @collection.bind 'add', @appendItem
      # Call this view's render() function to render all the initial models that might have been added
      @render()

    render: ->
      # For each model in the collection, render and append them to the list view
      _(@collection.models).each (model) ->
        @appendItem model;
      , @

    appendItem: (model) ->
      # Create a new species view based on the model data
      view = new TrailListView({model: model})
      # Render the species view in the outer container
      @$el.append(view.render().el)
  )

  # MODELS ----------------------------------------------------------------------------------------
  # Model that holds each species
  SpeciesModel = Backbone.Model.extend({})

  # Model that holds a locations for species
  LocationModel = Backbone.Model.extend({})

  # Model that holds family data
  FamilyModel = Backbone.Model.extend({})

  # Model that holds trail data
  TrailModel = Backbone.Model.extend({})


  # COLLECTIONS -----------------------------------------------------------------------------------
  # Collection that holds JSON returned from /species.json
  speciesCollection = Backbone.Collection.Lunr.extend(
    # Provide a URL to pull JSON data from
    url: '/species.json'
    # Use the species model
    model: SpeciesModel
    # Specify fields to search with Lunr full text search
    lunroptions:
      fields: [
          { name: "genusSpecies", boost: 10 }
          { name: "commonName", boost: 5 }
      ]

    comparator: (model) ->
      model.get('family').name
  )

  # Collection that holds JSON returned from /trails.json
  trailsCollection = Backbone.Collection.extend(
    # Provide a URL to pull JSON data from
    url: '/trails.json'
    # Use the species model
    model: TrailModel
  )

  # Collection that holds families returned from /families.json
  familiesCollection = Backbone.Collection.extend(
    # Provide a URL to pull JSON data from
    url: '/families.json'
    # Use the species model
    model: FamilyModel
  )

  # Species Detail View
  DetailSpeciesView = Backbone.View.extend(
    el: '#detail-species'

    # Define methods to be run at initialization time
    initialize: ->
      locArr = window.location.href.split("/")
      slug = locArr[4]
      coll = new speciesCollection(_speciesRaw)
      @model = coll.find (mod) ->
        return slug.toLowerCase() is mod.get('slug')

      @mapViews = []
      # If there are locations defined for these species, set up new species map views
      for location in @model.get('species_locations')
        # Create a new SpeciesMapView with location data
        mapView = new SpeciesMapView(model: new LocationModel(location))
        # Set up google maps components associated with the species map view
        mapView.initMapComponents @model, @
        # Save the mapview into the array in this model
        @mapViews.push(mapView)

      @model.on 'hide', @hidePins, @
      @model.on 'show', @showPins, @
      @model.on 'fitMapToScreen', @fitMapToScreen, @

      @render()

    hidePins: ->
      for mapView in @mapViews
        mapView.hideMarker()

    showPins: ->
      for mapView in @mapViews
        mapView.showMarker()

    # Zooms and pans the google map to fit all currently showing markers
    fitMapToScreen: ->
      # Create a new boundary object
      bounds = new google.maps.LatLngBounds()
      # Extend the outside of the boundaries to fit the pins
      for mapView in @mapViews
         bounds.extend mapView.marker.getPosition()
      # Center the map to the geometric center of all markers
      #_map.setCenter bounds.getCenter()
      # Fit boundaries
      _map.fitBounds bounds
      # Remove one zoom level to ensure no marker is on the edge.
      #_map.setZoom(_map.getZoom() - 1)
      # Set a minimum zoom to prevent excessive zoom in if there's only 1 marker
      if _map.getZoom() > 19 then _map.setZoom 19
      # Set a max zoom to prevent excessive zoom if the markers are across a wide area
      #if _map.getZoom() < 17 then _map.setZoom 17

    render: ->
      firstLocation = @model.get('species_locations')[0]
      _recentLocation = "(#{firstLocation.lat}, #{firstLocation.lon})"
      @showPopover()

    showPopover: ->
      # Pass the location of the selected species to the model so the user can tweet about it
      @model.set('tweetLocation', _recentLocation)
      popover = new SpeciesPopoverView({model: @model})
      $('#popover-outer').append(popover.render().el)
  )

  # Species Detail View
  DetailTrailView = Backbone.View.extend(
    el: '#detail-trail'

    # Define methods to be run at initialization time
    initialize: ->
      locArr = window.location.href.split("/")
      slug = locArr[4]
      @model = new TrailModel(_.find _trailsRaw, (trail) -> trail.slug == slug)

      @render()

    render: ->
      @showPopover()

    showPopover: ->
      # Pass the location of the selected species to the model so the user can tweet about it
      popover = new TrailPopoverView({model: @model})
      $('#popover-outer').append(popover.render().el)
  )

  # SpeciesManager.initialize() is the only exported member variable, it will initialize the backbone objects, pull data
  # and set up the collection
  initialize: (species, trails, families, map) ->
    # Cache local variables
    _speciesRaw = species
    _trailsRaw = trails
    _familiesRaw = families
    _map = map
    i = 0
    while i < _trailsRaw.length
      _trailsRaw[i].points = []
      j = 0
      while j < _trailsRaw[i].trail_points.length
        _trailsRaw[i].trail_points[j].type = 'point'
        _trailsRaw[i].points[_trailsRaw[i].trail_points[j].order] = _trailsRaw[i].trail_points[j]
        j++
      j = 0
      while j < _trailsRaw[i].species_location_trails.length
        _trailsRaw[i].species_location_trails[j].type = 'species'
        _trailsRaw[i].points[_trailsRaw[i].species_location_trails[j].order] = _trailsRaw[i].species_location_trails[j]
        j++
      i++
    # Create a new list view to kick off species and trail management via backbone
    _familyOuterListView = new FamilyOuterListView()
    _speciesOuterListView = new SpeciesOuterListView()
    _trailOuterListview = new TrailOuterListView()

    if (window.location.href.indexOf("species") > -1)
      detail = new DetailSpeciesView()

    if (window.location.href.indexOf("trails") > -1)
      detail = new DetailTrailView()

    # Init markerClusterer to group close maps markers together
    # _markerClusterer = new MarkerClusterer(map, _markers, {gridSize: 30, maxZoom: 18, minimumClusterSize:4})

    # Bind click events for menu tabs
    $('#tab-button-species').on 'click', ->
      unless $(this).hasClass 'selected'
        $('.tab-button.selected').removeClass('selected')
        $(this).addClass 'selected'
        $('.menu-content-container').removeClass('pos2 pos3').addClass('pos1')

    $('#tab-button-families').on 'click', ->
      unless $(this).hasClass 'selected'
        $('.tab-button.selected').removeClass('selected')
        $(this).addClass 'selected'
        $('.menu-content-container').removeClass('pos1 pos3').addClass('pos2')

    $('#tab-button-trails').on 'click', ->
      unless $(this).hasClass 'selected'
        $('.tab-button.selected').removeClass('selected')
        $(this).addClass 'selected'
        $('.menu-content-container').removeClass('pos1 pos2').addClass('pos3')

    # Fix height of menus
    $('#menu-content-species').height($(window).outerHeight() - $('#tab-button-outer').outerHeight())
    $('#menu-content-families').height($(window).outerHeight() - $('#tab-button-outer').outerHeight())

    # Hide current marker if there is one when clicking on map
    google.maps.event.addListener _map, "click", ->
      closeInfoBox(_openInfoBox)
