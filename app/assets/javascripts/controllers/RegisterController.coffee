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
      $auth.authenticate( 'facebook', { params: { resource_class: 'Teacher' } } )

    

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

    $scope.county_lists =
          'Antrim': { lat: 54.719508, lon: -6.207256 }, 'Armagh': { lat: 54.350277, lon: -6.652822},
          'Carlow': { lat: 52.836497, lon: -6.934238}, 'Cavan': { lat: 53.989637, lon: -7.363272 },
          'Clare': { lat: 52.847097, lon: -8.989040 }, 'Cork': { lat: 51.897887, lon: -8.475431},
          'Derry': { lat: 54.996669, lon: -7.308567 }, 'Donegal': { lat: 54.832874, lon: -7.485811},
          'Down': { lat: 54.328787, lon: -5.715719 }, 'Dublin': { lat: 53.346591, lon: -6.265231 },
          'Fermanagh': { lat: 54.343928, lon: -7.631644 }, 'Galway': { lat: 53.270672, lon: -9.056779 },
          'Kerry': { lat: 52.059816, lon: -9.504487 }, 'Kildare': { lat: 53.220438, lon: -6.659570 },
          'Kilkenny': { lat: 52.653411, lon: -7.248446 }, 'Laois': { lat: 53.032791, lon: -7.300100 },
          'Leitrim': { lat: 53.945234, lon: -8.086559 }, 'Limerick': { lat: 52.664942, lon: -8.628080 },
          'Longford': { lat: 53.727371, lon: -7.793887}, 'Louth': { lat: 53.999672, lon: -6.406295 },
          'Mayo': { lat: 53.854566, lon: -9.288492 }, 'Meath': { lat: 53.647000, lon: -6.697336 },
          'Monaghan': { lat: 54.248650, lon: -6.969560 }, 'Offaly': { lat: 53.275140, lon: -7.493240 },
          'Roscommon': { lat: 53.627545, lon: -8.189194 }, 'Sligo': { lat: 54.273910, lon: -8.473718 }, 
          'Tipperary': { lat: 52.356254, lon: -7.695380 }, 'Tyrone': { lat: 54.597003, lon: -7.310752 },
          'Waterford': { lat: 52.257693, lon: -7.110284 }, 'Westmeath': { lat: 53.524646, lon: -7.339487 },
          'Wexford': { lat: 52.333583, lon: -6.474672 }, 'Wicklow': { lat: 52.980215, lon: -6.060273 }

    for c in $scope.county_list
      console.log c
])