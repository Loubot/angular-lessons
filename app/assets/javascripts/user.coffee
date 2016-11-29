angular.module('lessons').service 'auth', [
  "$rootScope"
  "$auth"
  "User"
  "alertify"
  "$state"
  "$window"
  ( $rootScope, $auth, User, alertify, $state, $window ) ->
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
      for mess in resp.errors
        console.log mess
        alertify.error mess
      # if resp.data.errors.full_messages? and resp.data.errors.full_messages.length > 0
      #   for mess in resp.data.errors.full_messages
      #     alertify.error mess

      #   throw 'There was an error'

    auth.login = ( teacher ) ->
      $auth.submitLogin( teacher )
        .then( (resp) ->

          new User().then( ( resp ) ->
            console.log resp
            # $rootScope.$emit 'auth:logged-in-user', [
            #   resp
            # ]
            auth.set_is_valid( true )
          )


          
          
        )
        .catch( (resp) ->
          auth.auth_errors( resp )

        )   

    auth.register = ( teacher ) ->

      console.log teacher.county
      $auth.submitRegistration( teacher )
        .then( (resp) ->
          
          new User().then( ( resp ) ->
            console.log resp
            # $rootScope.$emit 'auth:registered_user', [
            #   resp
            # ]
            auth.set_is_valid( true )
          )
          
        )
        .catch( ( resp ) ->
          auth_errors( resp )
          
        )
    auth.logout = ->
      $auth.signOut()
        .then( ( resp ) ->
          console.log resp
          alertify.success "Logged out successfully"
          $rootScope.User = null
          $state.go 'welcome'
          $window.location.reload()
        ).catch( ( err ) ->
          console.log err
          $rootScope.User = null
          alertify.error "Failed to log out"
          $state.go 'welcome'
        )

    auth.set_is_valid = ( story ) ->
      valid = story

    auth.check_is_valid = ->
      if !valid 
        $state.go 'welcome'
        alertify.error "You are not authorised!"
      return valid


     do -> 

      
      # set listener for validation error
      $rootScope.$on "auth:validation-error" , ( e, v ) ->
        console.log "validation error"
        auth.set_is_valid( false )

      # set listener for validation success
      $rootScope.$on 'auth:validation-success', ( e, v ) ->
        console.log 'validation success'
        # console.log e
        # console.log v
        if !$rootScope.User? && $rootScope.user.first_name?
          console.log "Doing it"
          new User().then( ( res ) ->
            console.log 'end of do'
            console.log $rootScope.User
            auth.set_is_valid( true)
          )


      # Run validateUser and catch any errors. 
      $auth.validateUser().catch (err) ->
        $rootScope.$broadcast 'auth:validation-error', [
          err
          
        ]
        console.log "Validation failed"
        

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
  "alertify"
  "Upload"
  '$mdBottomSheet'
 ( COMMS, RESOURCES, $http, $rootScope, $q, $state, alertify, Upload, $mdBottomSheet ) ->
  # instantiate our initial object

  

  User = ( cb ) ->
    self = this
    $q ( resolve, reject ) ->
      $http.get("/api/teacher/#{ $rootScope.user.id }").then( (response) ->
        
        user = self.update_all( response.data.teacher )
        resolve user
      ).catch( ( err ) ->
        console.log "failed to get teacher"
        console.log err
        $rootScope.User = null
      )
        
        # response

  # define the getProfile method which will fetch data
  # from GH API and *returns* a promise

  User::update_all = ( teacher ) ->
    @first_name = teacher.first_name
    @last_name = teacher.last_name
    @email = teacher.email
    @id = teacher.id
    @is_teacher = teacher.is_teacher
    @overview = teacher.overview
    @profile = teacher.profile
    @experience = teacher.experience
    @view_count = teacher.view_count
    @location = teacher.location
    @photos = teacher.photos
    @qualifications = teacher.qualifications
    @subjects = teacher.subjects
    @profile_url = @.get_profile()
    $rootScope.User = @
    

  User::get_full_name = ->
    
    return @.first_name + ' ' + @.last_name

  User::update = ->
    COMMS.POST(
      "/teacher"
      @
    ).then( ( resp ) ->
      alertify.success "User updated "
      console.log resp
      $mdBottomSheet.hide()
    ).catch( ( err ) ->
      console.log "Failed to update user class"
    )

###################### pics ###################################################
  User::upload_pic = ( pic ) ->
    self= @
    Upload.upload(
      url: "#{ RESOURCES.DOMAIN }/teacher/#{ $rootScope.User.id }/photos"
      file: pic
      avatar: pic
      data:
        avatar: pic
    ).then( ( resp ) -> 
      console.log resp
      self.photos = resp.data.photos
      alertify.success("Photo uploaded ok")
      
      
      self.get_profile()
      alertify.success "Profile pic set"

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
      alertify.success "Deleted photo ok"
      self.get_profile()
    ).catch( ( err ) ->
      console.log err
      alertify.error "Failed to delete photo"
    )

  User::get_profile = ->
    for photo in @.photos
      # console.log photo.avatar.url
      if parseInt( photo.id ) == parseInt( @.profile )
        @.profile_url = photo.avatar.url
        console.log @.profile_url
    @.profile_url
#################### end of pics ###############################################

#################### Address ##################################################

  User::as_is = ->
    self = @
    COMMS.POST(
      "/teacher/#{ self.id }/location"
      self.location
    ).then( ( resp ) ->
      console.log resp
      self.location = resp.data.location
      alertify.success "Updated location"
    ).catch( ( err ) ->
      alertify.error "Failed to update location"
    )

  User::update_address = ( address ) ->
    console.log "Update address"
    self = this
    COMMS.POST(
      "/teacher/#{ self.id }/manual-address"
      self.address
    ).then( ( resp) ->
      alertify.success "Updated location"
      console.log resp
      $mdBottomSheet.hide()

      self.location = resp.data.location
    ).catch( ( err) ->
      console.log err
      alertify.error "Failed to update location"
    )

  User::manual_address = ( address ) ->
    self = @
    COMMS.POST(
      "/teacher/#{ self.id }/location"
      self.format_address( address )
    )

  User::registration_address = ( address ) ->
    self = @
    COMMS.POST(
      "/teacher/#{ self.id }/location"
      address 
    ).then( ( resp ) ->
      console.log "create location"
      self.location = resp.data.location
    ).catch( ( err ) ->
      console.log err
      alertify.error "Failed to create location"
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
      alertify.success "Deleted location successfully"
      self.location = resp.data.location
    ).catch( ( err ) ->
      console.log err
      alertify.error "Failed to delete location"
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
      alertify.success "Successfully added subject"
      self.subjects = resp.data.subjects
      alertify.success "Your profile is now visible to students" if $rootScope.User.subjects.length > 0
    ).catch( ( err ) ->
      console.log err
      alertify.error err.data.error if err.data.error?
      $scope.subjects = err.data.subjects
    )

  User::remove_subject = ( subject ) ->
    self = @
    COMMS.DELETE(
      "/teacher/#{ self.id }/remove-subject"
      subject: subject
    ).then( ( resp ) ->
      console.log resp
      alertify.success "Successfully removed subject"
      self.subjects = resp.data.subjects
    ).catch( ( err ) ->
      console.log err
      alertify.error err.data.error
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
      alertify.success "Created qualification"
      $mdBottomSheet.hide()
    ).catch( ( err ) ->
      console.log err
      alertify.error err.errors.full_messages
    )

  User::delete_qualification = ( qualification ) ->
    self = @
    COMMS.DELETE(
      "/teacher/#{ self.id }/qualification/#{ qualification.id }"
    ).then( ( resp ) ->
      console.log resp
      self.qualifications = resp.data.qualifications
      alertify.success "Deleted qualification"
    ).catch( ( err ) ->
      console.log err
      alertify.error "Failed to delete qualification"
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
      alertify.success "Experience added"

    ).catch( ( err ) ->
      console.log err
      alertify.error "Failed to add experience"
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

    

  

  User

]