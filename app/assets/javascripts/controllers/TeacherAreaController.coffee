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

    SCOPES = ["https://www.googleapis.com/auth/calendar.readonly",
              "https://www.googleapis.com/auth/calendar"]
    usSpinnerService.spin('spinner-1')

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


    window.init = ->
      
      console.log "loaded"
      # console.log gapi
      gapi.client.load('calendar', 'v3', calendar_loaded)

    handleAuthResult = ( auth ) ->
      if ( auth? and !auth.error? )
        $scope.show_auth_button = false
        $scope.$apply()
        init()
      else

        $scope.show_auth_button = true
        $scope.$apply()

    handleAuthClick = (event) ->
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
        }, handleAuthResult)
      
    

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

