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
      $scope.register_teacher_form.email2.$error.matching_email = false
      $scope.register_teacher_form.confirm_password.$error.matching_password = false
      if $scope.teacher.email != $scope.teacher.confirm_email
        console.log "Error"
        $scope.register_teacher_form.email2.$error.matching_email = true
        return false
      else if $scope.teacher.password != $scope.teacher.confirm_password

        console.log "no dice"
        $scope.register_teacher_form.confirm_password.$error.matching_password = true
        return false
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

    $scope.county_lists = [ 
          'Antrim': { lat: 54.719508, lon: -6.207256 }, 'Armagh': { lat: 54.350277, lon: -6.652822},
          'Carlow': { lat: 52.836497, lon: -6.934238}, 'Cavan': { lat: 53.989637, lon: -7.363272 },
          'Clare': { lat: 52.847097, lon: -8.989040 }, 'Cork': { lat: 51.897887, lon: -8.475431},
          'Derry': { lat: 54.996669, lon: -7.308567 }, 'Donegal': { lat: 54.832874, lon: -7.485811},
          'Down': { lat: 54.328787, lon: -5.715719 }, 'Dublin': { lat: 53.346591, lon: -6.265231 },
          'Fermanagh': { lat: 54.343928, lon: -7.631644 }, 'Galway': { lat: 53.270672, lon: -9.056779 },
          'Kerry': { lat: 52.059816, lon: -9.504487 }, 'Kildare': { lat: 53.220438, lon: -6.659570 },
          'Kilkenny': { lat: 52.653411, lon: -7.248446 }, 'Laois': { lat: 53.032791, lon: -7.300100 },

     ]
        
])