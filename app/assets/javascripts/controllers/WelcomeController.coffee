'use strict'

angular.module('lessons').controller('WelcomeController', [
  '$scope'
  '$rootScope'
  '$state'
  '$filter'
  'USER'
  '$mdSidenav'
  'alertify'
  '$auth'
  'COMMS'
  '$window'
  ( $scope, $rootScope, $state, $filter, USER, $mdSidenav, alertify, $auth, COMMS, $window ) ->
    console.log "WelcomeController"
    $elems = $('.animateblock')
    $scope.subject = {}
    $scope.searchText = {}
    $scope.subjects = []
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


    $scope.search_subjects = ( subject ) ->
      console.log subject.name
      console.log $filter('filter')( $scope.subjects_list, subject.name )
      $scope.search_subjects = $filter('filter')( $scope.subjects_list, subject.name )


    $scope.search = ->
      console.log "search"
      if !( Object.keys($scope.searchText).length == 0 && $scope.subject.constructor == Object )
        $state.go("search", { name: $scope.searchText.name, location: $scope.searchText.location })

    $scope.subject_picked = ( subject )->
      console.log subject
      if !( Object.keys(subject).length == 0 && subject.constructor == Object )
        $state.go("search", { name: $scope.searchText.name, location: $scope.searchText.location })

    define_subjects = ( subjects ) ->
      $scope.subjects_list = []
      for subject in subjects
        $scope.subjects_list.push( subject.name )

      console.log $scope.subjects_list
     

    $scope.county_list = ['Antrim','Armagh','Carlow','Cavan','Clare','Cork','Derry','Donegal','Down','Dublin',
          'Fermanagh','Galway','Kerry','Kildare','Kilkenny','Laois','Leitrim','Limerick','Longford',
          'Louth','Mayo','Meath','Monaghan','Offaly','Roscommon','Sligo','Tipperary','Tyrone',
          'Waterford','Westmeath','Wexford','Wicklow']

    COMMS.GET(
        '/search-subjects'
    ).then( ( resp ) ->
      console.log resp
      $scope.subjects_list = resp.data.subjects
      define_subjects( resp.data.subjects )
    ).catch( ( err ) ->
      console.log resp
    )

])