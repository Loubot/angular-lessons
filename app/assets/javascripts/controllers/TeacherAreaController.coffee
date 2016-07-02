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
  'cmApiService'
  '$http'
  ( $scope, $rootScope, $state, RESOURCES, USER, alertify, COMMS, googleClient, cmApiService, $http ) ->
    d = new Date()   
    console.log d.setDate( d.getDate() +  2 )
    console.log "TeacherAreaController"
    googleClient.afterApiLoaded().then(  ->
      console.log "Loaded"
      gapi.client.load( 'calendar', 'v3', ->
        gapi.client.calendar.events.list(
          calendarId: 'primary'
        ).execute( ( resp) ->
          console.log resp
        )
        d = new Date()
        gapi.client.calendar.events.insert(
          calendarId: 'primary'
          start: date: d
          end: date: d.setDate( d.getDate() +  2 )

        ).execute( ( resp ) ->
          console.log resp
        )
      )
      
      
    )
    
    

    $scope.clickHandler = ( a ) ->
      console.log a

    $scope.signInListener = ( a ) ->
      console.log a

    $scope.userListener = ( a ) ->
      console.log a.hg
      $http(
        method: "POST"
        url: "https://accounts.google.com/o/oauth2/token "
        headers: 'Content-Type': "application/x-www-form-urlencoded"
        access_token: a.hg.access_token
      ).then( ( resp ) ->
        console.log "Google "
        console.log resp
      ).catch( ( err ) ->
        console.log "Google error"
        console.log err
      )
])

