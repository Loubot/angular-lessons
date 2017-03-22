'use strict'


angular.module( 'lessons' ).controller( 'ContactController', [
  "$scope"
  "$rootScope"
  "COMMS"
  "alertify"
  "$mdDialog"
  "$state"
  "change_title"
  ( $scope, $rootScope, COMMS, alertify, $mdDialog, $state, change_title ) ->
    console.log "ContactController"

    console.log $state.current.name == "about"

    if $state.current.name == "contact"
      change_title.set_to "Contact Learn Your Lesson | Contact Us | learnyourlesson"
    else if $state.current.name == "about"
      change_title.set_to "Learn your lesson story | How it all started | learnyourlesson"

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
      $scope.email.user_email = $rootScope.User.email if $rootScope.User?
      console.log $scope.email
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