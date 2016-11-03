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
      teachers = []
      if Rails.env.development?
        # subject = Subject.includes(:teachers).where('name LIKE ?', "%#{ params[:subject_name] }%").select( [ :name, :id ] ).first
        subjects = Subject.includes( :teachers ).where( "NAME LIKE ?", "%#{ params[ :subject_name ] }%").select( [ :name, :id ] )
        subjects.all.each do |s| 
          s.teachers.all.each do |t|
            teachers << t
          end
        end
      else
        subjects = Subject.includes( :teachers ).where( "NAME ILIKE ?", "%#{ params[ :subject_name ] }%").select( [ :name, :id ] )
        subjects.all.each do |s| 
          s.teachers.all.each do |t|
            teachers << t
          end
        end
      end
      # teachers = subject.teachers.where( is_teacher: true ).select( "email, id, first_name, last_name" ).uniq
      teachers.as_json(include: [ :photos, :location, :subjects ]).uniq
    end

  end

end