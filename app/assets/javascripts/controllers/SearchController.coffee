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
    $scope.ctrl.subject_name = $stateParams.name
    $scope.ctrl.county = $stateParams.location

    $scope.view_teacher = ( teacher ) ->
      $state.go('view_teacher', id: teacher.id )


    $scope.scrollevent = ( $e ) ->
      
      return

    $scope.search_teachers = ( subject ) ->
      COMMS.GET(
        "/search"
        subject
      ).then( ( resp ) ->
        console.log resp
        alertify.success "Found #{ resp.data.teachers.length } teacher(s)"
        $scope.teachers = resp.data.teachers
      ).catch( ( err ) ->
        console.log err
        alertify.error "Failed to find teachers"
      )

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

    set_params = ->
      $state.transitionTo(
        'search',
        { name: $scope.ctrl.subject, location: $scope.ctrl.county }
        { notify: false }
      )


])