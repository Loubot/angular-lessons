module SearchHelper

  def search_query( params )
    p "Searhc helper params #{ params }"
    subject = Subject.includes(:teachers).where('name LIKE ?', "%#{ params[:name] }%").select( [ :name, :id ] ).first
    teachers = subject.teachers.select( "email, id, first_name, last_name" )
    teachers.as_json(include: [ :photos, :location, :subjects ])
  end

end


#Location.within(5, :origin => @somewhere)
#Location.geo_scope(:origin => '100 Spear st, San Francisco, CA')