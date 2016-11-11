'use strict'

angular.module( 'lessons' ).controller( 'ContactController', [
  "$scope"
  "COMMS"
  "alertify"
  ( $scope, COMMS, alertify ) ->
    console.log "ContactController"

    $scope.contact_us = ->
      console.log $scope.message
      COMMS.POST(
        "/contact-us"
        $scope.message
      ).then( ( resp ) ->
        console.log resp
        alertify.success "Message sent"
      ).catch( ( err ) ->
        console.log err
        alertify.error "Failed to deliver message"
      )

])