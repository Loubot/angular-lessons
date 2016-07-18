'use strict'

angular.module('lessons').controller( 'SearchController', [
  "$scope"
  "$rootScope"
  "$stateParams"
  "COMMS"
  "alertify"
  ( $scope, $rootScope, $stateParams, COMMS, alertify ) ->
    # console.log "SearchController"
    # console.log $stateParams

    $scope.search_params = $stateParams

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

    $scope.counties = ['Antrim','Armagh','Carlow','Cavan','Clare','Cork','Derry','Donegal','Down','Dublin',
          'Fermanagh','Galway','Kerry','Kildare','Kilkenny','Laois','Leitrim','Limerick','Longford',
          'Louth','Mayo','Meath','Monaghan','Offaly','Roscommon','Sligo','Tipperary','Tyrone',
          'Waterford','Westmeath','Wexford','Wicklow']
])