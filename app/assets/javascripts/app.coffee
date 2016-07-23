'use strict'

angular.module('lessons', [
  'ngAlertify'
  'ui.router'
  'templates'
  'ngMaterial'
  'ng-token-auth'  
  'ap.fotorama'
  'ngFileUpload'
  'ui.rCalendar'
  'angular-loading-bar'
  'ngAnimate'

])

angular.module('lessons').constant "RESOURCES", do ->
  url = window.location.origin
  # console.log "Domain #{ url + '/api' }"
  DOMAIN: url + '/api'

angular.module('lessons').directive 'scroll', ($window) ->
  {
    scope: scrollEvent: '&'
    link: (scope, element, attrs) ->
      $('#' + attrs.id).scroll ($e) ->
        if scope.scrollEvent != null then scope.scrollEvent()($e) else null
        return
      return

  }
# angular.module('lessons').config (uiGmapGoogleMapApiProvider) ->
#   uiGmapGoogleMapApiProvider.configure
#     key: 'AIzaSyBpOd04XM28WtAk1LcJyhlQzNW6P6OT2Q0'
#     v: '3.23'
#     libraries: 'places'


angular.module('lessons').config ($stateProvider, $urlRouterProvider) ->
  $urlRouterProvider.otherwise "/"

  $stateProvider.state 'welcome',
    url: '/'
    templateUrl: "static/welcome.html"
    controller: "WelcomeController"

  $stateProvider.state 'search',
    url: '/search/:name/:location'
    templateUrl: "static/search.html"
    controller: "SearchController"

  $stateProvider.state 'teacher',
    url: '/teacher/:id'
    templateUrl: "user/teacher.html"
    controller: "TeacherController"

  $stateProvider.state 'view_teacher',
    url: '/view-teacher/:id'
    templateUrl: "user/view_teacher.html"
    controller: "ViewTeacherController"

  $stateProvider.state 'teacher_area',
    url: "/teacher-area/:id"
    templateUrl: "user/teacher_area.html"
    controller: "TeacherAreaController"

  $stateProvider.state 'teacher_location',
    url: '/teacher-location/:id'
    templateUrl: "user/teacher_location.html"
    controller: "TeacherLocationController"

  $stateProvider.state 'how_it_works',
    url: '/how-it-works'
    templateUrl: 'static/how_it_works.html'
    controller: "UserController"

angular.module('lessons').config ( $authProvider ) ->
  $authProvider.configure({
    apiUrl: "http://localhost:3000/api"
  })

angular.module('lessons').config ( $mdThemingProvider ) ->
  $mdThemingProvider.theme('default')
    .primaryPalette('green')
    .accentPalette('blue-grey')


angular.module('lessons').service 'USER', ( $http, $rootScope, RESOURCES, $q ) ->
  
  get_user: -> # get user and all associations
    $q ( resolve, reject ) ->
      $http(
        method: 'GET'
        url: "http://localhost:3000/api/teacher/get"
        headers: { "Content-Type": "application/json" }
        # params: 
        #   email: 
      ).then( ( result ) ->
        # console.log "get user"
        # console.log result.data
        $rootScope.USER = result.data.teacher
        delete result.data.teacher
        $rootScope.associations = result.data
        # console.log $rootScope.associations
        resolve result.data
      ).catch( ( err_result ) ->
        
        console.log err_result
        reject err_result
      )

angular.module('lessons').service 'AUTH', ( $http, $rootScope, RESOURCES, $q, $auth, alertify ) ->

  signin: ( auth_hash ) ->
    $q ( resolve, reject ) ->
      $auth.submitLogin( auth_hash )
        .then( (resp) ->
          # handle success response
          console.log resp
          alertify.success "Registered successfully"
          window.localStorage.setItem 'user_email', resp.data.email
          $rootScope.USER = resp.data
          resolve resp
        )
        .catch( (resp) ->
          # handle error response
          console.log resp
          alertify.error resp.data.errors.full_messages
          $rootScope.USER = null
          reject resp
        )

  signup: ( auth_hash ) ->
    $q ( resolve, reject ) ->
      $auth.submitRegistration( auth_hash )
        .then( (resp) ->
          # handle success response
          console.log resp
          alertify.success "Registered successfully"
          window.localStorage.setItem 'user_email', resp.data.email
          $rootScope.USER = resp.data
          resolve resp
        )
        .catch( (resp) ->
          # handle error response
          console.log resp
          alertify.error resp.data.errors.full_messages
          $rootScope.USER = null
          reject resp
        )


angular.module('lessons').service 'COMMS', ( $http, $state, RESOURCES, $rootScope, $q ) ->
  console.log "comms service"
  
  POST: ( url, data ) ->
    $q ( resolve, reject ) ->
      $http(
        method: 'POST'
        url: "#{ RESOURCES.DOMAIN }#{ url }"
        headers: { "Content-Type": "application/json" }
        data: data
      ).then( ( result ) ->
        if result.user != undefined
          $rootScope.USER = result.user
        resolve result
      ).catch( ( err_result ) ->
        reject err_result
      )

  PUT: ( url, data ) ->
      $q ( resolve, reject ) ->
        $http(
          method: 'PUT'
          url: "#{ RESOURCES.DOMAIN }#{ url }"
          headers: { "Content-Type": "application/json" }
          data: data
        ).then( ( result ) ->
          if result.user != undefined
            $rootScope.USER = result.user
          resolve result
        ).catch( ( err_result ) ->
          reject err_result
        )

  GET: ( url, params ) ->
    $q ( resolve, reject ) ->
      $http(
        method: 'GET'
        headers: { "Content-Type": "application/json" }
        url: "#{ RESOURCES.DOMAIN }#{ url }"
        params: params
      ).then( ( result ) ->
        
        resolve result
      ).catch( ( err_result ) ->
        reject err_result
      )

  DELETE: ( url, params ) ->
    $q ( resolve, reject ) ->
      $http(
        method: 'DELETE'
        headers: { "Content-Type": "application/json" }
        url: "#{ RESOURCES.DOMAIN }#{ url }"
        data: params
      ).then( ( result ) ->
        
        resolve result
      ).catch( ( err_result ) ->
        reject err_result
      )