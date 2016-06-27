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