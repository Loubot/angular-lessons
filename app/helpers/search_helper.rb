module SearchHelper

  def search_query( params )
    if params.has_key?( :county_name ) && params.has_key?( :subject_name ) \
      && params[ :county_name ] != "" && params[ :subject_name ] != ""
      p "county_name and subject_name"
      ids = Location.within( 50, origin: params[:county_name] ).select( [ 'teacher_id' ] ).map( &:teacher_id )
      teachers =  Subject.where( name: params[ :subject_name ] )\
                  .first.teachers.where( is_teacher: true).includes( :photos, :location, :subjects )\
                  .where( id: ids )
      teachers.as_json( include: [ :photos, :location, :subjects ] )
    else
      p "Search helper params #{ params }"
      subject = Subject.includes(:teachers).where('name LIKE ?', "%#{ params[:subject_name] }%").select( [ :name, :id ] ).first
      teachers = subject.teachers.where( is_teacher: true ).select( "email, id, first_name, last_name" )
      teachers.as_json(include: [ :photos, :location, :subjects ])
    end

  end

end