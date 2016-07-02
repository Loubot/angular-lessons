'use strict'

angular.module('lessons').controller('TeacherAreaController', [
  '$scope'
  '$rootScope'
  '$state'
  'RESOURCES'
  'USER'
  'alertify'
  'COMMS'
  ( $scope, $rootScope, $state, RESOURCES, USER, alertify, COMMS ) ->
    console.log "TeacherAreaController"

    window.init = ->
      console.log "loaded"
      console.log gapi
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
        events = resp.items
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
        else
          appendPre 'No upcoming events found.'
        return
      )
])

