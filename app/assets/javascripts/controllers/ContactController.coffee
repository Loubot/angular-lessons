'use strict'


angular.module( 'lessons' ).controller( 'ContactController', [
  "$scope"
  "$rootScope"
  "COMMS"
  "alertify"
  "$mdDialog"
  ( $scope, $rootScope, COMMS, alertify, $mdDialog ) ->
    console.log "ContactController"

    $scope.contact_boss = ->
      console.log $scope.email

      COMMS.POST(
        '/message-bosses'
        $scope.email
      ).then( ( resp ) ->
        console.log resp
        alertify.success "Message sent"
        $mdDialog.cancel()
      ).catch( ( err ) ->
        console.log err
        alertify.error "Failed to send message"
      )

    $scope.close_dialog = ->
      $mdDialog.cancel()

    $scope.contact = ( email ) ->
      $scope.email = {}
      $scope.email.name = $rootScope.User.get_full_name() if $rootScope.User?
      $scope.email.email = email
      $mdDialog.show(
        templateUrl: "dialogs/email_da_boss.html"
        scope: $scope
        openFrom: "left"
        closeTo: "right"
        preserveScope: true
        clickOutsideToClose: false
      )

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