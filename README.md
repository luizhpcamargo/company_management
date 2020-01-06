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

# How to use
 - `GET    /companies` - will bring all the companies

  ** params:

    `with_employees` - will bring the related employees json with the results

 - `POST   /companies` - will create a new company

   ** params:

     `name` - Razão social

     `company_name` - Nome fantasia

     `document` - CNPJ

 - `GET    /companies/:id` - will bring a specific company by id

 ** params:

   `with_employees` - will bring the related eomployess json

 - `PATCH/PUT /companies/:id` - will update the company

   ** params:

     the same from creation

     `name` - Razão social

     `company_name` - Nome fantasia

     `document` - CNPJ

 - `DELETE /companies/:id` - will delete the specific company

 - `GET /employees` - will bring all the employees

   ** params:

     `with_company` - will bring the related comoany also with the results

 - `POST /employees - will create a new employee`

   ** params:

     `name` - Nome

     `company_id` - Company id related to the new employee

     `birth` - Birthday from the employee

     `document` - CPF

 - `GET /employees/:id` - will bring the specific employee

   ** params:

     `with_company` - will bring the related company data

 - `PUT/PATCH /employees/:id` - will update the specific employee data

   ** params:

     the same from creation

     `name` - Nome

     `company_id` - Company id related to the new employee

     `birth` - Birthday from the employee

     `document` - CPF

 - `DELETE /employees/:id` - will delete the specific employee

TODO:
 - Include docker
 - Do more tests
 - Change the show method to decrease the n + 1 issue (like on the index action)
 - Produce presenters to a better readability
 - Include permissions and do a better control to the items removed
 - Increase the code security and the data access
