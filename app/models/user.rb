class User
	include Mongoid::Document
	include Mongoid::Timestamps

	field :first_name, type: String
	field :last_name, type: String
	field :time_zone, type: String, default: "Pacific Time (US & Canada)"
	field :role, type: String

	field :is_active, type: Boolean,default: false # Soft delete

	has_many :phone_numbers, autosave: true
	has_many :email_addresses, autosave: true

	validates :first_name, :last_name, :time_zone, :role, :is_active, presence: true
	validate :has_email?

	def has_email?
		if(email_addresses.nil? || email_addresses.size==0)
			errors[:base] << "Minimum of 1 Email is Required"
		end
	end

end