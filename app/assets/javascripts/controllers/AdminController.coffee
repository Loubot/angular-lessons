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
          run_fb()
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

    # Facebook share stuff

    create_subjects_list = ( teacher ) ->
      $scope.subject_list = ""
      for s, i in teacher.subjects
        $scope.subject_list = "#{ $scope.subject_list }#{ s.name }"
        $scope.subject_list = "#{ $scope.subject_list }, " if teacher.subjects.length >= 1 and i != teacher.subjects.length - 1
      $scope.subject_list = "#{ $scope.subject_list }"

    set_profile = ( teacher ) ->
      return true if teacher.photos? && teacher.photos.length == 0

      for photo in teacher.photos
        # console.log photo.avatar.url
        if parseInt( photo.id ) == parseInt( teacher.profile )
          # console.log photo
          $scope.profile = photo

      console.log $scope.profile
      $scope.profile.avatar.url

    fb_share = ( teacher ) ->
      FB.ui {
        method: 'feed'
        href: "http://www.learnyourlesson.ie/#/view-teacher/#{ teacher.id }"
        picture: set_profile( teacher )
        from: '534105600060664'
        caption: "#{ create_subjects_list( teacher ) } lessons"
      }, (response) ->
        console.log response

    # End of facebook share stuff

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