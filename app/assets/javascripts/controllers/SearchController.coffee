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
    
    console.log $stateParams
    $scope.selected = {}
    $scope.selected.subject_name = $stateParams.name
    $scope.selected.county_name = $stateParams.location
    $scope.selected_subject = $stateParams.name

    $scope.view_teacher = ( teacher ) ->
      $state.go('view_teacher', id: teacher.id )


    $scope.scrollevent = ( $e ) ->
      
      return

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

    $scope.search_subjects = ( subject ) ->
      console.log subject.name
      console.log $filter('filter')( $scope.subjects_list, subject.name )
      $scope.search_subjects = $filter('filter')( $scope.subjects_list, subject.name )


    $scope.subject_picked = ( subject )->
      $scope.selected.subject_name = subject
      set_params()

    $scope.county_picked = ( county )->
      $scope.selected.county_name = county
      set_params()

    define_subjects = ( subjects ) ->
      $scope.subjects_list = []
      for subject in subjects
        $scope.subjects_list.push( subject.name )

      console.log $scope.subjects_list
     

    $scope.search_counties = ->
      $scope.counties = $filter('filter')( $scope.county_list, $scope.county )


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
      console.log $scope.selected.subject_name
      $state.transitionTo(
        'search',
        { name: $scope.selected.subject_name, location: $scope.selected.county_name }
        { notify: false }
      )


])