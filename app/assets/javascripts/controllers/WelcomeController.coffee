'use strict'

angular.module('lessons').controller('WelcomeController', [
  '$scope'
  '$rootScope'
  '$state'
  '$filter'
  '$stateParams'
  '$location'
  'USER'
  'User'
  '$mdSidenav'
  'alertify'
  '$auth'
  'COMMS'
  '$window'
  'OG'
  'counties'
  ( $scope, $rootScope, $state, $filter, $stateParams, $location, USER, User, $mdSidenav, alertify, $auth, COMMS, $window, OG, counties ) ->
    console.log "WelcomeController"

    OG.set_tags()

    $scope.selected = {}
    $scope.selected.subject_name = $stateParams.name
    $scope.selected.county_name = $stateParams.location
    $scope.selected_subject = $stateParams.name



    $scope.search_teachers = ->
      COMMS.GET(
        "/search"
        $scope.selected
      ).then( ( resp ) ->
        # console.log resp
        alertify.success "Found #{ resp.data.teachers.length } teacher(s)"
        $scope.teachers = resp.data.teachers
      ).catch( ( err ) ->
        
        console.log err
        alertify.error "Failed to find teachers"
      )

    if $stateParams.name? or $stateParams.location
      $scope.search_teachers()


    $scope.search = ->
      if $scope.selected? && !$scope.selected.county_name?
        $scope.selected.county_name = $("[name='county']").val()
      if $scope.selected && !$scope.selected.subject_name?
        $scope.selected.subject_name = $("[name='subject']").val()
      # if $scope.selected.subject_name.length > 0
      
       
      $state.go( "search", { name: $scope.selected.subject_name, location: $scope.selected.county_name } )

    $scope.subject_picked = ( subject )->
      
      if $scope.selected.subject_name?
        $scope.selected.subject_name = subject
        

    $scope.county_picked = ( county )->
      if $scope.selected.county_name?
        $scope.selected.county_name = county
        

    define_subjects = ( subjects ) ->
      $scope.master_subjects_list = []
      for subject in subjects
        $scope.master_subjects_list.push( subject.name )

      # console.log $scope.subjects_list

    $scope.search_subjects = ( subject ) ->
      $scope.subjects_list = $scope.master_subjects_list
      $scope.subjects_list = $filter('filter')( $scope.subjects_list, subject )

     

    $scope.search_counties = ( county ) ->
      $scope.counties = $filter('filter')( $scope.county_list, county )


    $scope.county_list = counties #counties factory

    COMMS.GET(
        '/search-subjects'
    ).then( ( resp ) ->
      # console.log resp
      $scope.subjects_list = resp.data.subjects
      define_subjects( resp.data.subjects )
    ).catch( ( err ) ->
      console.log err
    )


    ############## Animate explanation blocks when in view #############################

    isElementInView = (element, fullyInView) ->
      
      if $state.current.url == "/welcome" or $state.current.url == '/'
        
        pageTop = $(window).scrollTop()
        pageBottom = pageTop + $(window).height()
        elementTop = $(element).offset().top 
        elementBottom = elementTop + $(element).height()
        if fullyInView == true
          pageTop < elementTop and pageBottom > elementBottom
        else
          elementTop <= pageBottom and elementBottom >= pageTop

    if $state.current.url == "/welcome" or $state.current.url == '/'
      
      $('.main_page').scroll(->
        $('.anchor1').addClass 'animated' if isElementInView('.anchor1')
        
        $('.anchor2').addClass 'animated' if isElementInView('.anchor2')

      )    

    ############## End of animation ###############################################

])