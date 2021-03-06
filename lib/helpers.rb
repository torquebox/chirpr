module Chirpr
  module Helpers

    def format_time(t)
      t.strftime("%B %d, %Y, at %l:%M%p")
    end

    def screen_name
      return nil unless session[:user]
      session[:user]["screen_name"]
    end

    def current_user
      session[:user]
    end

    def icon_for(profile)
      return "" if profile.icon_url.nil?
      "<img src='#{profile.icon_url}' alt='#{profile.name}'/>"
    end

    def configured?
      ENV['oauth_key'] && ENV['oauth_secret']
    end

    def partial(template, *args)
      options = args.last.is_a?(Hash) ? args.pop : { }
      options.merge!(:layout => false)

      path = template.to_s.split(File::SEPARATOR)
      object = path[-1].to_sym
      path[-1] = "_#{path[-1]}"
      template = File.join(path).to_sym

      if collection = options.delete(:collection) 
        collection.inject([]) do |buffer, member|
          buffer << haml( template, options.merge( :locals => {object => member} ) )
        end 
      else
        haml(template, options)
      end
    end

  end

  helpers Helpers
end

