'use strict'

angular.module('lessons').controller('WelcomeController', [
  '$scope'
  '$rootScope'
  'USER'
  '$mdSidenav'
  'alertify'
  '$auth'
  ( $scope, $rootScope, USER, $mdSidenav, alertify, $auth ) ->
    console.log "WelcomeController"

])