# Company management

This is a application to do a minimal company/employees management.

* Ruby version: `2.5.3`
* Rails version: `5.1.7`

# Configuration
 - `git clone git@github.com:luizhpcamargo/company_management.git`
 - `cd company_management`
 - `bundle install`

# Database creation and initialization
 - `rake db:create db:migrate`

# How to run the test suite
 - `rspec spec`

TODO:
 - Include docker
 - Do more tests
 - Change the show method to decrease the n + 1 issue (like on the index action)
 - Produce presenters to a better readability
