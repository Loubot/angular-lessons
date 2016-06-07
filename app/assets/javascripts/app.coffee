'use strict'

angular.module('lessons', [
  'ui.router'
  'templates'

])

angular.module('lessons').config ($stateProvider, $urlRouterProvider) ->
  $urlRouterProvider.otherwise "/"

  $stateProvider.state 'user',
    url: '/user'
    templateUrl: "user.html"
    controller: "UserController"