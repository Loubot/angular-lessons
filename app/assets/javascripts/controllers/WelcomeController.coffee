'use strict'

angular.module('lessons').controller('WelcomeController', [
  '$scope'
  '$rootScope'
  'USER'
  '$mdSidenav'
  'alertify'
  '$auth'
  'COMMS'
  '$window'
  ( $scope, $rootScope, USER, $mdSidenav, alertify, $auth, COMMS, $window ) ->
    console.log "WelcomeController"
    $elems = $('.animateblock')
    $scope.subject = {}
    winheight = $(window).height()
    fullheight = $(document).height()
   

    animate_elems = ->
      wintop = $(window).scrollTop()
      # calculate distance from top of window
      # loop through each item to check when it animates
      $elems.each ->
        $elm = $(this)
        if $elm.hasClass('animated')
          return true
        # if already animated skip to the next item
        topcoords = $elm.offset().top
        # element's distance from top of page in pixels
        if wintop > topcoords - (winheight * .75)
          # animate when top of the window is 3/4 above the element
          $elm.addClass 'animated'
        return
      return
    

    $scope.scrollevent = ( $e ) ->
      
      animate_elems()
      # @scrollPos = document.body.scrollTop or document.documentElement.scrollTop or 0
      # $scope.$digest()
      return
    
      

    USER.get_user()


    COMMS.GET(
      "/subjects"
      $scope.subject
    ).then( ( resp ) ->
      # console.log resp
      $scope.subjects = resp.data
      alertify.success "Fetched subjects"
    ).catch( ( err ) ->
      console.log err
      alertify.error "Failed to get subjects "
    )

    $scope.search = ->
      console.log $scope.searchText
      COMMS.GET(
        "/search"
        $scope.searchText
      ).then( ( resp ) ->
        console.log "search results"
        console.log resp
      ).catch( ( err ) ->
        console.log "search error"
        console.log err
      )
])