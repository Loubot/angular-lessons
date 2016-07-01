'use strict'

angular.module('lessons', [
  'ngAlertify'
  'ui.router'
  'templates'
  'ngMaterial'
  'ng-token-auth'
  'angularSpinner'  
  'ap.fotorama'
  'ngFileUpload'
  'angular-google-gapi'
])

angular.module('lessons').constant "RESOURCES", do ->
  url = window.location.origin
  # console.log "Domain #{ url + '/api' }"
  DOMAIN: url + '/api'


angular.module('lessons').config ($stateProvider, $urlRouterProvider) ->
  $urlRouterProvider.otherwise "/"

  $stateProvider.state 'welcome',
    url: '/'
    templateUrl: "static/welcome.html"
    controller: "WelcomeController"

  $stateProvider.state 'teacher',
    url: '/teacher/:id'
    templateUrl: "user/teacher.html"
    controller: "TeacherController"

  $stateProvider.state 'teacher_area',
    url: '/teacher-area'
    templateUrl: "user/teacher_area.html"
    controller: "TeacherAreaController"

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

angular.module('lessons').run( [
  'GAuth'
    'GApi'
    'GData'
    '$state'
    '$rootScope'
    (GAuth, GApi, GData, $state, $rootScope) ->
      $rootScope.gdata = GData
      CLIENT = 'yourGoogleAuthAPIKey' 
      GApi.load 'calendar', 'v3'
      # for google api (https://developers.google.com/apis-explorer/)
      GAuth.setClient CLIENT
      GAuth.setScope 'https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/calendar.readonly'
      # default scope is only https://www.googleapis.com/auth/userinfo.email
      # load the auth api so that it doesn't have to be loaded asynchronously
      # when the user clicks the 'login' button. 
      # That would lead to popup blockers blocking the auth window
      GAuth.load()
      # or just call checkAuth, which in turn does load the oauth api.
      # if you do that, GAuth.load(); is unnecessary
      GAuth.checkAuth().then ((user) ->
        console.log user.name + 'is login'
        $state.go 'welcome'
        # an example of action if it's possible to
        # authenticate user at startup of the application
        return
      ), ->
        $state.go 'login'
        # an example of action if it's impossible to
        # authenticate user at startup of the application
        return
      return
])



angular.module('lessons').service 'USER', ( $http, $rootScope, RESOURCES, $q, usSpinnerService ) ->
  usSpinnerService.spin('spinner-1')
  get_user: ->
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
        $rootScope.USER = result.data
        resolve result.data
      ).catch( ( err_result ) ->
        
        console.log err_result
        reject err_result
      )

angular.module('lessons').service 'AUTH', ( $http, $rootScope, RESOURCES, $q, $auth, alertify, usSpinnerService ) ->
  usSpinnerService.spin('spinner-1')

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


angular.module('lessons').service 'COMMS', ( $http, $state, RESOURCES, $rootScope, $q, usSpinnerService ) ->
  console.log "comms service"
  
  POST: ( url, data ) ->
    usSpinnerService.spin('spinner-1')
    $q ( resolve, reject ) ->
      $http(
        method: 'POST'
        url: "#{ RESOURCES.DOMAIN }#{ url }"
        headers: { "Content-Type": "application/json" }
        data: data
      ).then( ( result ) ->
        usSpinnerService.stop('spinner-1')
        if result.user != undefined
          $rootScope.USER = result.user
        resolve result
      ).catch( ( err_result ) ->
        usSpinnerService.stop('spinner-1')
        reject err_result
      )

  GET: ( url, params ) ->
    usSpinnerService.spin('spinner-1')
    $q ( resolve, reject ) ->
      $http(
        method: 'GET'
        headers: { "Content-Type": "application/json" }
        url: "#{ RESOURCES.DOMAIN }#{ url }"
        params: params
      ).then( ( result ) ->
        usSpinnerService.stop('spinner-1')
        
        resolve result
      ).catch( ( err_result ) ->
        usSpinnerService.stop('spinner-1')
        reject err_result
      )

  DELETE: ( url, params ) ->
    usSpinnerService.spin('spinner-1')
    $q ( resolve, reject ) ->
      $http(
        method: 'DELETE'
        headers: { "Content-Type": "application/json" }
        url: "#{ RESOURCES.DOMAIN }#{ url }"
        data: params
      ).then( ( result ) ->
        usSpinnerService.stop('spinner-1')
        
        resolve result
      ).catch( ( err_result ) ->
        usSpinnerService.stop('spinner-1')
        reject err_result
      )