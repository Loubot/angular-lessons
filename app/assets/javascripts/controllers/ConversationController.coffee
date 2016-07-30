'use strict'

angular.module('lessons').controller('ConversationController', [
  "$state"
  "$rootScope"
  "$stateParams"
  ( $state, $rootScope, $stateParams ) ->
    console.log "ConversationController"
    console.log $stateParams
])