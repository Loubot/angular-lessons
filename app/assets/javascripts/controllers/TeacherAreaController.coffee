'use strict'

angular.module('lessons').controller('TeacherAreaController', [
  '$scope'
  '$rootScope'
  '$state'
  'RESOURCES'
  'USER'
  'alertify'
  'COMMS'
  'usSpinnerService'
  ( $scope, $rootScope, $state, RESOURCES, USER, alertify, COMMS, usSpinnerService ) ->
    console.log "TeacherAreaController"
    $scope.eventSource = []

    CLIENT_ID = '25647890980-aachcueqqsk0or6qm49hi1e23vvvluqd.apps.googleusercontent.com'

    SCOPES =  [
                "https://www.googleapis.com/auth/calendar.readonly"
                "https://www.googleapis.com/auth/calendar"
                "https://www.googleapis.com/auth/userinfo.email"
                "https://www.googleapis.com/auth/userinfo.profile"
              ]
    usSpinnerService.spin('spinner-1')

    USER.get_user()

    format_events = ( events ) ->
      for event in events
        $scope.eventSource.push
          title: event.summary
          startTime: event.start.dateTime
          endTime: event.end.dateTime
          # allDay: true
      usSpinnerService.stop('spinner-1')
      alertify.success "Loaded #{ events.length } events"
      $scope.$apply()

    $scope.uiConfig = calendar:
      height: 450
      editable: true
      header:
        left: 'month basicWeek basicDay agendaWeek agendaDay'
        center: 'title'
        right: 'today prev,next'
      dayClick: $scope.alertEventOnClick
      eventDrop: $scope.alertOnDrop
      eventResize: $scope.alertOnResize



    ###################### google auth ###############################


    load_calendar_api = ->
      
      console.log "loaded"
      # console.log gapi
      gapi.client.load('calendar', 'v3', calendar_loaded)
      gapi.client.load('oauth2', 'v2', oauth2_loaded)

    calendar_loaded = ->
      gapi.client.calendar.events.list(
        'calendarId': 'primary'
        # 'timeMin': (new Date()).toISOString()
        'showDeleted': false
        'singleEvents': true
        'maxResults': 10
        'orderBy': 'startTime'
      ).execute( ( resp ) ->
        # console.log resp
        format_events( resp.items )
      )

    oauth2_loaded = ->
      console.log "Oauth"
      gapi.client.oauth2.userinfo.get().execute( ( resp ) ->
        console.log resp
      )

    

    handleAuthResult = ( auth ) ->
      console.log "auth"
      console.log auth
      if ( auth? and !auth.error? )
        $scope.show_auth_button = false
        
        $scope.$apply()
        
        load_calendar_api()
      else
        usSpinnerService.stop('spinner-1')
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
          'immediate': false
          'fetch_basic_profile': true
        }, handleAuthResult)
      
       
    $scope.create_calendar = ->
      console.log "Create calendar"

      gapi.client.calendar.calendars.insert(
        'description': "LYL calendar for #{ $rootScope.USER.firstName } #{ $rootScope.USER.lastName }"
        'summary': "View all your LYL events here"
        'id': 1
        'timeZone': "GMT+01:00"
        'backgroundColor': '#2a602a'
      ).execute( ( resp ) ->
        console.log resp
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

