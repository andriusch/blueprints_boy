# frozen_string_literal: true

%w[4.2 5.0 5.1].each do |version|
  appraise "ar#{version}" do
    gem 'activerecord', "~> #{version}.0"
    gem 'database_cleaner-active_record'
    gem 'pg', '~> 0.18'
  end
end

%w[6.0 6.1].each do |version|
  appraise "ar#{version}" do
    gem 'activerecord', "~> #{version}.0"
    gem 'database_cleaner-active_record'
    gem 'pg'
  end
end

%w[5 6 7].each do |version|
  appraise "mongoid#{version}" do
    gem 'bson_ext'
    gem 'database_cleaner-mongoid'
    gem 'mongoid', "~> #{version}.0"
  end
end

appraise 'noorm' do
end
