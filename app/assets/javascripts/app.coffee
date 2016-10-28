'use strict'

angular.module('lessons', [
  'ngAlertify'
  'ui.router'
  'templates'
  'ngMaterial'
  'ng-token-auth'
  'ngFileUpload'
  'ui.rCalendar'
  'angular-loading-bar'
  'ngAnimate'
  'validation.match'
  'ngMessages'
  'mdPickers'
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


angular.module('lessons').service 'OG', ->
  set_tags: ->
    $('.added_og').remove()
    $('head').append """ <meta property="og:title" content="Learn Your Lesson." class="added_og"/>"""
    # $('head').append """ <meta property="" content="" />"""
    # $('head').append """ <meta property="" content="" />"""
    # $('head').append """ <meta property="" content="" />"""
    # $('head').append """ <meta property="" content="" />"""


angular.module('lessons').factory '$exceptionHandler', [
  () ->
    (exception, cause) ->
      # alert exception.message
      # jsLogger.fatal exception.message
      # jsLogger.fatal exception
      # jsLogger.fatal cause
      console.log exception
      console.log cause
      return
]

switch_check = ( err ) ->
  switch err
    when "Authorized users only." then return false
    when "Invalid login credentials. Please try again." then return false
    else return true

angular.module('lessons').config [
  '$httpProvider'
  ($httpProvider) ->
    $httpProvider.interceptors.push ($q) ->
      { 'responseError': (rejection) ->
        defer = $q.defer()
         
        try
          if rejection? && rejection.data? && rejection.data.errors? && rejection.data.errors.length > 0
            if switch_check( rejection.data.errors[0] )
              console.log "Sending the error"
            # console.log( "Statustext: " + rejection.statusText + " status: " + rejection.status + " url: " +  rejection.config.url + " method: " + rejection.config.method + ". Full error: " + JSON.stringify rejection )
              jsLogger.fatal JSON.stringify rejection
              console.dir rejection 
          defer.reject rejection
          defer.promise
        catch error
          console.log "Sending the error"
          jsLogger.fatal error
          console.log error

 }
    return
]
#s

angular.module('lessons').config ($stateProvider, $urlRouterProvider, $locationProvider) ->
  $locationProvider.html5Mode(true)
  
  $stateProvider.state 'home',
    url: '/'
    templateUrl: "static/welcome.html"
    controller: "WelcomeController"
  
  $stateProvider.state 'welcome',
    url: '/welcome'
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

  $stateProvider.state 'student_profile',
    url: '/student/:id'
    templateUrl: "user/student.html"
    controller: "StudentController"

  $stateProvider.state 'view_teacher',
    url: '/view-teacher/:id'
    templateUrl: "user/view_teacher.html"
    controller: "ViewTeacherController"

  $stateProvider.state 'register_teacher',
    url: "/register-teacher"
    templateUrl: "static/register_teacher.html"
    controller: "RegisterController"

  $stateProvider.state 'teacher_area',
    url: "/teacher-area/:id/:student_email"
    templateUrl: "user/teacher_area.html"
    controller: "TeacherAreaController"

  $stateProvider.state 'teacher_location',
    url: '/teacher-location/:id'
    templateUrl: "user/teacher_location.html"
    controller: "TeacherLocationController"

  $stateProvider.state 'conversation',
    url: "/conversation/:random/:id"
    templateUrl: "conversation/messages.html"
    controller: "ConversationController"

  $stateProvider.state 'how_it_works',
    url: '/how-it-works'
    templateUrl: 'static/how_it_works.html'
    controller: "UserController"

  $stateProvider.state "pl",
    url: "api/auth/password/edit"
    templateUrl: "password/reset_password.html"
    controller: "PasswordController"

  $stateProvider.state "change_password",
    url: "/change-password"
    templateUrl: "password/change_password.html"
    controller: "PasswordController"

  $stateProvider.state 'reset_password',
    url: '/reset-password/'
    templateUrl: 'password/reset_password.html'
    controller: "PasswordController"

  $stateProvider.state 'admin',
    url: "/admin"
    templateUrl: "admin/manage.html"
    controller: "AdminController"

  $urlRouterProvider.otherwise "/"
  
  

angular.module('lessons').config ( $authProvider ) ->
  $authProvider.configure({
    apiUrl: '/api'
    passwordResetPath:       '/auth/password'
    passwordUpdatePath:      '/auth/password'
    authProviderPaths: 
      facebook: '/auth/facebook'
      
  })

############## Theme #######################################
angular.module('lessons').config ( $mdThemingProvider ) ->
  $mdThemingProvider.theme('default')
    .primaryPalette('green')
    .accentPalette('blue-grey')


angular.module('lessons').service 'USER', ( $http, $rootScope, RESOURCES, $q, $state, alertify ) ->
  
  get_user: -> # get user and all associations
    $q ( resolve, reject ) ->
      $http(
        method: 'GET'
        url: "#{ RESOURCES.DOMAIN }/teacher/get"
        headers: { "Content-Type": "application/json" }
        # params: 
        #   email: 
      ).then( ( result ) ->
        console.log "get user"
        console.log result.data
        $rootScope.USER = result.data.teacher
       
        resolve result.data
      ).catch( ( err_result ) ->
        console.log err_result
        reject err_result
      )

  check_user: ->
    if !$rootScope.USER.is_teacher
      alertify.error "You must be a teacher to view this"
      $state.go "welcome"

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

      
# angular.module('lessons').run [
#   '$rootScope'
#   ($rootScope) ->
#     # see what's going on when the route tries to change
#     $rootScope.$on '$stateChangeStart', (event, toState, toParams, fromState, fromParams) ->
#       console.log toState
#       console.log '$stateChangeStart to ' +  toState + '- fired when the transition begins. toState,toParams : \n' + toState + toParams
#       return
#     $rootScope.$on '$stateChangeError', (event, toState, toParams, fromState, fromParams, error) ->
#       console.log '$stateChangeError - fired when an error occurs during transition.'
#       console.log arguments
#       return
#     $rootScope.$on '$stateChangeSuccess', (event, toState, toParams, fromState, fromParams) ->
#       console.log '$stateChangeSuccess to ' + toState.name + '- fired once the state transition is complete.'
#       return
#     $rootScope.$on '$viewContentLoading', (event, viewConfig) ->
#       console.log '$viewContentLoading - view begins loading - dom not rendered', viewConfig
#       console.log viewConfig
#       console.log event
#       return
#     # $rootScope.$on('$viewContentLoaded',function(event){
#     #   // runs on individual scopes, so putting it in "run" doesn't work.
#     #   console.log('$viewContentLoaded - fired after dom rendered',event);
#     $rootScope.$on '$stateNotFound', (event, unfoundState, fromState, fromParams) ->
#       console.log '$stateNotFound ' + unfoundState.to + '  - fired when a state cannot be found by its name.'
#       console.log unfoundState, fromState, fromParams
#       return

# ]

angular.module('lessons').run(['$rootScope', '$state',
  ($rootScope, $state)->
    $rootScope.isAuthenticated = false

    $rootScope.$on('auth:validation-success', (e)->
      $rootScope.isAuthenticated = true
      
    )
    $rootScope.$on('auth:login-success', (e)->
      $rootScope.isAuthenticated = true
      # $state.go 'welcome'
    )

    $rootScope.$on('auth:validation-error', (e)->
      $rootScope.isAuthenticated = false
    )
    $rootScope.$on('auth:invalid', (e)->
      $rootScope.isAuthenticated = false
    )
    $rootScope.$on('auth:login-error', (e)->
      $rootScope.isAuthenticated = false
    )
    $rootScope.$on('auth:logout-success', (e)->
      $rootScope.isAuthenticated = false
    )
    $rootScope.$on('auth:account-destroy-success', (e)->
      $rootScope.isAuthenticated = false
    )
    $rootScope.$on('auth:session-expired', (e)->
      $rootScope.isAuthenticated = false
    )
])
