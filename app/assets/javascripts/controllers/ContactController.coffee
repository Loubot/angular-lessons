'use strict'


angular.module( 'lessons' ).controller( 'ContactController', [
  "$scope"
  "$rootScope"
  "COMMS"
  "Alertify"
  "$mdDialog"
  "$state"
  "change_tags"
  ( $scope, $rootScope, COMMS, Alertify, $mdDialog, $state, change_tags ) ->
    console.log "ContactController"

    console.log $state.current.name == "about"

    if $state.current.name == "contact"
      change_tags.set_title "Contact Learn Your Lesson | Contact Us | learnyourlesson"
    else if $state.current.name == "about"
      change_tags.set_title "Learn your lesson story | How it all started | learnyourlesson"

    $scope.contact_boss = ->
      console.log $scope.email

      COMMS.POST(
        '/message-bosses'
        $scope.email
      ).then( ( resp ) ->
        console.log resp
        Alertify.success "Message sent"
        $mdDialog.cancel()
      ).catch( ( err ) ->
        console.log err
        Alertify.error "Failed to send message"
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
        Alertify.success "Message sent"
      ).catch( ( err ) ->
        console.log err
        Alertify.error "Failed to deliver message"
      )

    $scope.jsonId = 
      "@context": "http://schema.org",
      "@type": "Organization",
      "url": "https://www.learnyourlesson.ie",
      "logo": "https://s3-eu-west-1.amazonaws.com/angular-lessons/static_assets/facebook_logo.jpg",
      "contactPoint": [
        {
          "@type": "ContactPoint",
          "telephone": "+353863778875",
          "contactType": "sales",
          "email": "alan@learnyourlesson.ie"
        },
        {
          "@type": "ContactPoint",
          "telephone": "+353851231558",
          "contactType": "technical support",
          "email": "loubot@learnyourlesson.ie"
        },
        {
          "@type": "ContactPoint",
          "telephone": "+353851231558",
          "contactType": "customer service",
          "email": "loubot@learnyourlesson.ie"
        }

      ]


])