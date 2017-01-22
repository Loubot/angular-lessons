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
  "counties"
  ( $scope, $rootScope, $state, $stateParams, $filter, COMMS, alertify, $mdSidenav , counties ) ->
    console.log "SearchController"

    #pagination
    $scope.page_size = 5
    $scope.current_page = 1


    $scope.selected = {}
    $scope.selected.subject_name = $stateParams.name
    $scope.selected_county_name = $stateParams.location
    console.log $scope.selected_county_name
    $scope.selected_subject = $stateParams.name


    set_params = ->      
      $state.transitionTo(
        'search',
        { name: $scope.selected.subject_name, location: $scope.selected_county_name  }
        { notify: false }
      )

    $scope.view_teacher = ( teacher ) ->
      $state.go('view_teacher', id: teacher.id )


    $scope.scrollevent = ( $e ) ->
      
      return

    $scope.search_teachers = ->
      $scope.selected = {}
      if $scope.selected? && !$scope.selected.subject_name?
        $scope.selected.subject_name = $("[name='subject']").val()
      if $scope.selected? && !$scope.selected.county_name?
        $scope.selected.county_name = $("[name='county']").val()
      console.log $("[name='county']").val()
      set_params()
        
      
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
      

    $scope.county_picked = ( county )->
      console.log county
      $scope.selected_county_name = county
      

    define_subjects = ( subjects ) ->
      $scope.master_subjects_list = []
      for subject in subjects
        $scope.master_subjects_list.push( subject.name )

      # console.log $scope.subjects_list

    $scope.search_subjects = ( subject ) ->
      $scope.subjects_list = $scope.master_subjects_list
      $scope.subjects_list = $filter('filter')( $scope.subjects_list, subject )
     

    $scope.search_counties = ( county ) ->
      console.log county
      $scope.counties = $filter('filter')( $scope.county_list, county )


    $scope.county_list = counties.county_list() #conties factory

    COMMS.GET(
        '/search-subjects'
    ).then( ( resp ) ->
      console.log resp
      $scope.subjects_list = resp.data.subjects
      define_subjects( resp.data.subjects )
    ).catch( ( err ) ->
      console.log err
    )
      

    $scope.search_nav = ->
      $mdSidenav('search_nav').toggle()
])