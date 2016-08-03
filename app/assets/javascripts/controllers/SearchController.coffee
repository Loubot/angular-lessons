'use strict'

angular.module('lessons').controller( 'SearchController', [
  "$scope"
  "$rootScope"
  "$state"
  "$stateParams"
  "$filter"
  "COMMS"
  "alertify"
  ( $scope, $rootScope, $state, $stateParams, $filter, COMMS, alertify ) ->
    console.log "SearchController"
    $scope.ctrl = 
      subject: null
      county:  null
    console.log $stateParams
    $scope.ctrl.subject = $stateParams.name
    $scope.ctrl.county = $stateParams.location

    $scope.view_teacher = ( teacher ) ->
      $state.go('view_teacher', id: teacher.id )


    $scope.scrollevent = ( $e ) ->
      
      return

    $scope.search_teachers = ( params ) ->
      console.log params
      COMMS.GET(
        '/search'
        params
      ).then( ( resp ) ->
        console.log resp
        $scope.teachers = resp.data.teachers
        alertify.success "Found #{ resp.data.teachers.length } teacher(s)"
      ).catch( ( err ) ->
        console.log err
      )

    if $stateParams.name? or $stateParams.location?
      $scope.search_teachers( $stateParams )

   
    
    $scope.search_subjects = ->
      console.log $scope.ctrl.subject_name
      $scope.subjects = $filter('filter')( $scope.subjects_list, $scope.ctrl.subject_name )

    $scope.search_counties = ->
      
      console.log $scope.ctrl.county_name
      $scope.counties =  $filter('filter')( $scope.county_list, $scope.ctrl.county_name )

    $scope.county_picked = ( county ) ->
      console.log county
      $scope.ctrl.county = county
      set_params()

    $scope.subject_picked = ( subject ) ->
      if subject != ""
        console.log subject
        $scope.ctrl.subject = subject
        set_params()

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

    set_params = ->
      $state.transitionTo(
        'search',
        { name: $scope.ctrl.subject, location: $scope.ctrl.county }
        { notify: false }
      )

    ################# Get teachers by subject on page load


])