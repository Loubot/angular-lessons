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

    window.init = ->
      
      console.log "loaded"
      # console.log gapi
      gapi.client.load('calendar', 'v3', calendar_loaded)

    window.handleAuthResult = ( auth ) ->
      console.log !( auth == false && !auth.error)
      $scope.show_auth_button = !( auth == true && !auth.error)
      $scope.$apply()
    

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
        
        # appendPre 'Upcoming events:'
        # if events.length > 0
        #   i = 0
        #   while i < events.length
        #     event = events[i]
        #     bla = event.start.dateTime
        #     if !bla
        #       bla = event.start.date
        #     appendPre event.summary + ' (' + bla + ')'
        #     i++
        #   usSpinnerService.stop('spinner-1')
        # else
        #   appendPre 'No upcoming events found.'
        #   usSpinnerService.stop('spinner-1')
        # return
        
      )

    # createRandomEvents = ->
    #   events = []
    #   i = 0
    #   while i < 50
    #     date = new Date
    #     eventType = Math.floor(Math.random() * 2)
    #     startDay = Math.floor(Math.random() * 90) - 45
    #     endDay = Math.floor(Math.random() * 2) + startDay
    #     startTime = undefined
    #     endTime = undefined
    #     if eventType == 0
    #       startTime = new Date(Date.UTC(date.getUTCFullYear(), date.getUTCMonth(), date.getUTCDate() + startDay))
    #       if endDay == startDay
    #         endDay += 1
    #       endTime = new Date(Date.UTC(date.getUTCFullYear(), date.getUTCMonth(), date.getUTCDate() + endDay))
    #       events.push
    #         title: 'All Day - ' + i
    #         startTime: startTime
    #         endTime: endTime
    #         allDay: true
    #       console.log events
    #     else
    #       startMinute = Math.floor(Math.random() * 24 * 60)
    #       endMinute = Math.floor(Math.random() * 180) + startMinute
    #       startTime = new Date(date.getFullYear(), date.getMonth(), date.getDate() + startDay, 0, date.getMinutes() + startMinute)
    #       endTime = new Date(date.getFullYear(), date.getMonth(), date.getDate() + endDay, 0, date.getMinutes() + endMinute)
    #       events.push
    #         title: 'Event - ' + i
    #         startTime: startTime
    #         endTime: endTime
    #         allDay: false
    #     i += 1
    #   events

    

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

