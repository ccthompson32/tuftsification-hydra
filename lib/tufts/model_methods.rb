# COPIED From https://github.com/mkorcy/tdl_hydra_head/blob/master/lib/tufts/model_methods.rb
require 'chronic'
require 'titleize'
require 'tufts/metadata_methods'
# MISCNOTES:
# There will be no facet for RCR. There will be no way to reach RCR via browse.
# 3. There will be a facet for "collection guides", namely EAD, namely the landing page view we discussed on Friday.

module Tufts
  module ModelMethods

  include TuftsFileAssetsHelper
  include Tufts::IndexingMethods
  include Tufts::MetadataMethods

  end
end

