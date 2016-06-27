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
  ( $scope, $rootScope, $state, RESOURCES, USER, alertify, COMMS, $stateParams, $auth, Upload ) ->
    console.log "TeacherController"
    $scope.photos = null
    # alertify.success "Got subjects"

    
    
    $scope.upload = ( file ) ->
      console.log file
      Upload.upload(
        url: "#{ RESOURCES.DOMAIN }/teacher/profile-pic"
        file: file
        avatar: file
        data:
          avatar: file
          id: $rootScope.USER
      ).then( ( resp ) -> 
        console.log resp
        $scope.photos = resp.data.photos
        alertify.success("Photo uploaded ok")
        if resp.data.status == "updated"
          $rootScope.USER = resp.data.teacher
          profile_pic()
          alertify.success "Profile pic set"
      )



    USER.get_user().then( ( user ) ->
      alertify.success "Got user"

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
        profile_pic()
      ).catch( ( err ) ->
        console.log err
      )
    ).catch( ( err ) ->
      alertify.error "No user"
      $rootScope.USER = null
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
      for photo in $scope.photos
        # console.log photo.avatar.url
        if parseInt( photo.id ) == parseInt( $rootScope.USER.profile )
          $scope.profile = photo.avatar.url
          console.log $scope.profile
          $scope.profile_pic


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
        "/teacher/add-subject"
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
])