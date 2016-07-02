'use strict'

angular.module('lessons').controller('TeacherAreaController', [
  '$scope'
  '$rootScope'
  '$state'
  'RESOURCES'
  'USER'
  'alertify'
  'COMMS'
  'googleClient'
  ( $scope, $rootScope, $state, RESOURCES, USER, alertify, COMMS, googleClient ) ->
    
    console.log "TeacherAreaController"
    googleClient.afterApiLoaded().then(  ->
      console.log "Loaded"
      gapi.client.load( 'calendar', 'v3', ->
        gapi.client.calendar.events.list(
          calendarId: 'primary'
        ).execute( ( resp) ->
          console.log resp.items
        )
      )
    )
    
    

    # $scope.clickHandler = ( a ) ->
    #   console.log a

    # $scope.signInListener = ( a ) ->
    #   console.log a

    # $scope.userListener = ( a ) ->
    #   console.log a
])

