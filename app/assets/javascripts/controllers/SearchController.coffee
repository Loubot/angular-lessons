'use strict'

angular.module('lessons').controller( 'SearchController', [
  "$scope"
  "$rootScope"
  "$stateParams"
  "COMMS"
  "alertify"
  ( $scope, $rootScope, $stateParams, COMMS, alertify ) ->
    console.log "SearchController"
    $scope.ctrl = {}
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

    $scope.counties = ['Antrim','Armagh','Carlow','Cavan','Clare','Cork','Derry','Donegal','Down','Dublin',
          'Fermanagh','Galway','Kerry','Kildare','Kilkenny','Laois','Leitrim','Limerick','Longford',
          'Louth','Mayo','Meath','Monaghan','Offaly','Roscommon','Sligo','Tipperary','Tyrone',
          'Waterford','Westmeath','Wexford','Wicklow']
])