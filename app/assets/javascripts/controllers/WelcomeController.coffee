'use strict'

angular.module('lessons').controller('WelcomeController', [
  '$scope'
  '$rootScope'
  '$state'
  '$filter'
  '$stateParams'
  'USER'
  '$mdSidenav'
  'alertify'
  '$auth'
  'COMMS'
  '$window'
  ( $scope, $rootScope, $state, $filter, $stateParams, USER, $mdSidenav, alertify, $auth, COMMS, $window ) ->
    console.log "WelcomeController"

    $scope.facebook = ->
      console.log 'facebook'
      $auth.authenticate('facebook')

    $rootScope.$on 'auth:login-success', (ev, user) ->
      alert 'Welcome ', user.email
      

    $rootScope.$on 'auth:login-error', (ev, reason) ->
      alert 'auth failed because', reason.errors[0]
      


    $elems = $('.animateblock')
    $scope.selected = {}
    $scope.selected.subject_name = $stateParams.name
    $scope.selected.county_name = $stateParams.location
    $scope.selected_subject = $stateParams.name
    winheight = $(window).height()
    fullheight = $(document).height()

    # if $stateParams.message?
    #   alertify.delay(0).closeLogOnClick(true).log($stateParams.message + " Click to dismiss")
   

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


    $scope.search_teachers = ->
      COMMS.GET(
        "/search"
        $scope.selected
      ).then( ( resp ) ->
        console.log resp
        alertify.success "Found #{ resp.data.teachers.length } teacher(s)"
        $scope.teachers = resp.data.teachers
      ).catch( ( err ) ->
        console.log err
        alertify.error "Failed to find teachers"
      )

    if $stateParams.name? or $stateParams.location
      $scope.search_teachers()


    $scope.search = ->
      console.log "search"
      if $scope.selected.subject_name.length > 0
      
        $state.go("search", { name: $scope.selected.subject_name, location: $scope.selected.county_name })

    $scope.subject_picked = ( subject )->
      
      if $scope.selected.subject_name?
        console.log subject
        $scope.selected.subject_name = subject
        

    $scope.county_picked = ( county )->
      if $scope.selected.county_name?
        $scope.selected.county_name = county
        

    define_subjects = ( subjects ) ->
      $scope.master_subjects_list = []
      for subject in subjects
        $scope.master_subjects_list.push( subject.name )

      # console.log $scope.subjects_list

    $scope.search_subjects = ( subject ) ->
      $scope.subjects_list = $scope.master_subjects_list
      console.log subject
      # console.log $filter('filter')( $scope.subjects_list, subject.name )
      $scope.subjects_list = $filter('filter')( $scope.subjects_list, subject )
      # $filter('filter')( $scope.subjects_list, subject )

     

    $scope.search_counties = ( county ) ->
      console.log county
      console.log $filter('filter')( $scope.county_list, county )
      $scope.counties = $filter('filter')( $scope.county_list, county )


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
      console.log err
    )

])