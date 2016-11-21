angular.module('lessons').run [
  '$rootScope'
  ($rootScope) ->
    $rootScope.$on 'auth:validation-success', ( e ) ->
      console.log 'bl'
      console.log e