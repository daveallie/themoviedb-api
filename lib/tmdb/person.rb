module Tmdb
  class Person < Struct

    def self.detail(id, filters={})
      result = Resource.new("/person/#{id}", filters).get
      self.new(result)
    end

    def self.movie_credits(id, filters={})
      result = Resource.new("/person/#{id}/movie_credits", filters).get
      self.new(result)
    end

    def self.tv_credits(id, filters={})
      result = Resource.new("/person/#{id}/tv_credits", filters).get
      self.new(result)
    end

    def self.combined_credits(id, filters={})
      result = Resource.new("/person/#{id}/combined_credits", filters).get
      self.new(result)
    end

    def self.external_ids(id, filters={})
      result = Resource.new("/person/#{id}/external_ids", filters).get
      self.new(result)
    end

    def self.images(id, filters={})
      result = Resource.new("/person/#{id}/images", filters).get
      Image.new(result)
    end

    def self.tagged_images(id, filters={})
      result = Resource.new("/person/#{id}/images", filters).get
      Image.new(result)
    end

    def self.changes(id, filters={})
      result = Resource.new("/person/#{id}/changes", filters).get
      Changes.new(result)
    end

    def self.popular(filters={})
      result = Resource.new('/person/popular', filters).get
      person = self.new(result)

      person.convert_known_for!

      person
    end

    def self.latest(filters={})
      result = Resource.new('/person/latest', filters).get
      self.new(result)
    end

    def convert_known_for!
      results.each do |result|
        result.known_for.map! do |multi|
          known_person_reference(multi)
        end
      end
    end

    private

    def known_person_reference(obj)
      case obj.media_type
        when 'movie'
          Movie.new(obj.to_h)
        when 'tv'
          TV.new(obj.to_h)
        else
          Multi.new(obj.to_h)
      end
    end

  end
end
