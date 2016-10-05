'use strict'

angular.module('lessons').controller('AdminController', [
  "$scope"
  "$rootScope"
  "$state"
  "USER"
  "COMMS"
  "alertify"
  "$mdDialog"

  ( $scope, $rootScope, $state, USER, COMMS, alertify, $mdDialog ) ->
    console.log "AdminController"

    USER.get_user().then( ( resp ) ->
      if $rootScope.USER.admin == false
        alertify.error "You must be an admin to view this"
        $state.go "welcome"
        return
      USER.check_user()
      COMMS.GET(
          "/category"
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
        "/category"
        name: $scope.name
      ).then( ( resp ) ->
        console.log resp
        alertify.success "Created category"
        $('.admin_inputs').val ""
        $scope.categories = resp.data.categories
      ).catch( ( err ) ->
        console.log err
        alertify.error "Failed to create category"
      )

    $scope.create_subject = ->
      console.log $scope.subject.category
      COMMS.POST(
        "/category/#{ $scope.subject.category }/subject"
        $scope.subject
      ).then( ( resp ) ->
        console.log resp
        alertify.success "Created subject"
        $('.admin_inputs').val ""
      ).catch( ( err ) ->
        console.log err
        alertify.error "Failed to create subject"
      )

    $scope.delete_category = ->


    $scope.update_category = ( name, id ) ->
      COMMS.PUT(
        "/category/#{ id }"
        name: name
      ).then( ( resp ) ->
        console.log resp
        alertify.success "Update category ok"
        $scope.categories = resp.data.categories
      ).catch( ( err ) ->
        console.log err
        alertify.error "Couldn't update category"

      )


    $scope.update_subject = ( name, id ) ->
      COMMS.PUT(
        "/subject/#{ id }"
        name: name
      ).then( ( resp ) ->
        console.log resp
        alertify.success "Update subject successfully"
        $scope.subjects = resp.data.subjects
        $scope.edit_item = false
      ).catch( ( err ) ->
        console.log err
        alertify.error "Failed to update subjects"
        $scope.edit_item = false
      )


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