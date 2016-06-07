'use strict'

angular.module('lessons', [
  'ui.router'
  'templates'
  'ngMaterial'
  'ng-token-auth'
])

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