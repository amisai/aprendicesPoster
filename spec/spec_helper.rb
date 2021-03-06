require 'simplecov'
SimpleCov.start

require 'dotenv'
Dotenv.load

require_relative '../lib/client/twitter_client'
require_relative '../lib/client/aprendices_client'
require_relative '../lib/client/karmacracy_client'
require_relative '../lib/job/aprendices_scrapper'
require_relative '../lib/job/aprendices_sharer'
require_relative '../lib/job/rss_generator'
