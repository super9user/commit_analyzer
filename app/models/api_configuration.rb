class ApiConfiguration
	include Mongoid::Document
	include Mongoid::Timestamps

	field :client_id, type: String
	field :client_secret, type: String

	validates :client_secret, :client_id, presence: true
	validate :confirm_singularity

	def confirm_singularity
		errors[:base] << "There can be only one." if self.new_record? && ApiConfiguration.count > 0
	end

end
