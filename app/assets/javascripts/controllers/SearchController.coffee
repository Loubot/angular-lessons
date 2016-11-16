'use strict'

angular.module('lessons').controller( 'SearchController', [
  "$scope"
  "$rootScope"
  "$state"
  "$stateParams"
  "$filter"
  "COMMS"
  "alertify"
  "$mdSidenav"
  ( $scope, $rootScope, $state, $stateParams, $filter, COMMS, alertify, $mdSidenav ) ->
    console.log "SearchController"

    $scope.selected = {}
    $scope.selected.subject_name = $stateParams.name
    $scope.selected.county_name = $stateParams.location
    $scope.selected_subject = $stateParams.name

    $scope.view_teacher = ( teacher ) ->
      $state.go('view_teacher', id: teacher.id )


    $scope.scrollevent = ( $e ) ->
      
      return

    $scope.search_teachers = ->
      if $scope.selected? && !$scope.selected.subject_name?
        $scope.selected.subject_name = $("[name='subject']").val()
      if $scope.selected? && !$scope.selected.county_name?
        $scope.selected.county_name = $("[name='county']").val()
        
      
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

    if $stateParams.name? or $stateParams.location?
      $scope.search_teachers()


    $scope.subject_picked = ( subject )->
      $scope.selected.subject_name = subject
      set_params()

    $scope.county_picked = ( county )->
      $scope.selected.county_name = county
      set_params()

    define_subjects = ( subjects ) ->
      $scope.master_subjects_list = []
      for subject in subjects
        $scope.master_subjects_list.push( subject.name )

      # console.log $scope.subjects_list

    $scope.search_subjects = ( subject ) ->
      $scope.subjects_list = $scope.master_subjects_list
      $scope.subjects_list = $filter('filter')( $scope.subjects_list, subject )
     

    $scope.search_counties = ( county ) ->
      $scope.counties = $filter('filter')( $scope.county_list, county )


    $scope.county_list = ['Co. Antrim','Co. Armagh','Co. Carlow','Co. Cavan','Co. Clare','Co. Cork','Co. Derry','Co. Donegal','Co. Down','Co. Dublin',
          'Co. Fermanagh','Co. Galway','Co. Kerry','Co. Kildare','Co. Kilkenny','Co. Laois','Co. Leitrim','Co. Limerick','Co. Longford',
          'Co. Louth','Co. Mayo','Co. Meath','Co. Monaghan','Co. Offaly','Co. Roscommon','Co. Sligo','Co. Tipperary','Co. Tyrone',
          'Co. Waterford','Co. Westmeath','Co. Wexford','Co. Wicklow']

    COMMS.GET(
        '/search-subjects'
    ).then( ( resp ) ->
      console.log resp
      $scope.subjects_list = resp.data.subjects
      define_subjects( resp.data.subjects )
    ).catch( ( err ) ->
      console.log err
    )

    set_params = ->

      
      $state.transitionTo(
        'search',
        { name: $scope.selected.subject_name, location: $scope.selected.county_name  }
        { notify: false }
      )
      

    $scope.search_nav = ->
      $mdSidenav('search_nav').toggle()
])