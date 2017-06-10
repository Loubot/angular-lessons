angular.module('lessons').service 'auth', [
  "$rootScope"
  "$auth"
  "User"
  "Alertify"
  "$state"
  "$window"
  "$mdSidenav"
  "$mdDialog"
  "$q"
  ( $rootScope, $auth, User, Alertify, $state, $window, $mdSidenav, $mdDialog, $q ) ->
    valid = false
    auth = {}
    auth.county_lists =
          { 'Antrim': { county: 'Co. Antrim', latitude: 54.719508, longitude: -6.207256 }, 'Armagh': { county: 'Co. Armagh', latitude: 54.350277, longitude: -6.652822},
          'Carlow': { county: 'Co. Carlow', latitude: 52.836497, longitude: -6.934238}, 'Cavan': { county: 'Co. Cavan', latitude: 53.989637, longitude: -7.363272 },
          'Clare': { county: 'Co. Clare', latitude: 52.847097, longitude: -8.989040 }, 'Cork': { county: 'Co. Cork', latitude: 51.897887, longitude: -8.475431},
          'Derry': { county: 'Co. Derry', latitude: 54.996669, longitude: -7.308567 }, 'Donegal': { county: 'Co. Donegal', latitude: 54.832874, longitude: -7.485811},
          'Down': { county: 'Co. Down', latitude: 54.328787, longitude: -5.715719 }, 'Dublin': { county: 'Co. Dublin', latitude: 53.346591, longitude: -6.265231 },
          'Fermanagh': { county: 'Co. Fermanagh', latitude: 54.343928, longitude: -7.631644 }, 'Galway': { county: 'Co. Galway', latitude: 53.270672, longitude: -9.056779 },
          'Kerry': { county: 'Co. Kerry', latitude: 52.059816, longitude: -9.504487 }, 'Kildare': { county: 'Co. Kildare', latitude: 53.220438, longitude: -6.659570 },
          'Kilkenny': { county: 'Co. Kilkenny', latitude: 52.653411, longitude: -7.248446 }, 'Laois': { county: 'Co. Laois', latitude: 53.032791, longitude: -7.300100 },
          'Leitrim': { county: 'Co. Leitrim', latitude: 53.945234, longitude: -8.086559 }, 'Limerick': { county: 'Co. Limerick', latitude: 52.664942, longitude: -8.628080 },
          'Longford': { county: 'Co. Longford', latitude: 53.727371, longitude: -7.793887}, 'Louth': { county: 'Co. Louth', latitude: 53.999672, longitude: -6.406295 },
          'Mayo': { county: 'Co. Mayo', latitude: 53.854566, longitude: -9.288492 }, 'Meath': { county: 'Co. Meath', latitude: 53.647000, longitude: -6.697336 },
          'Monaghan': { county: 'Co. Monaghan', latitude: 54.248650, longitude: -6.969560 }, 'Offaly': { county: 'Co. Offaly', latitude: 53.275140, longitude: -7.493240 },
          'Roscommon': { county: 'Co. Roscommon', latitude: 53.627545, longitude: -8.189194 }, 'Sligo': { county: 'Co. Sligo', latitude: 54.273910, longitude: -8.473718 }, 
          'Tipperary': { county: 'Co. Tipperary', latitude: 52.356254, longitude: -7.695380 }, 'Tyrone': { county: 'Co. Tyrone', latitude: 54.597003, longitude: -7.310752 },
          'Waterford': { county: 'Co. Waterford', latitude: 52.257693, longitude: -7.110284 }, 'Westmeath': { county: 'Co. Westmeath', latitude: 53.524646, longitude: -7.339487 },
          'Wexford': { county: 'Co. Wexford', latitude: 52.333583, longitude: -6.474672 }, 'Wicklow': { county: 'Co. Wicklow', latitude: 52.980215, longitude: -6.060273 } }

    auth.get_county = ( county ) ->
      console.log county
      return county_lists["#{ county }"]

    auth.auth_errors = ( resp ) ->
      console.log resp
      console.log resp.errors
      # console.log resp.errors.full_messages?
      if resp.errors? and resp.errors.full_messages?
        for mess in resp.errors.full_messages
          console.log mess
          Alertify.error mess
          return
      for mess in resp.errors
        console.log mess
        Alertify.error mess
      # if resp.data.errors.full_messages? and resp.data.errors.full_messages.length > 0
      #   for mess in resp.data.errors.full_messages
      #     Alertify.error mess

      #   throw 'There was an error'

    auth.login = ( teacher ) ->
      console.log "login"
      $auth.submitLogin( teacher )
        .then( (resp) ->
          # console.log resp
          new User().then( ( resp ) ->
            # console.log resp
            $rootScope.$emit 'auth:validation-success', [
              resp
            ]
            Alertify.success "Welcome back #{ $rootScope.User.first_name }"
            # $mdSidenav('left').close()
            $mdDialog.cancel()
          )
          
        )
        .catch( (resp) ->
          # Promise.reject "!"
          auth.auth_errors( resp )

        )   

    auth.register = ( teacher ) ->
      console.log teacher
      console.log teacher.county
      $auth.submitRegistration( teacher )
        .then( (resp) ->
          
          new User().then( ( resp ) ->
            console.log resp
            $rootScope.$emit 'auth:registered_user', [
              resp
            ]
            
            if $rootScope.User.is_teacher then $state.go( "teacher", id: $rootScope.User.id ) 
          )
          
        )
        .catch( ( resp ) ->
          auth.auth_errors( resp.data )
          Promise.reject resp
        )

    auth.logout = ->
      $auth.signOut()
        .then( ( resp ) ->
          console.log resp
          Alertify.success "Logged out successfully"
          $rootScope.User.stop_unread()
          $rootScope.User = null
          $state.go 'welcome'
          $window.location.reload()
        ).catch( ( err ) ->
          console.log err
          $rootScope.User = null
          Alertify.error "Failed to log out"
          $state.go 'welcome'
        )

    auth.check_basic_validation = ->

      $q ( resolve, reject ) ->
        $auth.validateUser().then( ( user ) ->

          new User().then( ( resp ) ->
            console.log "basic validation"
            resolve $rootScope.User
            $rootScope.isPageFullyLoaded = true
          ).catch( ( err ) ->
            # $rootScope.$broadcast( "auth:invalid", [ 'nope', 'no way' ] )
            $rootScope.isPageFullyLoaded = true
          )
        ).catch( ( validate_err ) ->
          # console.log 'Validate error'
          # $rootScope.$broadcast( "auth:invalid", [ 'nope', 'no way' ] )
          $rootScope.isPageFullyLoaded = true
          resolve "I'll allow it"
        )

    auth.check_if_logged_in = ->
      $q ( resolve, reject ) ->
        $auth.validateUser().then( ( user ) ->
          
          if !$rootScope.User?
            new User().then( ( resp ) ->
              resolve $rootScope.User
              $rootScope.isPageFullyLoaded = true
            ).catch( ( err ) ->
              reject status: 401, error: 'non_user'
              $rootScope.isPageFullyLoaded = true
            )
          else
            resolve $rootScope.User
        ).catch( ( validate_err ) ->
          console.log 'Right here'
          console.log validate_err
          $rootScope.isPageFullyLoaded = true
          reject validate_err
        )

    auth.check_if_logged_in_and_teacher = ->
      $q ( resolve, reject ) ->
        $auth.validateUser().then( ( user ) ->
          $rootScope.isPageFullyLoaded = true
          if !$rootScope.User?
            new User().then( ( resp ) ->
              if !user.is_teacher
                reject status: 401, error: "non_teacher"
              else
                resolve $rootScope.User
            ) 
          else if !$rootScope.User.is_teacher
            reject status: 401, error: "non_teacher"
          else
            resolve $rootScope.User         
        ).catch( ( validate_err ) ->
          reject validate_err
          $rootScope.isPageFullyLoaded = true
        )

    auth.check_if_logged_in_and_admin = ->
      $q ( resolve, reject ) ->
        $auth.validateUser().then( ( user ) ->

          if !$rootScope.User?
            new User().then( ( resp ) ->
              if !user.admin
                reject status: 401, error: 'non_admin'
              else
                console.log 'resolve'
                resolve user
            )
          else if !$rootScope.User.admin
            reject status: 401, error: 'non_admin'
          else
            resolve $rootScope.User
          
        ).catch( ( validate_err ) ->
          console.log "Maybe here"
          console.log validate_err
          reject validate_err
        )
        
    do -> 

      # set listener for validation error
      $rootScope.$on "auth:invalid" , ( e, v ) ->
        console.log "validation error"
        # Alertify.error 'auth:validation-error'
        # console.log $state.current.name
        $rootScope.User = null
        $rootScope.isPageFullyLoaded = true

      # set listener for validation success
      # $rootScope.$on 'auth:validation-success', ( e, v ) ->
        # console.log 'validation success'

        # if !$rootScope.User? && $rootScope.user.first_name?
        #   new User().then( ( res ) ->
        #     $rootScope.$emit( "a-user-is-logged-in", $rootScope.User )
        #     $rootScope.isPageFullyLoaded = true
        #   ) 
        

    auth
]



################# End of auth ################################################




angular.module('lessons').factory 'User', [
  "COMMS"
  "RESOURCES"
  "$http"
  "$rootScope"
  "$q"
  "$state"
  "Alertify"
  "Upload"
  '$mdBottomSheet'
  "$interval"
 ( COMMS, RESOURCES, $http, $rootScope, $q, $state, Alertify, Upload, $mdBottomSheet, $interval ) ->
  # instantiate our initial object
  stop = undefined # variable required to cancel message checking
  $rootScope.only_once = false

  check_unread = ->
    # console.log 'calling unread'
    $http(
      method: 'GET'
      headers: { "Content-Type": "application/json" }
      url: "/api/teacher/#{ $rootScope.User.id }/check-unread"
      ignoreLoadingBar: true
    ).then( ( res ) -> 
      # console.log res
      $rootScope.User.unread = res.data.teacher.unread
      $rootScope.$broadcast "new:message", res.data.teacher if res.data.teacher.unread == true
    )

  User = ( cb ) ->
    self = this
    console.log "new user being called"
    $q ( resolve, reject ) ->
      $http.get("/api/teacher/#{ $rootScope.user.id }").then( (response) ->
        stop = $interval( check_unread, 600000 )
        user = self.update_all( response.data.teacher )
        resolve user
      ).catch( ( err ) ->
        console.log "failed to get teacher"
        console.log err
        reject err
        $rootScope.User = null
      )
        
        # response

  # define the getProfile method which will fetch data
  # from GH API and *returns* a promise

  User::update_all = ( teacher ) ->
    @admin = teacher.admin


    @first_name = teacher.first_name
    @last_name = teacher.last_name
    @email = teacher.email
    @id = teacher.id
    @is_teacher = teacher.is_teacher
    @travel = teacher.travel
    @garda = teacher.garda
    @tci = teacher.tci
    @phone = teacher.phone
    @overview = teacher.overview
    @profile = teacher.profile
    @experience = teacher.experience
    @view_count = teacher.view_count
    @location = teacher.location
    @photos = teacher.photos
    @qualifications = teacher.qualifications
    @subjects = teacher.subjects
    @profile_url = @.get_profile()
    @primary = teacher.primary
    @jc = teacher.jc
    @lc = teacher.lc
    @third_level = teacher.third_level
    @.unread = teacher.unread
    $rootScope.User = @
    

  User::get_full_name = ->
    if @.first_name? and @.last_name?
      return "#{ @.first_name } #{ @.last_name }"
    else if @.first_name? and !@.last_name?
      return "#{ @.first_name }"
    else if !@first_name? and @.last_name
      return "#{ @.last_name }"
    else
      return null

  User::update = ->
    COMMS.POST(
      "/teacher"
      @
    ).then( ( resp ) ->
      Alertify.success "User updated "
      console.log resp
      $mdBottomSheet.hide()
    ).catch( ( err ) ->
      console.log "Failed to update user class"
    )

  User::update_quietly =  ->
    $http(
      method: 'POST'
      headers: { "Content-Type": "application/json" }
      url: "/api/teacher/"
      data: @
      { ignoreLoadingBar: true }
    ).then( ( res ) -> 
      console.log res
      $rootScope.User.unread = res.data.teacher.unread
      $rootScope.$broadcast "new:message", res.data.teacher if res.data.teacher.unread == true
    )

###################### pics ###################################################
  User::upload_pic = ( pic ) ->
    if pic?
      self= @
      Upload.upload(
        url: "#{ RESOURCES.DOMAIN }/teacher/#{ $rootScope.User.id }/photos"
        # file: pic
        # avatar: pic
        data:
          avatar: pic
      ).then( ( resp ) -> 
        console.log resp
        self.photos = resp.data.photos
        Alertify.success("Photo uploaded ok")
        $rootScope.User.profile = resp.data.teacher.profile
        
        self.get_profile()
        Alertify.success "Profile pic set"

        pic = null
      ).catch( ( err ) ->
        console.log err
      )

  User::update_profile = ( pic_id ) ->
    self = @
    console.log pic_id
    self.profile = pic_id
    COMMS.PUT(
      "/teacher/#{ self.id }"
      profile: pic_id, id: $rootScope.User.id
    ).then( ( resp ) ->
      console.log resp
      self.get_profile()
    ).catch( ( err ) ->
      console.log err 
    )

  User::delete_pic = ( id ) ->
    self = @
    COMMS.DELETE(
      "/teacher/#{ self.id }/photos/#{ id }"
    ).then( ( resp ) ->
      console.log 'deleted photo'
      console.log resp
      self.photos = resp.data.teacher.photos
      self.profile = resp.data.teacher.profile
      Alertify.success "Deleted photo ok"
      self.get_profile()
    ).catch( ( err ) ->
      console.log err
      Alertify.error "Failed to delete photo"
    )

  User::get_profile = ->
    for photo in @.photos
      # console.log photo.avatar.url
      if parseInt( photo.id ) == parseInt( @.profile )
        @.profile_url = photo.avatar.url
        # console.log @.profile_url
    @.profile_url
#################### end of pics ###############################################

#################### Location ##################################################

  User::create_location = ( location ) ->
    self = @
    COMMS.POST(
      "/teacher/#{ self.id }/location"
      location
    ).then( ( resp ) ->
      console.log resp
      self.location = resp.data.location
      # if $rootScope.User.is_teacher then $state.go( "teacher", id: $rootScope.User.id ) else $state.go( 'student_profile', id: $rootScope.User.id )
    ).catch( ( err ) ->
      console.log err
      Alertify.success "Failed to create location"
    )

  User::update_address = ( location ) ->
    console.log location
    self = @
    COMMS.PUT(
      "/teacher/#{ self.id }/location/#{ location.id }"
      location
    ).then( ( resp ) ->
      console.log resp
      self.location = resp.data.location
    ).catch( ( err ) ->
      console.log err
      Alertify.error "Failed to update location"
    )

  User::format_address = ( google_address ) ->

    return address =
      teacher_id: "#{$rootScope.User.id}"
      longitude:  google_address.geometry.location.lng()
      latitude:   google_address.geometry.location.lat()
      name:       "#{ $rootScope.User.first_name } address"
      address:    google_address.formatted_address
      county:     google_address.county

  User::delete_location = ->
    self = @
    COMMS.DELETE(
      "/teacher/#{ self.id }/location/#{ self.location.id }"
    ).then( ( resp ) ->
      console.log resp
      Alertify.success "Deleted location successfully"
      self.location = resp.data.location
    ).catch( ( err ) ->
      console.log err
      Alertify.error "Failed to delete location"
    )

#################### ENd of address ###########################################

####################Subjects ###################################################

  User::pick_subject = ( subject ) ->
    self = @
    COMMS.POST(
      "/teacher/#{ self.id }/add-subject"
      subject: subject
    ).then( ( resp ) ->
      console.log resp
      Alertify.success "Successfully added subject"
      self.subjects = resp.data.subjects
      Alertify.success "Your profile is now visible to students" if $rootScope.User.subjects.length > 0
      $('#subject_select').val ""
    ).catch( ( err ) ->
      console.log err
      Alertify.error err.data.error if err.data.error?
    )

  User::remove_subject = ( subject ) ->
    self = @
    COMMS.DELETE(
      "/teacher/#{ self.id }/remove-subject"
      subject: subject
    ).then( ( resp ) ->
      console.log resp
      Alertify.success "Successfully removed subject"
      self.subjects = resp.data.subjects
      $rootScope.$emit "no_subject_alert", [ 'no subjects' ] if resp.data.subjects.length == 0
    ).catch( ( err ) ->
      console.log err
      Alertify.error err.data.error
    )
####################End of subjects ############################################

####################Qualifications #############################################

  User::create_qualification = ( qualification ) ->
    self = @
    COMMS.POST(
      "/teacher/#{ self.id }/qualification"
      qualification
    ).then( ( resp ) ->
      console.log resp
      self.qualifications = resp.data.qualifications
      Alertify.success "Created qualification"
      $mdBottomSheet.hide()
    ).catch( ( err ) ->
      console.log err
      Alertify.error err.errors.full_messages
    )

  User::delete_qualification = ( qualification ) ->
    self = @
    COMMS.DELETE(
      "/teacher/#{ self.id }/qualification/#{ qualification.id }"
    ).then( ( resp ) ->
      console.log resp
      self.qualifications = resp.data.qualifications
      Alertify.success "Deleted qualification"
    ).catch( ( err ) ->
      console.log err
      Alertify.error "Failed to delete qualification"
    )
  
###################End of qualfications ########################################


###################Experiences##################################################

  User::add_experience = ( experience ) ->
    self = @
    COMMS.POST(
      "/teacher/#{ self.id }/experience"
      self.experience
    ).then( ( resp ) ->
      console.log resp
      self.experience = resp.data.experience
      Alertify.success "Experience added"

    ).catch( ( err ) ->
      console.log err
      Alertify.error "Failed to add experience"
    )

###################End of experiences###########################################

  User::change_user_type = ( type ) ->
    self = this
    self.is_teacher = type
    COMMS.POST(
      "/teacher"
      self
    ).then( ( resp ) ->
      console.log "User class updated "
      console.log resp
      $rootScope.User = self
      if $rootScope.User.is_teacher then $state.go( "teacher", id: $rootScope.User.id ) else $state.go( 'student_profile', id: $rootScope.User.id )
    ).catch( ( err ) ->
      console.log "Failed to update user class"
    )

  User::get_location = ->
    self = this
    return self.location

  User::set_location = ( location ) ->
    self = this
    return self.location = location

  User::get_photos = ->
    
    return @.photos

  User::set_photos = ( photos ) ->
    self = this
    self.photos = photos
    return self

  User::get_subjects = ->
    self = this
    return self.subjects

  User::set_subjects = ( subjects ) ->
    self = this
    return self.subjects = subjects

  User::stop_unread = ->
    $interval.cancel( stop )
    stop = undefined


  User

]