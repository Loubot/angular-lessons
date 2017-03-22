'use strict'

angular.module('lessons').controller('WelcomeController', [
  '$scope'
  '$rootScope'
  '$state'
  '$filter'
  '$stateParams'
  '$location'
  'User'
  '$mdSidenav'
  'alertify'
  '$auth'
  'COMMS'
  '$window'
  'OG'
  'counties'
  'change_title'
  ( $scope, $rootScope, $state, $filter, $stateParams, $location, User, $mdSidenav, alertify, $auth, COMMS, $window, OG, counties, change_title ) ->
    console.log "WelcomeController"

    change_title.set_to "Find teachers Dublin | Find teachers Ireland| grinds Ireland | Learn Your Lesson"

    OG.set_tags()

    $scope.selected = {}
    $scope.selected.subject_name = $stateParams.name
    $scope.selected.county_name = $stateParams.location
    $scope.selected_subject = $stateParams.name

    pic_no = 1

    change_image = ( pic_no ) ->
      if pic_no == 2
        $('.main_page_search_container').addClass 'main_page_search_container_second_background', duration: 1000
        $('.main_page_search_container').removeClass 'main_page_search_container_first_background', duration: 1000
        
        # $('.main_page_search_container').addClass 'cssSlideUp'
        pic_no = 1
      else if pic_no == 1
        $('.main_page_search_container').removeClass 'main_page_search_container_second_background', duration: 1000
        $('.main_page_search_container').addClass 'main_page_search_container_first_background', duration: 1000
        # $('.main_page_search_container').addClass 'cssSlideUp'
        pic_no = 2

      setTimeout (->
        # $('.main_page_search_container').removeClass 'cssSlideUp'
        change_image( pic_no )
      ), 5000

    $('.main_page_search_container').addClass 'main_page_search_container_first_background'
    change_image( pic_no )


    $scope.search = ->
      $scope.selected = {}
      if $scope.selected? && !$scope.selected.county_name?
        $scope.selected.county_name = $("[name='county']").val()
      if $scope.selected && !$scope.selected.subject_name?
        $scope.selected.subject_name = $("[name='subject']").val()
      # if $scope.selected.subject_name.length > 0

      params = { name: $("[name='subject']").val(), location: $("[name='county']").val()  }
      console.log params

      $state.go(
        'search',
        params
      )
       
      # $state.go( "search", { name: $scope.selected.subject_name, location: $scope.selected.county_name } )

    $scope.subject_picked = ( subject )->
      console.log 'hup'
      if $scope.selected.subject_name?
        $scope.selected.subject_name = subject
        

    $scope.county_picked = ( county )->
      if $scope.selected.county_name?
        $scope.selected.county_name = county
        

    define_subjects = ( subjects ) ->
      console.log subjects
      $scope.master_subjects_list = []
      $scope.master_subjects_list = []
      for subject in subjects
        $scope.master_subjects_list.push( subject.name )

      # console.log $scope.subjects_list

    $scope.search_subjects = ( subject ) ->
      $scope.subjects_list = $scope.master_subjects_list
      $scope.subjects_list = $filter('filter')( $scope.subjects_list, subject )

     

    $scope.search_counties = ( county ) ->
      $scope.counties = $filter('filter')( $scope.county_list, county )


    $rootScope.$watch 'subject_list_for_menu', ( nv, ov ) ->
      $scope.master_subjects_list = nv
      
    $scope.county_list = counties.county_list() #counties factory



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
      $('.scroll_animate').scroll(->
        $('.anchor1').addClass 'animated' if isElementInView('.anchor1')
        
        $('.anchor2').addClass 'animated' if isElementInView('.anchor2')

      )    

    ############## End of animation ###############################################

])
