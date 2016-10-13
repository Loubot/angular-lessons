web: bundle exec unicorn -p $PORT -c ./config/unicorn.rb
worker: rake jobs:work
release: bundle exec rake db:migrate