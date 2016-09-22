module SearchHelper

  def search_query( params )
    if params.has_key?( :county_name ) && params.has_key?( :subject_name ) \
      && params[ :county_name ] != "" && params[ :subject_name ] != ""
      p "county_name and subject_name"
      ids = Location.within( 50, origin: params[:county_name] ).select( [ 'teacher_id' ] ).map( &:teacher_id )
      teachers =  Subject.where( name: params[ :subject_name ] )\
                  .first.teachers.includes( :photos, :location, :subjects )\
                  .where( id: ids )
      teachers.as_json( include: [ :photos, :location, :subjects ] )
    else
      p "Searhc helper params #{ params }"
      subject = Subject.includes(:teachers).where('name LIKE ?', "%#{ params[:subject_name] }%").select( [ :name, :id ] ).first
      teachers = subject.teachers.select( "email, id, first_name, last_name" )
      teachers.as_json(include: [ :photos, :location, :subjects ])
    end

  end

end


#Location.within(5, :origin => @somewhere)
#Location.geo_scope(:origin => '100 Spear st, San Francisco, CA')
#ids = Location.within( 5, :origin => "cork" ).select(['teacher_id']).map(&:teacher_id)
#Subject.where(name: 'Guitar').first.teachers.includes(:qualifications).where(id: ids)

# http://angular-lessons.herokuapp.com/#/