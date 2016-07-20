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
  ( $scope, $rootScope, $state, RESOURCES, USER, alertify, COMMS, $stateParams, $auth, Upload, $mdBottomSheet ) ->
    console.log "TeacherController"
    $scope.photos = null
    # alertify.success "Got subjects"

    
    
    $scope.upload = ( file ) ->
      Upload.upload(
        url: "#{ RESOURCES.DOMAIN }/teacher/#{ $rootScope.USER.id }/pic"
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


    if !( $rootScope.USER? )
      USER.get_user().then( ( user ) ->
        alertify.success "Got user"
        console.log $rootScope.USER.overview == null
        if $rootScope.USER.id != parseInt( $stateParams.id )
          $state.go 'welcome'
          alertify.error "You are not allowed to view this"
          return false

        COMMS.GET(
          "/teacher/profile"
          id: $rootScope.USER.id
        ).then( ( resp ) ->
          console.log resp
          $scope.photos = resp.data.photos
          $scope.subjects = resp.data.subjects
          $scope.experiences = resp.data.experiences
          $scope.quals = resp.data.qualifications
          profile_pic()
        ).catch( ( err ) ->
          console.log err
        )
      ).catch( ( err ) ->
        alertify.error "No user"
        $rootScope.USER = null
        $state.go 'welcome'
        return false
      )
    else
      COMMS.GET(
          "/teacher/profile"
          id: $rootScope.USER.id
        ).then( ( resp ) ->
          console.log resp
          $scope.photos = resp.data.photos
          $scope.subjects = resp.data.subjects
          $scope.experiences = resp.data.experiences
          $scope.quals = resp.data.qualifications
          profile_pic()
        ).catch( ( err ) ->
          console.log err
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
      for photo in $scope.photos
        # console.log photo.avatar.url
        if parseInt( photo.id ) == parseInt( $rootScope.USER.profile )
          console.log photo
          $scope.profile = photo
          console.log $scope.profile
          $scope.profile


    ####################### Subjects ###############################

    $scope.get_subjects = ->
      console.log $scope.searchText
      COMMS.GET(
        '/subjects'
        search: $scope.searchText
      ).then( ( resp ) ->
        console.log resp
        # alertify.success "Got subjects"
        $scope.subjects = resp.data
        return resp.data
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
        '/teacher/remove-subject'
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
      COMMS.POST(
        "/teacher/#{ $rootScope.USER.id }/experience"
        $scope.experience
      ).then( ( resp ) ->
        console.log resp
        $scope.experiences = resp.data.experiences
        alertify.success "Experience added"
        $scope.experience.title = null
        $scope.experience.description = null

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
        $scope.experiences = resp.data.experiences
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
      )

    $scope.show_qualification_sheet = ->
      $mdBottomSheet.show(
        templateUrl: "sheets/qualification_sheet.html"
        controller: "TeacherController"
      )


    ####################### end of sheets ################################
])