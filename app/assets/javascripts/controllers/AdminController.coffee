'use strict'

angular.module('lessons').controller('AdminController', [
  "$scope"
  "$rootScope"
  "USER"
  "COMMS"
  "alertify"
  "$mdDialog"
  ( $scope, $rootScope, USER, COMMS, alertify, $mdDialog ) ->
    console.log "AdminController"

    USER.get_user().then( ( resp ) ->
      COMMS.GET(
          "/teacher/#{ $rootScope.USER.id }/category"
        ).then( ( resp ) ->
          console.log resp
          alertify.success "Got categories"
          $scope.categories = resp.data.categories
        ).catch( ( err ) ->
          console.log err
          alertify.error "Failed to get categories"
        )
    )

    

    $scope.create_category = ->
      console.log "hup"
      COMMS.POST(
        "/teacher/#{ $rootScope.USER.id }/category"
        name: $scope.name
      ).then( ( resp ) ->
        console.log resp
        alertify.success "Created category"
        $scope.categories = resp.data.categories
      ).catch( ( err ) ->
        console.log err
        alertify.error "Failed to create category"
      )

    $scope.create_subject = ->
      console.log $scope.subject.category
      COMMS.POST(
        "/teacher/#{ $rootScope.USER.id }/category/#{ $scope.subject.category }/subject"
        $scope.subject
      ).then( ( resp ) ->
        console.log resp
        alertify.success "Created subject"
      ).catch( ( err ) ->
        console.log err
        alertify.error "Failed to create subject"
      )

    $scope.delete_category = ->



    ######################### Dialogs ####################################

    $scope.edit_categories = ->
      $mdDialog.show(
        templateUrl: "dialogs/category_dialog.html"
        scope: $scope
        preserveScope: true
        
      )

    $scope.edit_subjects = ->
      $mdDialog.show(
        templateUrl: "dialogs/subject_dialog.html"
        scope: $scope
        preserveScope: true
        onComplete: ->
          console.log 'hup'
          COMMS.GET(
            "/subject"
          ).then( ( resp ) ->
            console.log resp
            alertify.success "Got subjects"
            $scope.subjects = resp.data.subjects
          ).catch( ( err ) ->
            console.log err
            alertify.error "Failed to get subjects"
          )      
      )


    $scope.close_dialog = ->
      $mdDialog.hide()

])