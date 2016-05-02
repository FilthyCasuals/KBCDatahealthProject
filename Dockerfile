FROM quay.io/keboola/base-ruby
COPY . /home/
ENTRYPOINT ruby /home/main.rb
