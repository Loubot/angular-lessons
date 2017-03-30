'use strict'

angular.module('lessons').controller('AdminController', [
  "$scope"
  "$rootScope"
  "auth"
  "$state"
  "COMMS"
  "Alertify"
  "$mdDialog"

  ( $scope, $rootScope, auth, $state, COMMS, Alertify, $mdDialog ) ->
    console.log "AdminController"


    $scope.page_size = 10
    $scope.current_page = 1
      

    $scope.show_teachers = false

    COMMS.GET(
      "/category"
    ).then( ( resp ) ->
      console.log resp
      $scope.categories = resp.data.categories
      Alertify.success "Got categories"
    ).catch( ( err ) ->
      console.log err
      Alertify.error "Failed to fetch categories"
    )
    

    $scope.fetch_teachers = ->
      console.log $scope.show_teachers
      if !$scope.teachers?
        COMMS.GET(
          "/teacher"
        ).then( ( resp ) ->
          console.log resp
          $scope.teachers = resp.data.teachers
          $scope.$digest
          Alertify.success "Got teachers list"
        ).catch( ( err ) ->
          console.log err
          Alertify.error "Failed to get teachers list"
        )

    $scope.open_teacher_dialog = ( teacher ) ->
      console.log teacher 
      $scope.view_teacher = teacher

      $mdDialog.show(
        templateUrl: "dialogs/view_teacher_details.html"
        scope: $scope
        preserveScope: true
        clickOutsideToClose: true
        fullscreen: $(window).width() < 600
      )

    $scope.create_category = ->
      console.log "hup"
      COMMS.POST(
        "/category"
        name: $scope.name
      ).then( ( resp ) ->
        console.log resp
        Alertify.success "Created category"
        $('.admin_inputs').val ""
        $scope.categories = resp.data.categories
      ).catch( ( err ) ->
        console.log err
        Alertify.error "Failed to create category"
      )

    $scope.create_subject = ->
      console.log $scope.subject.category
      COMMS.POST(
        "/category/#{ $scope.subject.category }/subject"
        $scope.subject
      ).then( ( resp ) ->
        console.log resp
        Alertify.success "Created subject"
        $scope.category_subjects = resp.data.subjects
        $('.admin_inputs').val ""
      ).catch( ( err ) ->
        console.log err
        Alertify.error "Failed to create subject"
      )

    $scope.delete_category = ( name, id ) ->
      COMMS.DELETE(
        "/category/#{ id }"
      ).then( ( resp ) ->
        console.log resp
        Alertify.success "Deleted category ok"
        $scope.categories = resp.data.categories
      ).catch( ( err ) ->
        Alertify.error "Failed to delete category"
        console.log err
      )

    $scope.update_category = ( name, id ) ->
      COMMS.PUT(
        "/category/#{ id }"
        name: name
      ).then( ( resp ) ->
        console.log resp
        Alertify.success "Update category ok"
        $scope.categories = resp.data.categories
      ).catch( ( err ) ->
        console.log err
        Alertify.error "Couldn't update category"

      )

    $scope.get_subjects = ( id ) ->
      COMMS.GET(
        "/category/#{ id }/category-subjects"
      ).then( ( resp ) ->
        console.log resp
        Alertify.success "Got subjects"
        $scope.category_subjects = resp.data.category_subjects
      ).catch( ( err ) ->
        console.log err
        Alertify.error "Failed to get subjects"
      )


    $scope.update_subject = ( name, id ) ->
      COMMS.PUT(
        "/subject/#{ id }"
        name: name
      ).then( ( resp ) ->
        console.log resp
        Alertify.success "Update subject successfully"
        $scope.subjects = resp.data.subjects
        $scope.edit_item = false
      ).catch( ( err ) ->
        console.log err
        Alertify.error "Failed to update subjects"
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
            Alertify.success "Got subjects"
            $scope.subjects = resp.data.subjects
          ).catch( ( err ) ->
            console.log err
            Alertify.error "Failed to get subjects"
          )      
      )


    $scope.close_dialog = ->
      $mdDialog.hide()


])