'use strict'

angular.module('lessons', [
  'ui.router'
  'templates'
  'ngMaterial'
  'ng-token-auth'
  'angularSpinner'
])

angular.module('lessons').constant "RESOURCES", do ->
  url = window.location.origin
  DOMAIN: url

angular.module('lessons').config ($stateProvider, $urlRouterProvider) ->
  $urlRouterProvider.otherwise "/"

  $stateProvider.state 'user',
    url: '/user'
    templateUrl: "user.html"
    controller: "UserController"

angular.module('lessons').config ( $mdThemingProvider ) ->
  $mdThemingProvider.theme('default')
    .primaryPalette('green')
    .accentPalette('blue-grey')


angular.module('lessons').service 'COMMS', ( $http, $state, RESOURCES, $rootScope, $q, usSpinnerService ) ->
  console.log "comms service"
  
  POST: ( url, data ) ->
    usSpinnerService.spin('spinner-1')
    $q ( resolve, reject ) ->
      $http(
        method: 'POST'
        url: "#{ RESOURCES.DOMAIN }#{ url }"
        data: data
      ).then( ( result ) ->
        usSpinnerService.stop('spinner-1')
        if result.user != undefined
          $rootScope.USER = result.user
        resolve result
      ).catch( ( err_result ) ->
        usSpinnerService.stop('spinner-1')
        reject err_result
      )