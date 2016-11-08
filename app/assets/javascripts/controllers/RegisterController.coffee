'use strict'

angular.module('lessons').controller("RegisterController", [
  "$scope"
  "$rootScope"
  "USER"
  "$state"
  "$auth"
  "alertify"
  "COMMS"

  ( $scope, $rootScope, USER, $state, $auth, alertify, COMMS ) ->
    console.log "RegisterController"

    USER.get_user()

    $scope.scrollevent = ( $e ) ->
      
      return

    $scope.register_with_facebook = ->
      $auth.authenticate('facebook', {params: {resource_class: 'Teacher'}})

    

    $scope.register_teacher = ->
      console.log $scope.teacher
      if $scope.teacher.email != $scope.teacher.confirm_email
        console.log "Error"
        $scope.register_teacher_form.email2.$error.matching_email = true
      else if $scope.teacher.password != $scope.teacher.confirm_password

        console.log "no dice"
        $scope.register_teacher_form.confirm_password.$error.matching_password = true
      else
        console.log "No error"
        $scope.register_teacher_form.email2.$error.matching_email = false
        $scope.register_teacher_form.confirm_password.$error.matching_password = false
        # delete $scope.register_teacher_form.email2.$error.matching_email
        for att of $scope.register_teacher_form.email2.$error
          if $scope.register_teacher_form.email2.$error.hasOwnProperty(att)
            console.log att
            $scope.register_teacher_form.email2.$setValidity att, true

      $scope.teacher.is_teacher = true

      if !$scope.teacher.county?
        alertify.error "You must select your county"

      else
        console.log "made it"
        return false
        $auth.submitRegistration( $scope.teacher )
          .then( (resp) ->
            # handle success response
            # console.log resp.data.data
            $rootScope.USER = resp.data.data
            console.log $rootScope.USER
            
            alertify.success "Welcome #{ resp.data.data.email }"
            alertify.success "Registered as teacher" if $rootScope.USER.is_teacher
            alertify.success "Registered as student" if !$rootScope.USER.is_teacher

            COMMS.POST(
              "/teacher/#{ $rootScope.USER.id }/location"
              county: $scope.teacher.county
            ).then( ( resp ) ->
              console.log resp
              alertify.success "Created location"
              $state.go('teacher', id: $rootScope.USER.id )
            ).catch( ( err ) ->
              console.log err
              alertify.error "Failed to create loctation"
            )

            # $state.go 'welcome'
          )
          .catch( (resp) ->
            # handle error response
            console.log resp
            alertify.error "Failed to register"
            
          )
    $scope.county_list = ['Antrim','Armagh','Carlow','Cavan','Clare','Cork','Derry','Donegal','Down','Dublin',
          'Fermanagh','Galway','Kerry','Kildare','Kilkenny','Laois','Leitrim','Limerick','Longford',
          'Louth','Mayo','Meath','Monaghan','Offaly','Roscommon','Sligo','Tipperary','Tyrone',
          'Waterford','Westmeath','Wexford','Wicklow']
        
])