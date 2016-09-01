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
  '$mdDialog'
  '$mdToast'
  '$mdpDatePicker'
  '$mdpTimePicker'
  ( $scope, $rootScope, $state, $stateParams, RESOURCES, USER, alertify, COMMS, $mdDialog, $mdToast, $mdpDatePicker, $mdpTimePicker ) ->
    console.log "TeacherAreaController"
    $scope.create_event_button_bool = false

    ############### Define event details ###########################
    #https://developers.google.com/apis-explorer/#p/calendar/v3/calendar.events.insert

    $scope.calendar_event_details = {}

    $scope.calendar_event_details.sendNotifications = true
    $scope.calendar_event_details.end_date = null
    $scope.calendar_event_details.end_time = null

    $scope.calendar_event_details.student_email = $stateParams.student_email if $stateParams.student_email?
    
    ###############End of define event details #########################

    ############### Don't display create calendar button ##############

    $scope.calendar_id = true 

    ###########################################

    CLIENT_ID = '25647890980-aachcueqqsk0or6qm49hi1e23vvvluqd.apps.googleusercontent.com'

    SCOPES =  [
                "https://www.googleapis.com/auth/calendar.readonly"
                "https://www.googleapis.com/auth/calendar"
                "https://www.googleapis.com/auth/userinfo.email"
                "https://www.googleapis.com/auth/userinfo.profile"
              ]
    

    USER.get_user().then( ( user ) ->
      console.log "got user"
      # console.log $rootScope.USER.id != parseInt( $stateParams.id )
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
        alertify.success "Loaded #{ events.length } event(s)"
        $scope.create_event_button_bool = true
        $scope.$apply()



    ###################### google auth ###############################

    fetch_events = ->
      gapi.client.calendar.events.list(
        'calendarId': "#{ $scope.calendar_id }"
      ).execute( ( resp ) ->
        console.log "Calendar list"
        # console.log resp
        if resp.error?  
          alertify.error "Couldn't load your calendar"
          $scope.calendar_id = null
        else

          console.log "List events"

          format_events( resp.items )
          $scope.create_event_button_bool = true
          $scope.$digest()
      )

    check_if_calendar_exists = ( calendars ) ->
      console.log calendars
      calendar_exists = false
      for calendar in calendars
        if calendar.summary == "LYL Calendar"
          
          # console.log calendar
          $scope.calendar_id = calendar.id
          $scope.calendar_event_details.calendar_id = calendar.id
          calendar_exists = true

      if calendar_exists
        alertify.success "Found your calendar"
        console.log $scope.calendar_id
        fetch_events()
      else
        alertify.error "Couldn't find your calender"
        console.log "Can't find calendar"
        $scope.calendar_id = null
        $scope.create_calendar()
        

    load_calendar_api = ->
      
      # console.log "loaded"
      # console.log gapi
      gapi.client.load('calendar', 'v3', calendar_loaded)
      gapi.client.load('oauth2', 'v2', oauth2_loaded)

    calendar_loaded = ->
      alertify.success "Calendar api loaded"
      
      

    oauth2_loaded = ->
      console.log "Oauth"
      gapi.client.oauth2.userinfo.get().execute( ( resp ) ->
        # console.log "should be here " 
        # console.log resp
        $scope.google_id_email =  resp.email
        # get user email and then load calendar list
        gapi.client.calendar.calendarList.list().execute( ( resp ) ->
          console.log "Calendar list"
          # console.log resp
          if resp.error?  
            alertify.error "Couldn't load your calendar"
          else
            check_if_calendar_exists ( resp.items )
            console.log "List events"
            # format_events( resp.items )
            alertify.success "Got events" 
        )
      )

    

    handleAuthResult = ( auth ) ->
      console.log "auth"
      # console.log auth
      if ( auth? and !auth.error? )
        $scope.show_auth_button = false
        console.log "Begin calendar api load"
        $scope.$digest()
        
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
      alertify.success "Trying to create a new calendar"
      # console.log "user:#{ $scope.google_id_email }"
      gapi.client.calendar.calendars.insert(
        'description': "LYL calendar for #{ $rootScope.USER.first_name } #{ $rootScope.USER.last_name }"
        'summary': "LYL Calendar"
        # 'id': "user:#{ $scope.google_id_email }"
        'timeZone': "GMT+01:00 Dublin"
        'backgroundColor': '#2a602a'
      ).execute( ( resp ) ->
        console.log resp
        $scope.calendar_id = resp.id
        alertify.success "Created calendar for you"
        $scope.create_event_button_bool = true
        $scope.$digest()
        # COMMS.PUT(
        #   "/teacher/#{ $rootScope.USER.id }"
        #   calendar_id: resp.result.id
        # ).then( ( resp ) ->
        #   console.log resp
        #   $rootScope.USER = resp.data.teacher
        #   alertify.success "Updated calendar id"
        # ).catch( ( err ) ->
        #   console.log err
        #   alertify.error "Failed to update user"
        # )
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

    

    ####################### Create event##############################
    console.log typeof localStorage.getItem( "calendar_explanation" )
    if localStorage.getItem( "calendar_explanation" ) != "done"
   
      toast = $mdToast.simple(
        templateUrl: 'toasts/calendar_explain_toast.html'
        hideDelay: 0
        scope: $scope
        preserveScope: true
        position: "top"
      )

      $mdToast.show toast
      localStorage.setItem( "calendar_explanation", "done" )
    $scope.create_event = ->      
      $mdDialog.show(
        scope: $scope
        preserveScope: true
        templateUrl: "dialogs/calendar_event_dialog.html"
        openFrom: 'left'
        closeTo: 'right'
        fullscreen: true
      )


    $scope.submit_event_details = ->
      console.log $scope.calendar_event_details
      start_date_time = moment( $scope.calendar_event_details.start_date )     
      start_date_time.hour( moment( $scope.calendar_event_details.start_time ).format( "HH" ) )
      start_date_time.minute( moment( $scope.calendar_event_details.start_time ).format( 'mm' ) )
      console.log start_date_time.toString()

      end_date_time = moment( $scope.calendar_event_details.start_date )
      end_date_time.hour( moment( $scope.calendar_event_details.end_time ).format( "HH" ) )
      end_date_time.minute( moment( $scope.calendar_event_details.end_time).format( "mm" ) )
      console.log end_date_time.toString()
      if start_date_time == end_date_time
        alertify.error "Times are equal"
        $scope.event_creation_form.end_date.$error.not_the_same = true
        return false
      else if !$scope.calendar_event_details.start_date? or !$scope.calendar_event_details.start_time? or !$scope.calendar_event_details.end_date? or !$scope.calendar_event_details.end_time?

        alertify.error "Something not defined"
        $scope.event_creation_form.end_date.$error.not_the_same = true
        return false
      else
        $scope.event_creation_form.end_date.$error.not_the_same = false
     
      
      console.log $scope.calendar_event_details.student_email
      resource = {
        'summary': "Lesson with #{ $scope.calendar_event_details.student_email }" if $scope.calendar_event_details.student_email? and $scope.calendar_event_details.student_email != ""
        # location: $rootScope.USER.location.address if $rootScope.USER.location?
        'description': $scope.calendar_event_details.description
        'start': {
          'dateTime': start_date_time.toISOString()
          'timeZone': 'GMT'
        }
        'end':{
          'dateTime': end_date_time.toISOString()
          'timeZone': 'GMT'
        }
      }
      console.log resource
      gapi.client.calendar.events.insert(
        'calendarId': $scope.calendar_id
        'resource': resource
      ).execute( ( event ) ->
        console.log event
        fetch_events()
        $mdDialog.hide()
      )
    
      
])

