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
    $scope.events = []
    usSpinnerService.spin('spinner-1')

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

    window.init = ->
      
      console.log "loaded"
      # console.log gapi
      gapi.client.load('calendar', 'v3', calendar_loaded)

    calendar_loaded = ->
      gapi.client.calendar.events.list(
        'calendarId': 'primary'
        # 'timeMin': (new Date()).toISOString()
        'showDeleted': false
        'singleEvents': true
        'maxResults': 10
        'orderBy': 'startTime'
      ).execute( ( resp ) ->
        console.log resp
        events = resp.items
        # events = resp.items

        
        appendPre 'Upcoming events:'
        if events.length > 0
          i = 0
          while i < events.length
            event = events[i]
            bla = event.start.dateTime
            if !bla
              bla = event.start.date
            appendPre event.summary + ' (' + bla + ')'
            i++
          usSpinnerService.stop('spinner-1')
        else
          appendPre 'No upcoming events found.'
          usSpinnerService.stop('spinner-1')
        return
        
      )

    

      
])

