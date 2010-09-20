# Pour que to_formatted_s prenne en compte les formats localisés
module ConversionsWithI18n
	def self.included(base)
		base.instance_eval do
			# to_formatted_s
			# devient :
			# to_formatted_s_without_i18n
			# et :
			# to_formatted_s_with_i18n
			# devient :
			# to_formatted_s
#			alias_method_chain :to_formatted_s, :i18n
			alias_method_chain :to_s, :i18n

#			alias_method :to_s, :to_formatted_s
		end
	end

#	def to_formatted_s_with_i18n(format = :default)
	def to_s_with_i18n(format = :default)
		_format = I18n.t("date.formats.#{format}")
		puts "DEBUG JBA : #{self.class.name} : format=[#{_format}]"
		I18n.l( self, :format => I18n.t("time.formats.#{format}") ).gsub!(' ', '&nbsp;')
	end
end

