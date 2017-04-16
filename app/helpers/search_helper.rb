module SearchHelper

  def search_query( params )
    if params.has_key?( :county_name ) && params.has_key?( :subject_name ) \
      && params[ :county_name ] != "" && params[ :subject_name ] != ""
      p "county_name and subject_name 1111111111111111"
      
      teachers =  geo_return_teachers
      teachers.as_json( include: [ :photos, :location, :subjects ] ).uniq

    elsif params.has_key?( :county_name ) && params[ :county_name ] != ""

      p "county_name only 2222222222222222"
      ids = run_geo_locate()
      teachers = Teacher.includes( :photos, :location, :subjects ).find( ids )
      teachers.as_json( include: [ :photos, :location, :subjects ] ).uniq

    elsif params.has_key?( :subject_name ) && params[ :subject_name ] != ""

      p "subject_name only 3333333333333333333"
      teachers = return_teachers
      teachers.as_json( include: [ :photos, :location, :subjects ] ).uniq

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
      s.teachers.where( is_teacher: true ).includes( :photos, :location, :subjects ).limit( ENV['TEACHER_LIMIT'] ).offset( params[ :offset ] ).all.each do |t|
        teachers << t
      end
    end
    
    teachers 
  end


  def geo_return_teachers
    p "Geo return teachers *******************************"
    teachers = []
    ids = run_geo_locate()
     subjects = Subject.where( "NAME #{ ilike } ?", "%#{ params[ :subject_name ] }%" ).select( [ :name, :id ] )
      subjects.all.each do |s| 
        s.teachers.where( is_teacher: true).includes( :photos, :location, :subjects ).limit( ENV[ 'TEACHER_LIMIT' ] ).offset( params[ :offset ] ).where( id: ids ).all.each do |t|
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

  def run_geo_locate
    p "Running geo locate Distance: 20"
    Location.within( 10, origin: params[ :county_name ] ).select( [ 'teacher_id' ] ).map( &:teacher_id )
  end

end