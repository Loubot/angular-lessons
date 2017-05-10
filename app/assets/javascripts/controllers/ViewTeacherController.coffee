'use strict'

angular.module('lessons').controller( 'ViewTeacherController', [
  "$scope"
  "$rootScope"
  "$state"
  "$stateParams"
  "$filter"
  "COMMS"
  "Alertify"
  "$mdDialog"
  "change_tags"
  "is_mobile"
  "OG"
  ( $scope, $rootScope, $state, $stateParams, $filter, COMMS, Alertify, $mdDialog, change_tags, is_mobile, OG ) ->
    console.log "ViewTeacherController"

    $scope.is_mobile = is_mobile
    console.log $scope.is_mobile
    $scope.message = {}
    $scope.profile = null #Teacher profile pic

    $scope.map = {}
    $scope.teacher_loaded = false

    $scope.create_map = ->

      console.log 'hup'
      if $scope.teacher.location?
        zoom = if $scope.teacher.location.touched then 15 else 12
        $scope.map = new google.maps.Map(document.getElementById('map'), 
          center: 
            lat: $scope.teacher.location.latitude
            lng: $scope.teacher.location.longitude
          zoom: zoom
          mapTypeId: google.maps.MapTypeId.ROADMAP
          
        )

        $scope.map.setOptions(
          clickableIcons: false
          disableDefaultUI: true
          disableDoubleClickZoom: true
          draggable: false
          scrollwheel: false
        )

        marker = new google.maps.Marker(
          position:
            lat: $scope.teacher.location.latitude
            lng: $scope.teacher.location.longitude
          map: $scope.map
          title: "#{ $scope.teacher.first_name } location"
        )


        # google.maps.event.addDomListener window, 'resize', ->

          
        #   $scope.map.setCenter(
        #     lat: $scope.teacher.location.latitude
        #     lng: $scope.teacher.location.longitude
        #   )


        google.maps.event.addListenerOnce $scope.map, 'idle', ->
          google.maps.event.trigger($scope.map, 'resize')

    
    
    COMMS.GET(
      "/teacher/#{ $stateParams.id }/show-teacher"
    ).then( ( resp ) ->
      console.log "got teacher info"
      console.log resp
      Alertify.success "Got teacher info"
      $scope.teacher = resp.data.teacher
      set_profile()
      # create_map() if $scope.teacher.location?
      $scope.teacher_loaded = true
      create_fotorama()
      run_change_tags()
      create_subjects_list()
      add_json_ld()
      # set_og_tags()
    ).catch( ( err ) ->
      console.log err
      Alertify.error err.data.errors.full_messages
      $state.go 'welcome'
    )

    # set_og_tags = ->
    #   OG.set_tags( 
    #     "https://www.learnyourlesson.ie/#!/view-teacher/#{ $scope.teacher.id }", 
    #     "Get a #{ $scope.subject_list } lesson with #{ $scope.teacher.first_name } #{ $scope.teacher.last_name }", 
    #     "profile", 
    #     "image", 
    #     "description" 
    #   )

    add_json_ld = ->
      
      $scope.jsonId =
        "@context": "http://schema.org/",
        "@type": "Product",
        "category": "education",
        "name": "#{ $scope.subject_list } lessons",
        "audience": {
          "@type": "Audience",
          "name": "students"
        },
        "image": "#{ if $scope.profile? then $scope.profile.avatar.url else '' }",
        "description": "Get a #{ $scope.subject_list } lesson from #{ $scope.teacher.first_name }",
        "brand": {
          "@type": "Thing",
          "name": "Learn Your Lesson"
        },
        "logo": "https://s3-eu-west-1.amazonaws.com/angular-lessons/static_assets/facebook_logo.jpg",
        "offers": {
          "@type": "Offer",
          "itemOffered": {
            "@type": "Offer",
            "name": "lesson"
          },
          "priceSpecification": {
            "@type": "priceSpecification",
            "price": "0.00",
            "priceCurrency": "EUR"
          },
          "priceCurrency": "EUR",
          "offeredBy": {
            "@type": "Organization",
            "name": "Learn Your Lesson"         
          },
          "seller": {
            "@type": "Organization",
            "name": "Learn Your Lesson"
          }
        }
        
      
    create_subjects_list = ->
      $scope.subject_list = ""
      for s, i in $scope.teacher.subjects
        $scope.subject_list = "#{ $scope.subject_list }#{ s.name }"
        $scope.subject_list = "#{ $scope.subject_list }, " if $scope.teacher.subjects.length >= 1 and i != $scope.teacher.subjects.length - 1
      $scope.subject_list = "#{ $scope.subject_list }"

    
    run_change_tags = ->
      console.log 
      title = ""
      if $scope.teacher.location && $scope.teacher.location.county?

        for subject in $scope.teacher.subjects
          
          title = "#{ title } #{ subject.name } lessons in #{ $scope.teacher.location.county }"
      else
        for subject in $scope.teacher.subjects
          
          title = "#{ title } #{ subject.name } lessons "
        
      change_tags.set_title title


      ### Tweet stuff ###
      get_address = ( teacher ) ->
        if !teacher.location?
          return false
        else if teacher.location.address?
          return teacher.location.address
        else if teacher.location.county?
          return teacher.location.county
        else
          return "Ireland"

      
      """#{ $scope.teacher.first_name } #{ $scope.teacher.last_name } offering #{ subject_list } lessons in #{ get_address( $scope.teacher ) }. Contact them now to arrange a lesson."""

      
      subject_list = create_subjects_list( $scope.teacher )
      change_tags.set_twitter_tags(
        "#{ subject_list } lessons",
        """#{ $scope.teacher.first_name } #{ $scope.teacher.last_name } offering #{ subject_list } lessons in #{ get_address( $scope.teacher ) }. Contact them now to arrange a lesson."""
      )
      $scope.tweet = () ->

        twttr.widgets.createTweet(1,document.getElementById('teacher_container'),align: 'left').then (el) ->
          console.log 'Tweet displayed.'
          return

      ### End of tweet stuff ###

    set_profile = ->
      return true if $scope.teacher.photos? && $scope.teacher.photos.length == 0

      for photo in $scope.teacher.photos
        # console.log photo.avatar.url
        if parseInt( photo.id ) == parseInt( $scope.teacher.profile )
          # console.log photo
          $scope.profile = photo

      $scope.profile


    #################### fotrama ########################################
    create_fotorama = ->
      $scope.slides = []
      for photo, index in $scope.teacher.photos
        $scope.slides.push(
          pic: photo.avatar.url
          index: index + 1
          description: "Image #{ index + 1 }"
        )

      # console.log $scope.slides
      $scope.index = 1
      
      id = setInterval((->
        if $state.$current.name != "view_teacher"
          clearInterval( id )
          return false
        $scope.index = ++$scope.index 
        $scope.index = 1 if $scope.index == $scope.teacher.photos.length + 1
        
        $scope.$apply()
        return
      ), 3000 )

    
    ####################### Message dialog #############################

    user_listener = $rootScope.$watch "User", ->
      console.log "User changed"
      if $rootScope.User?
        
        $scope.message.name = "#{ $rootScope.User.first_name } #{ $rootScope.User.last_name }"

    $scope.open_message_dialog = ->
      $mdDialog.show(
        clickOutsideToClose: true
        scope: $scope
        preserveScope: true
        templateUrl: "dialogs/message_teacher_dialog.html"
      )

    $scope.closeDialog = ->
      $mdDialog.hide()

    check_user_name_exists = ->
      if !$rootScope.User.get_full_name()
        names = $scope.message.user_name1.split( " " )
        if names.length > 0
          $rootScope.User.first_name = names[0]
          $rootScope.User.last_name = names[1] if names[1]?
          $rootScope.User.update( $rootScope.User )
      else
        $rootScope.User.get_full_name()

    $scope.send_message = ->
      check_user_name_exists( $scope.conversation )
      console.log $scope.message
      $scope.conversation = {}
      $scope.conversation.user_id1 = $rootScope.User.id
      $scope.conversation.user_id2 = $scope.teacher.id
      $scope.conversation.user_email1 = $rootScope.User.email
      $scope.conversation.user_email2 = $scope.teacher.email
      $scope.conversation.user_name1 = check_user_name_exists()
      $scope.conversation.user_name2 = "#{ $scope.teacher.first_name } #{ $scope.teacher.last_name }"
      $scope.message.sender_id = $rootScope.User.id

      COMMS.POST(
        "/conversation"
        conversation: $scope.conversation
        message: $scope.message
      ).then( ( resp ) ->
        console.log resp
        Alertify.success "Message sent!"
        $mdDialog.hide()
      ).catch( ( err ) ->
        console.log err
        Alertify.error "Failed to send your message"
      )

    $scope.open_login = ->
      $mdDialog.show(
        templateUrl: "dialogs/login.html"
        scope: $scope
        openFrom: "left"
        closeTo: "right"
        preserveScope: true
        clickOutsideToClose: false
      )

    $scope.close_login_or_register = ->
      $mdDialog.hide()


    

  
    
  

  ])
