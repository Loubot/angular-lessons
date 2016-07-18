'use strict'

angular.module('lessons').controller( 'SearchController', [
  "$scope"
  "$rootScope"
  "$stateParams"
  "COMMS"
  "alertify"
  ( $scope, $rootScope, $stateParams, COMMS, alertify ) ->
    console.log "SearchController"
    # console.log $stateParams
    $scope.subject = null
    $scope.searchText = {}
    $scope.subjects = []
    $scope.search_params = $stateParams

    $scope.get_subjects = ( searchText ) ->
      console.log "search"

      console.log $scope.searchText.name
      if $scope.searchText != {}
        return COMMS.GET(
          "/search-subjects"
          $scope.searchText
        ).then( ( resp ) ->
          console.log resp
          return resp.data.subjects
        ).catch( ( err ) ->
          console.log err

        )

    # console.log $stateParams

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

    COMMS.GET(
      "/search"
      $stateParams
    ).then( ( resp ) ->
      console.log resp 
    ).catch( ( err ) ->
      console.log err
    )

    $scope.subject_picked = ( a ) ->
      console.log a

    $scope.counties = ['Antrim','Armagh','Carlow','Cavan','Clare','Cork','Derry','Donegal','Down','Dublin',
          'Fermanagh','Galway','Kerry','Kildare','Kilkenny','Laois','Leitrim','Limerick','Longford',
          'Louth','Mayo','Meath','Monaghan','Offaly','Roscommon','Sligo','Tipperary','Tyrone',
          'Waterford','Westmeath','Wexford','Wicklow']
])