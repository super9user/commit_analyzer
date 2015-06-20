class CommitData
  include Mongoid::Document
  
  field :json, type: Hash
  field :branches, type: Array, default: []

end
