class CommitMeta
	include Mongoid::Document

	#uniqueness factors  
	field :created_at_date,type: Date # per day
	field :email, type: String

	field :day, type: Integer
	field :year, type: Integer
	field :month, type: Integer
	field :week, type: Integer
	field :cwday, type: Integer
	field :timestamp, type: Integer

	field :commits, type: Integer,default: 0

	field :hourly_commits,type: Hash,default: {0 => 0,1 => 0,2 => 0,3 => 0,4 => 0,5 => 0,6 => 0,7 => 0,8 => 0,9 => 0,10 => 0,11 => 0,12 => 0,13 => 0,14 => 0,15 => 0,16 => 0,17 => 0,18 => 0,19 => 0,20 => 0,21 => 0,22 => 0,23 => 0}

	before_create :init_object

	def init_object
		date = self.created_at_date
		self.day = date.day
		self.year = date.year
		self.month = date.month
		self.week = date.cweek
		self.cwday = date.cwday
		self.timestamp = (self.created_at_date.to_time.to_f*1000).to_i
		return true
	end

	def get_report(group_by="daily")
		hash = {}
		if(group_by=="daily")
			hash[self.timestamp] = {commits: self.commits}
		else
			hash = {(self.timestamp) => {commits: self["hourly_commits.0"]},  (self.timestamp)+(3600000*1) => {commits: self["hourly_commits.1"]},  (self.timestamp)+(3600000*2) => {commits: self["hourly_commits.2"]},  (self.timestamp)+(3600000*3) => {commits: self["hourly_commits.3"]},  (self.timestamp)+(3600000*4) => {commits: self["hourly_commits.4"]},  (self.timestamp)+(3600000*5) => {commits: self["hourly_commits.5"]},  (self.timestamp)+(3600000*6) => {commits: self["hourly_commits.6"]},  (self.timestamp)+(3600000*7) => {commits: self["hourly_commits.7"]},  (self.timestamp)+(3600000*8) => {commits: self["hourly_commits.8"]},  (self.timestamp)+(3600000*9) => {commits: self["hourly_commits.9"]},  (self.timestamp)+(3600000*10) => {commits: self["hourly_commits.10"]},  (self.timestamp)+(3600000*11) => {commits: self["hourly_commits.11"]},  (self.timestamp)+(3600000*12) => {commits: self["hourly_commits.12"]},  (self.timestamp)+(3600000*13) => {commits: self["hourly_commits.13"]},  (self.timestamp)+(3600000*14) => {commits: self["hourly_commits.14"]},  (self.timestamp)+(3600000*15) => {commits: self["hourly_commits.15"]},  (self.timestamp)+(3600000*16) => {commits: self["hourly_commits.16"]},  (self.timestamp)+(3600000*17) => {commits: self["hourly_commits.17"]},  (self.timestamp)+(3600000*18) => {commits: self["hourly_commits.18"]},  (self.timestamp)+(3600000*19) => {commits: self["hourly_commits.19"]},  (self.timestamp)+(3600000*20) => {commits: self["hourly_commits.20"]},  (self.timestamp)+(3600000*21) => {commits: self["hourly_commits.21"]},  (self.timestamp)+(3600000*22) => {commits: self["hourly_commits.22"]},  (self.timestamp)+(3600000*23) => {commits: self["hourly_commits.23"]}} 
		end
		hash
	end

end
