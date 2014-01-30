# -*- coding: utf-8 -*-

# Méthode possible ici ?
def init_translations_ennder
	if Rails::VERSION::MAJOR < 3
		#JBA 2011-03-29, sera caduque avec Rails 3 ?
		#pour que to_s prenne en compte les formats localisés
		#  Date.send :include, ConversionsWithI18nToS
		#  Time.send :include, ConversionsWithI18nToS
		ActiveSupport::TimeWithZone.send :include, ConversionsWithI18nToS
		ActionView::Helpers::FormHelper.send :include, ConversionsWithI18nLabel

		#Ajout des fichiers de traductions communs
		I18n.load_path.unshift File.expand_path(File.join(File.dirname(__FILE__), 'locales_rails2', 'en.yml'))
		I18n.load_path.unshift File.expand_path(File.join(File.dirname(__FILE__), 'locales_rails2', 'fr.yml'))
	else
		#Ajout des fichiers de traductions communs
		I18n.load_path.unshift File.expand_path(File.join(File.dirname(__FILE__), 'locales', 'en.yml'))
		I18n.load_path.unshift File.expand_path(File.join(File.dirname(__FILE__), 'locales', 'fr.yml'))
	end
end


if Rails::VERSION::MAJOR < 3 then
	#Rails 2

	Rails.configuration.after_initialize do
		_info = "GEM translations_ennder V#{TranslationsEnnder.version}, translations_ennder/rails.rb, Railx V2.x.y"

		puts "Rails.configuration.after_initialize, RAILS_ROOT=[#{RAILS_ROOT}], RAILS_ENV=#{RAILS_ENV}"
		if RAILS_DEFAULT_LOGGER.nil?
			_logger = Logger.new( File.join(RAILS_ROOT, "log", "#{RAILS_ENV}.log") )
		else
			_logger = RAILS_DEFAULT_LOGGER
		end
		_logger.info _info

		init_translations_ennder
	end
else
	#Rails 3

	# Rails n'est pas encore initalisé dans ce cas
	puts "GEM translations_ennder V#{TranslationsEnnder.version}, translations_ennder/rails.rb, Railx V3.x.y"

	init_translations_ennder
end


module ActionController
	class Base
		# Instance methods here

		def set_locale
			#Il faut une session
			if session[:session_id].blank?
				return
			end

			_param_locale = params[:locale]
			if (!_param_locale.blank?) and _param_locale.match /^(en|fr)$/
				#Vient du paramètre de requête
				I18n.locale = _param_locale
			elsif session[:locale].blank? and (! request.env['HTTP_ACCEPT_LANGUAGE'].blank?)
				#Vient des entêtes de la requête
				_http_lang_tab = request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/)
				if (! _http_lang_tab.empty?) and (! _http_lang_tab.first.blank? )
					if _http_lang_tab.first.match /^(en|fr)$/
						I18n.locale = _http_lang_tab.first
					else
						set_locale_session_or_fr
					end
				else
					set_locale_session_or_fr
				end
			else
				set_locale_session_or_fr
			end

#			logger.debug "GEM translations_ennder, locale=[#{session[:locale]}]"

			if session[:locale] != I18n.locale
				logger.debug "GEM translations_ennder, set_locale [#{session[:locale]}]=>[#{I18n.locale}]"
				session[:locale] = I18n.locale
			end
		end

		def set_locale_session_or_fr
			#Vient de la session, ou pas fourni
			I18n.locale = session[:locale] || :fr
		end
	end
end

