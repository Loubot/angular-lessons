'use strict'

angular.module('lessons').controller('TeacherController', [
  '$scope'
  '$rootScope'
  'USER'
  'alertify'
  'COMMS'
  'FileUploader'
  '$stateParams'
  ( $scope, $rootScope, USER, alertify, COMMS, FileUploader, $stateParams ) ->
    console.log "TeacherController"
    alertify.success $stateParams.id  
])