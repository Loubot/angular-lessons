'use strict'

angular.module('lessons').controller( 'SearchController', [
  "$scope"
  "$rootScope"
  "$state"
  "$stateParams"
  "$filter"
  "COMMS"
  "alertify"
  "$mdSidenav"
  "counties"
  ( $scope, $rootScope, $state, $stateParams, $filter, COMMS, alertify, $mdSidenav , counties ) ->
    console.log "SearchController"

    
    #pagination
    $scope.page_size = 5
    $scope.current_page = 1


    $scope.selected = {}
    
    $scope.selected.subject_name = $stateParams.name
    console.log $scope.selected.subject_name
    $scope.selected_county_name = $stateParams.location


    set_params = ->      
      $state.transitionTo(
        'search',
        { name: $scope.selected.subject_name, location: $scope.selected_county_name  }
        { notify: false }
      )

    $scope.view_teacher = ( teacher ) ->
      $state.go('view_teacher', id: teacher.id )


    $scope.search_teachers = ->
      console.log "search teachers"
      set_params()
        
      search_params = { subject_name: $scope.selected.subject_name, county_name: $scope.selected_county_name }
      
      COMMS.GET(
        "/search"
        search_params
      ).then( ( resp ) ->
        console.log resp
        alertify.success "Found #{ resp.data.teachers.length } teacher(s)"
        $scope.teachers = resp.data.teachers
      ).catch( ( err ) ->
        console.log err
        alertify.error "Failed to find teachers"
      )

    $scope.search_teachers()

    


    $scope.subject_picked = ( subject )->
      $scope.search_teachers() if subject?
      $scope.selected.subject_name = subject
      

    $scope.county_picked = ( county )->
      $scope.search_teachers() if county?
      $scope.selected_county_name = county
      

    define_subjects = ( subjects ) ->
      $scope.master_subjects_list = []
      for subject in subjects
        $scope.master_subjects_list.push( subject.name )

      # console.log $scope.subjects_list

    $scope.search_subjects = ( subject ) ->
      $scope.subjects_list = $scope.master_subjects_list
      $scope.subjects_list = $filter('filter')( $scope.subjects_list, subject )
     

    $scope.search_counties = ( county ) ->
      console.log county
      $scope.counties = $filter('filter')( $scope.county_list, county )


    $scope.county_list = counties.county_list() #conties factory

    COMMS.GET(
        '/search-subjects'
    ).then( ( resp ) ->
      console.log resp
      $scope.subjects_list = resp.data.subjects
      define_subjects( resp.data.subjects )
    ).catch( ( err ) ->
      console.log err
    )
      

    $scope.search_nav = ->
      $mdSidenav('search_nav').toggle()


    ################ Show profile pic #####################################
    $scope.teacher_profile = ( teacher ) ->
      url = null
      for pic in teacher.photos
        if pic.id == teacher.profile
          url = pic.avatar.url

      url
      

    ################ End of show profile pic ##############################
])