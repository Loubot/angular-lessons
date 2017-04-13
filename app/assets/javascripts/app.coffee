'use strict'

angular.module('lessons', [
  'Alertify'
  'ui.bootstrap' 
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

angular.module('lessons').service 'counties', [ ->
  county_list:  ->
    return [
      'Co. Antrim','Co. Armagh','Co. Carlow','Co. Cavan','Co. Clare','Co. Cork','Co. Derry','Co. Donegal','Co. Down','Co. Dublin',
      'Co. Fermanagh','Co. Galway','Co. Kerry','Co. Kildare','Co. Kilkenny','Co. Laois','Co. Leitrim','Co. Limerick','Co. Longford',
      'Co. Louth','Co. Mayo','Co. Meath','Co. Monaghan','Co. Offaly','Co. Roscommon','Co. Sligo','Co. Tipperary','Co. Tyrone',
      'Co. Waterford','Co. Westmeath','Co. Wexford','Co. Wicklow'
    ]
]
    

angular.module('lessons').run ( $rootScope ) ->
  $rootScope.isPageFullyLoaded = false
  angular.element(document).ready ->
    $rootScope.angular_is_ready = true
    # $('.main_page').removeClass( 'invisible' )
    InstantClick.init();

angular.module('lessons').config ( $authProvider ) ->
  $authProvider.configure({
    apiUrl: '/api'
    passwordResetPath:       '/auth/password'
    passwordUpdatePath:      '/auth/password'
    authProviderPaths: 
      facebook: '/auth/facebook'
    validateOnPageLoad: false
      
  })

angular.module('lessons').factory 'is_mobile', [
  () ->
    return /iPhone|iPad|iPod|Android/i.test(navigator.userAgent)
]
  
    
angular.module('lessons').factory 'change_tags', [
  () ->
    set_title: ( new_title ) ->
      $('title').replaceWith """<title> #{ new_title } </title>"""
      return true

    set_description: ( new_description ) ->
      $('meta[name=description]').attr('content', new_description)
      return true
]

angular.module('lessons').service 'OG', ->
  set_tags: ( url, title, type, image, description ) ->
    $('.added_og').remove()
    if url?
      $('head').append """ <meta property="og:title" content="#{ url }" class="added_og"/>"""
    if title?
      $('head').append """ <meta property="og:title" content="#{ title }" class="added_og"/>"""
    if type?
      $('head').append """ <meta property="og:title" content="#{ type }" class="added_og"/>"""
    # if image?

    # if description?

    
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

angular.module('lessons').run [
  '$rootScope'
  "$state"
  "Alertify"
  ( $rootScope, $state, Alertify ) ->
    $rootScope.$on '$stateChangeError', (event, toState, toParams, fromState, fromParams, error) ->
      console.log error
      if error.status = 401 and error.error = 'non_admin'
        $rootScope.User = null
        $state.go "welcome"
        Alertify.error "Please login again."
        $rootScope.isPageFullyLoaded = true
      else if error.status ==  401 and  error.error == "non_teacher"
        $state.go "welcome"
        Alertify.error "You are not Authorised"
        $rootScope.User = null
        $rootScope.isPageFullyLoaded = true
      return 


]

angular.module('lessons').filter 'start_from', ->
  (data, start) ->
    return false if !data? or !start? 
    data.slice start


angular.module('lessons').config [
  "$stateProvider"
  "$urlRouterProvider"
  "$locationProvider"
 ($stateProvider, $urlRouterProvider, $locationProvider ) ->
 
  $locationProvider.html5Mode(true)
  
  # $stateProvider.state 'home',
  #   url: '/'
  #   templateUrl: "static/welcome.html"
  #   controller: "WelcomeController"
  #   resolve:
  #     authenticate: [
  #       "$auth"
  #       "$rootScope"
  #       ( $auth, $rootScope ) ->
  #         $auth.validateUser()
  #     ]

  
  $stateProvider.state 'welcome',
    url: '/welcome'
    templateUrl: "static/welcome.html"
    controller: "WelcomeController"
    resolve:
      authenticate: [
        "auth"
        ( auth ) ->
          auth.check_basic_validation()
      ]

  $stateProvider.state 'search',
    url: '/search/:name/:location'
    templateUrl: "static/search.html"
    controller: "SearchController"
    resolve:
      authenticate: [
        "auth"
        ( auth ) ->
          auth.check_basic_validation()
      ]

  $stateProvider.state 'view_teacher',
    url: '/view-teacher/:id'
    templateUrl: "user/view_teacher.html"
    controller: "ViewTeacherController"
    resolve:
      authenticate: [
        "auth"
        ( auth ) ->
          auth.check_basic_validation()
      ]

  $stateProvider.state 'register_teacher',
    url: "/register-teacher"
    templateUrl: "static/register_teacher.html"
    controller: "RegisterController"
    resolve:
      authenticate: [
        "auth"
        ( auth ) ->
          auth.check_basic_validation()
      ]
  
  # $stateProvider.state 'student_register',
  #   url: "/register-student"
  #   templateUrl: "static/register_student.html"
  #   controller: "RegisterController"
  

  $stateProvider.state 'how_it_works',
    url: '/how-it-works'
    templateUrl: 'static/how_it_works.html'
    controller: "UserController"
    resolve:
      authenticate: [
        "auth"
        ( auth ) ->
          auth.check_basic_validation()
      ]

  $stateProvider.state 'contact',
    url: '/contact'
    templateUrl: 'static/contact.html'
    controller: "ContactController"
    resolve:
      authenticate: [
        "auth"
        ( auth ) ->
          auth.check_basic_validation()
      ]

  $stateProvider.state 'about',
    url: '/about'
    templateUrl: 'static/about.html'
    controller: "ContactController"
    resolve:
      authenticate: [
        "auth"
        ( auth ) ->
          auth.check_basic_validation()
      ]

  $stateProvider.state "pl",
    url: "api/auth/password/edit"
    templateUrl: "password/reset_password.html"
    controller: "PasswordController"
    resolve:
      authenticate: [
        "auth"
        ( auth ) ->
          auth.check_basic_validation()
      ]

  $stateProvider.state "change_password",
    url: "/change-password"
    templateUrl: "password/change_password.html"
    controller: "PasswordController"
    resolve:
      authenticate: [
        "auth"
        ( auth ) ->
          auth.check_basic_validation()
      ]

  $stateProvider.state 'reset_password',
    url: '/reset-password/'
    templateUrl: 'password/reset_password.html'
    controller: "PasswordController"
    resolve:
      authenticate: [
        "auth"
        ( auth ) ->
          auth.check_basic_validation()
      ]

  $stateProvider.state 'conversation',
    url: "/conversation/:id"
    templateUrl: "conversation/messages.html"
    controller: "ConversationController"
    resolve:
      authenticate: [
        "auth"
        ( auth ) ->
          auth.check_if_logged_in()
      ]



  $stateProvider.state 'teacher',
    url: '/teacher/:id'
    templateUrl: "user/teacher.html"
    controller: "TeacherController"
    resolve:
      authenticate: [
        "auth"
        ( auth ) ->
          auth.check_if_logged_in_and_teacher()
      ]

  $stateProvider.state 'teacher_area',
    url: "/teacher-area/:id/:student_email"
    templateUrl: "user/teacher_area.html"
    controller: "TeacherAreaController"
    resolve:
      authenticate: [
        "auth"
        ( auth ) ->
          auth.check_if_logged_in_and_teacher()
      ]

  $stateProvider.state 'teacher_location',
    url: '/teacher-location/:id'
    templateUrl: "user/teacher_location.html"
    controller: "TeacherLocationController"
    resolve:
      authenticate: [
        "auth"
        ( auth ) ->
          auth.check_if_logged_in_and_teacher()
      ]

  $stateProvider.state 'admin',
    url: "/admin"
    templateUrl: "admin/manage.html"
    controller: "AdminController"
    resolve:
      admin: [
        "auth"
        ( auth ) ->
          auth.check_if_logged_in_and_admin()
      ]

  $stateProvider.state 'student_profile',
    url: '/student/:id'
    templateUrl: "user/student.html"
    controller: "StudentController"
    resolve:
      authenticate: [
        "auth"
        ( auth ) ->
          auth.check_if_logged_in()
      ]

  $urlRouterProvider.otherwise "/welcome"
  
]  


############## Theme #######################################
angular.module('lessons').config ( $mdThemingProvider ) ->
  $mdThemingProvider.theme('default')
    .primaryPalette('green')
    .accentPalette('blue-grey')




angular.module('lessons').service 'AUTH', ( $http, $rootScope, RESOURCES, $q, $auth, Alertify ) ->

  signin: ( auth_hash ) ->
    $q ( resolve, reject ) ->
      $auth.submitLogin( auth_hash )
        .then( (resp) ->
          # handle success response
          # console.log resp
          Alertify.success "Logged in successfully"
          resolve resp
        )
        .catch( (resp) ->
          console.log resp
          Alertify.error resp.data.errors.full_messages
          $rootScope.USER = null
          reject resp
        )

  signup: ( auth_hash ) ->
    $q ( resolve, reject ) ->
      $auth.submitRegistration( auth_hash )
        .then( (resp) ->
          # handle success response
          console.log resp
          Alertify.success "Registered successfully"
          window.localStorage.setItem 'user_email', resp.data.email
          $rootScope.USER = resp.data
          resolve resp
        )
        .catch( (resp) ->
          console.log resp
          Alertify.error resp.data.errors.full_messages
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
          resolve result
        ).catch( ( err_result ) ->
          reject err_result
        )

    PATCH: ( url, data ) ->
      $q ( resolve, reject ) ->
        $http(
          method: 'PATCH'
          url: "#{ RESOURCES.DOMAIN }#{ url }"
          headers: { "Content-Type": "application/json" }
          data: data
        ).then( ( result ) ->
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


angular.module('lessons').directive 'jsonld', [
  '$filter'
  '$sce'
  ($filter, $sce) ->
    {
      restrict: 'E'
      template: ->
        '<script type="application/ld+json" ng-bind-html="onGetJson()"></script>'
      scope: json: '=json'
      link: (scope, element, attrs) ->

        scope.onGetJson = ->
          $sce.trustAsHtml $filter('json')(scope.json)

        return
      replace: true
    }
]

# ---
# generated by js2coffee 2.2.0
# 360 519