'use strict'

angular.module('lessons').controller('TeacherController', [
  '$scope'
  '$rootScope'
  '$state'
  'RESOURCES'
  'USER'
  'alertify'
  'COMMS'  
  '$stateParams'
  '$auth'
  'Upload'
  '$mdBottomSheet'
  '$mdDialog'
  ( $scope, $rootScope, $state, RESOURCES, USER, alertify, COMMS, $stateParams, $auth, Upload, $mdBottomSheet, $mdDialog ) ->
    console.log "TeacherController"
    $scope.photos = null
    # alertify.success "Got subjects"

    $scope.scrollevent = ( $e ) ->
      
      # animate_elems()
      # @scrollPos = document.body.scrollTop or document.documentElement.scrollTop or 0
      # $scope.$digest()
      return
    
    $scope.upload = ( file ) ->
      Upload.upload(
        url: "#{ RESOURCES.DOMAIN }/teacher/#{ $rootScope.USER.id }/photos"
        file: $scope.file
        avatar: $scope.file
        data:
          avatar: $scope.file
      ).then( ( resp ) -> 
        console.log resp
        $scope.photos = resp.data.photos if resp.data != ""
        alertify.success("Photo uploaded ok")
        if resp.data.status == "updated"
          $rootScope.USER = resp.data.teacher
          profile_pic()
          alertify.success "Profile pic set"

        $scope.file = null
      ).catch( ( err ) ->
        console.log err
      )


    
    USER.get_user().then( ( user ) ->
      alertify.success "Got user"
      console.log $rootScope.USER.overview == null
      if $rootScope.USER.id != parseInt( $stateParams.id )
        $state.go 'welcome'
        alertify.error "You are not allowed to view this"
        return false
      $scope.photos = $rootScope.USER.photos
      $scope.subjects = $rootScope.USER.subjects
      $scope.experience = $rootScope.USER.experience
      $scope.quals = $rootScope.USER.qualifications
      profile_pic()


    ).catch( ( err ) ->
      alertify.error "No user"
      $rootScope.USER = null
      $state.go 'welcome'
      return false
    )
    

    $scope.make_profile = ( id ) ->
      COMMS.POST(
        '/teacher'
        profile: id, id: $rootScope.USER.id
      ).then( ( resp ) ->
        console.log resp
        alertify.success "Updated profile pic"
        if resp.data.status == "updated"
          $rootScope.USER = resp.data.teacher
          profile_pic()
      ).catch( ( err ) ->
        console.log err
        alertify.error "Failed to update profile"
      )

    profile_pic = ->
      if !$rootScope.USER.profile?
        console.log "No profile"
        $scope.profile = null
        return false
      for photo in $scope.photos
        # console.log photo.avatar.url
        if parseInt( photo.id ) == parseInt( $rootScope.USER.profile )
          $scope.profile = photo
          console.log $scope.profile
          $scope.profile

    $scope.destroy_pic = ( id ) ->
      COMMS.DELETE(
        "/teacher/#{ $rootScope.USER.id }/photos/#{ id }"
      ).then( ( resp ) ->
        console.log resp
        alertify.success "Deleted photo ok"
        $scope.photos = resp.data.teacher.photos
        $rootScope.USER.profile = resp.data.teacher.profile
        profile_pic()
      ).catch( ( err ) ->
        console.log err
        alertify.error "Failed to delete photo"
      )


    ####################### Subjects ###############################

    $scope.get_subjects = ->
      console.log $scope.searchText
      COMMS.GET(
        '/subjects'
        search: $scope.searchText
      ).then( ( resp ) ->
        console.log resp
        # alertify.success "Got subjects"
        $scope.search_subjects = resp.data
        return resp.data.subjects
      ).catch( ( err ) ->
        console.log err
        alertify.error "Failed to get subjects"
      )

    $scope.select_subject = ( subject )->
      COMMS.POST(
        "/teacher/#{ $rootScope.USER.id }/add-subject"
        subject: subject, teacher: $rootScope.USER
      ).then( ( resp ) ->
        console.log resp
        alertify.success "Successfully added subject"
        $scope.subjects = resp.data.subjects
      ).catch( ( err ) ->
        console.log err
        alertify.error err.data.error if err.data.error?
        $scope.subjects = err.data.subjects
      )

    $scope.remove_subject = ( subject ) ->
      COMMS.DELETE(
        "/teacher/#{ $rootScope.USER.id }/remove-subject"
        subject: subject
      ).then( ( resp ) ->
        console.log resp
        alertify.success "Successfully removed subject"
        $scope.subjects = resp.data.subjects
      ).catch( ( err ) ->
        console.log err
        alertify.error err.data.error
      )
    ####################### end of Subjects ###############################

    ####################### Experience ###################################

    $scope.add_experience = ->
      $scope.experience.teacher_id = $rootScope.USER.id
      COMMS.POST(
        "/teacher/#{ $rootScope.USER.id }/experience"
        $scope.experience
      ).then( ( resp ) ->
        console.log resp
        $scope.experience = resp.data.experience
        alertify.success "Experience added"
        # $scope.experience.description = null

      ).catch( ( err ) ->
        console.log err
        alertify.error "Failed to add experience"
      )

    $scope.remove_experience = ( experience ) ->
      COMMS.DELETE(
        "/experience/#{ experience.id }"
        experience
      ).then( ( resp ) ->
        console.log resp
        $scope.experience = resp.data.experience
        alertify.success "Removed experience"
      ).catch( ( err ) ->
        console.log err
        alertify.error "Failed to delete subject"
      )

    ####################### end of experience ############################

    ####################### Update teacher #####################################
    $scope.update_teacher = ->
      
      COMMS.POST(
        '/teacher'
        $scope.USER
      ).then( ( resp) ->
        console.log resp
        alertify.success "Updated your profile"
        $rootScope.USER = resp.data.teacher
        $mdBottomSheet.hide()
      ).catch( ( err ) ->
        console.log err
        alertify.error "Failed to update teacher"

      )

    $scope.change_to_student = ->
      $scope.change_user_type = true
      $scope.USER.is_teacher = false
      $scope.update_teacher()

    ####################### End of update teacher ##############################

    ####################### Qualification ######################################
    $scope.create_qualification = ->
      COMMS.POST(
        "/teacher/#{ $rootScope.USER.id }/qualification"
        $scope.qualification
      ).then( ( resp ) ->
        console.log resp
        $scope.quals = resp.data.qualifications
        alertify.success "Created qualification"
        console.log $scope.quals
        $mdBottomSheet.hide()
      ).catch( ( err ) ->
        console.log err
        alertify.error err.errors.full_messages
      )
    ####################### End of qualification ###############################

    ####################### Sheets #######################################
    $scope.show_overview_sheet = ->
      $mdBottomSheet.show(
        templateUrl: "sheets/overview_sheet.html"
        controller: "TeacherController"
        scope: $scope
        preserveScope: true
      )

    $scope.show_qualification_sheet = ->
      $mdBottomSheet.show(
        templateUrl: "sheets/qualification_sheet.html"
        controller: "TeacherController"
        scope: $scope
        preserveScope: true
      )


    ####################### end of sheets ################################


    ####################### Password #####################################
    $scope.open_change_password = ->
      console.log "Hup"
      $mdDialog.show(
        templateUrl: "dialogs/change_password.html"
        openFrom: '#left'
        closeTo: '#right'
        scope: $scope
        preserveScope: true

      )

    $scope.closeDialog = ->
      $mdDialog.hide()

    $scope.change_password = ->
      $auth.updatePassword($scope.update_password).then((resp) ->
        console.log resp
        return
      ).catch (resp) ->
        console.log resp
        return

    $scope.$on 'auth:password-change-success', (ev) ->
      alertify.success 'Your password has been successfully updated!'
      $scope.closeDialog()
      $scope.update_password = null
      return

    $scope.$on 'auth:password-change-error', (ev, reason) ->
      $scope.closeDialog()
      $scope.update_password = null
      alertify.error 'Registration failed: ' + reason.errors[0]
      return
    ####################### End of password ##############################
])