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
      usSpinnerService.spin('spinner-1')
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

        create_events_list( resp.items )
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

    create_events_list = ( event_list ) ->
      $scope.events = [
          {
            title: 'All Day Event',start: new Date('Mon Jul 04 2016 09:00:00 GMT+0530 (IST)')
              
          }
      ]
      $scope.$apply()

      
])

