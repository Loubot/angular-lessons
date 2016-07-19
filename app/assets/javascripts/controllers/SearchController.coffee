'use strict'

angular.module('lessons').controller( 'SearchController', [
  "$scope"
  "$rootScope"
  "$stateParams"
  "$filter"
  "COMMS"
  "alertify"
  ( $scope, $rootScope, $stateParams, $filter, COMMS, alertify ) ->
    console.log "SearchController"
    $scope.ctrl = 
      subject:
        name: null
        id: null
      county: 
        null
    $scope.ctrl.subject.name = $stateParams.name
    $scope.ctrl.county = $stateParams.location

    search_teachers = ( params ) ->
      COMMS.GET(
        '/search'
        params
      ).then( ( resp ) ->
        console.log resp
        $scope.teachers = resp.data.teachers
        alertify.success "Found #{ resp.data.teachers.lenght } teacher(s)"
      ).catch( ( err ) ->
        console.log err
      )

    if $stateParams.name? || $stateParams.location?
      search_teachers( $stateParams )



    $scope.querySearch = ( a ) ->
      console.log a
      console.log $scope.ctrl
      if $scope.ctrl.searchText != null
        return COMMS.GET(
          "/search-subjects"
          $scope.ctrl
        ).then( ( resp ) ->
          console.log resp
          return resp.data.subjects
        ).catch( ( err ) ->
          console.log err

        )

    $scope.search_counties = ->
      if $scope.ctrl.county_name == ""
        define_counties()
        return false
      console.log $scope.ctrl.county_name
      $scope.counties =  $filter('filter')( $scope.counties, $scope.ctrl.county_name )

    $scope.county_picked = ( county ) ->
      console.log 'a'
      $scope.ctrl.county = county

    $scope.subject_picked = ( subject ) ->
      console.log subject
      $scope.ctrl.subject = subject
      search_teachers( $scope.ctrl )

    define_counties = ->
      return $scope.counties = ['Antrim','Armagh','Carlow','Cavan','Clare','Cork','Derry','Donegal','Down','Dublin',
          'Fermanagh','Galway','Kerry','Kildare','Kilkenny','Laois','Leitrim','Limerick','Longford',
          'Louth','Mayo','Meath','Monaghan','Offaly','Roscommon','Sligo','Tipperary','Tyrone',
          'Waterford','Westmeath','Wexford','Wicklow']
])