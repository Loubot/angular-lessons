module SearchHelper

  def search_query( params )
    if params.has_key?( :county_name ) && params.has_key?( :subject_name ) \
      && params[ :county_name ] != "" && params[ :subject_name ] != ""
      p "county_name and subject_name"
      
      teachers =  geo_return_teachers
      teachers.as_json( include: [ :photos, :location, :subjects ] )
    else
      p "Search helper params #{ params }"
      teachers = return_teachers
      # teachers = subject.teachers.where( is_teacher: true ).select( "email, id, first_name, last_name" ).uniq
      teachers.as_json(include: [ :photos, :location, :subjects ]).uniq
    end

  end

  private


  def return_teachers
    teachers = []
    subjects = Subject.includes( :teachers ).where( "NAME #{ ilike } ?", "%#{ params[ :subject_name ] }%").select( [ :name, :id ] )
      subjects.all.each do |s| 
        s.teachers.where( is_teacher: true ).includes( :photos, :location, :subjects ).all.each do |t|
          teachers << t
        end
      end
    
    teachers 
  end


  def geo_return_teachers
    teachers = []
    ids = Location.within( 50, origin: params[:county_name] ).select( [ 'teacher_id' ] ).map( &:teacher_id )
     subjects = Subject.where( "NAME #{ ilike } ?", "%#{ params[ :subject_name ] }%" ).select( [ :name, :id ] )
      subjects.all.each do |s| 
        s.teachers.where( is_teacher: true).includes( :photos, :location, :subjects ).where( id: ids ).all.each do |t|
          teachers << t
        end
      end
    teachers
  end

  def ilike
    if Rails.env.development?
      "LIKE"
    else
      "ILIKE"
    end
  end

end