module UsersHelper
	def titre(gender)
		case gender
		when 1
			"Mr."
		when 2
			"Mme."
		else
			""
		end
	end
end