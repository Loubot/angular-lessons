'use strict'

angular.module('lessons').controller('TeacherAreaController', [
  '$scope'
  '$rootScope'
  '$state'
  '$stateParams'
  'RESOURCES'
  'USER'
  'alertify'
  'COMMS'
  ( $scope, $rootScope, $state, $stateParams, RESOURCES, USER, alertify, COMMS ) ->
    console.log "TeacherAreaController"
    

    CLIENT_ID = '25647890980-aachcueqqsk0or6qm49hi1e23vvvluqd.apps.googleusercontent.com'

    SCOPES =  [
                "https://www.googleapis.com/auth/calendar.readonly"
                "https://www.googleapis.com/auth/calendar"
                "https://www.googleapis.com/auth/userinfo.email"
                "https://www.googleapis.com/auth/userinfo.profile"
              ]
    

    USER.get_user().then( ( user ) ->
      console.log "got user"
      console.log $rootScope.USER.id != parseInt( $stateParams.id )
      if $rootScope.USER.id != parseInt( $stateParams.id )
        $state.go 'welcome'
        alertify.error "You are not allowed to view this"
        return false
    ).catch( ( err ) ->
      alertify.error "Not authorised"
      $rootScope.USER = null
      $state.go 'welcome'
      return false
    )



    format_events = ( events ) ->
      if events? && events.length > 0
        bla = []
        for event in events
          bla.push
            title: event.summary
            startTime: new Date( event.start.dateTime )
            endTime: new Date ( event.end.dateTime )
            # allDay: true

        $scope.eventSource = bla
        alertify.success "Loaded #{ events.length } events"
        $scope.$apply()



    ###################### google auth ###############################


    load_calendar_api = ->
      
      console.log "loaded"
      # console.log gapi
      gapi.client.load('calendar', 'v3', calendar_loaded)
      gapi.client.load('oauth2', 'v2', oauth2_loaded)

    calendar_loaded = ->
      if !$rootScope.USER.calendar_id or $rootScope.USER.calendar_id == ""  
      else
        gapi.client.calendar.events.list(
          'calendarId': "#{ $rootScope.USER.calendar_id }"
        ).execute( ( resp ) ->
          console.log "Calendar list"
          console.log resp
          if resp.error?  
            alertify.error "Couldn't load your calendar"
          else

            console.log "List events"
            format_events( resp.items )
            alertify.success "Got events" 
        )
        
      # gapi.client.calendar.calendarList.list().execute( ( resp ) ->
      #   console.log "Calendar list"
      #   console.log resp
      # )
      # gapi.client.calendar.events.list(
      #   'calendarId': 'primary'
      #   # 'timeMin': (new Date()).toISOString()
      #   'showDeleted': false
      #   'singleEvents': true
      #   'maxResults': 10
      #   'orderBy': 'startTime'
      # ).execute( ( resp ) ->
      #   # console.log resp
      #   format_events( resp.items )
      # )

    oauth2_loaded = ->
      console.log "Oauth"
      gapi.client.oauth2.userinfo.get().execute( ( resp ) ->
        $scope.google_id_email =  resp.email
      )

    

    handleAuthResult = ( auth ) ->
      console.log "auth"
      # console.log auth
      if ( auth? and !auth.error? )
        $scope.show_auth_button = false
        
        $scope.$apply()
        
        load_calendar_api()
      else
        $scope.show_auth_button = true
        alertify.confirm "Please log in with google to use the calendar"
        $scope.$apply()

    $scope.handleAuthClick = (event) ->
      gapi.auth.authorize(
        {client_id: CLIENT_ID, scope: SCOPES, immediate: false}
        handleAuthResult
      )
      return false
      
    window.checkAuth = -> 
      console.log "Checkauth"
      gapi.auth.authorize(
        {
          'client_id': CLIENT_ID,
          'scope': SCOPES.join(' '),
          'immediate': true
          'fetch_basic_profile': true
        }, handleAuthResult)
      
       
    $scope.create_calendar = ->
      console.log "Create calendar"
      console.log "user:#{ $scope.google_id_email }"
      gapi.client.calendar.calendars.insert(
        'description': "LYL calendar for #{ $rootScope.USER.first_name } #{ $rootScope.USER.last_name }"
        'summary': "LYL Calendar"
        # 'id': "user:#{ $scope.google_id_email }"
        'timeZone': "GMT+01:00 Dublin"
        'backgroundColor': '#2a602a'
      ).execute( ( resp ) ->
        alertify.success "Created calendar for you"
        COMMS.PUT(
          "/teacher/#{ $rootScope.USER.id }"
          calendar_id: resp.result.id
        ).then( ( resp ) ->
          console.log resp
          $rootScope.USER = resp.data.teacher
          alertify.success "Updated calendar id"
        ).catch( ( err ) ->
          console.log err
          alertify.error "Failed to update user"
        )
      )

    ###################### google auth ###############################
    

    $scope.changeMode = (mode) ->
      $scope.mode = mode
      return

    $scope.today = ->
      $scope.currentDate = new Date
      return

    $scope.isToday = ->
      today = new Date
      currentCalendarDate = new Date($scope.currentDate)
      today.setHours 0, 0, 0, 0
      currentCalendarDate.setHours 0, 0, 0, 0
      today.getTime() == currentCalendarDate.getTime()

    $scope.loadEvents = ->
      $scope.eventSource = createRandomEvents()
      
      return

    $scope.onEventSelected = (event) ->
      $scope.event = event
      return

    $scope.onTimeSelected = (selectedTime) ->
      console.log 'Selected time: ' + selectedTime
      return

    return
    
      
])

