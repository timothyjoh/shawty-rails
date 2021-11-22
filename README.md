# Shawty - delicious URL shortener

Live at: http://shawty.wtf

## API Documentation

The following API methods are available for creating short URLs from long ones.

The brief synopsis is the following:
1. To create a short URL, use the `POST` method and send it the URL you want shortened.
2. To update the short slug for an existing URL, use the `PUT` method with the
`mutation_key` you received in response to the `POST` request above.
3. To delete the short link, use the `DELETE` method with the supplied `mutation_key`

There is Swagger documentation available here: http://shawty.wtf/api-docs

----
`POST /api/v1/links`

Headers
```
Content-Type: application/json
Accept: application/json
```

Body
```json
{
  "url": "https://thisiswherethelongurlgoes.com",
  "slug": "longurl"
}
```
Note: The `slug` in the body is optional. If it does not exist or is blank,
the application will automatically generate a slug for you. You will be able
to change your slug later using the `PUT` method below.

You will receive the following JSON response:
```json
{
  "url":"https://swagger.io/blog",
  "mutation_key":"boy-md52ftlozqiz45c7",
  "shorty":"http://shawty.wtf/boy",
  "editable":"http://shawty.wtf/edit/boy-md52ftlozqiz45c7",
  "message":"Link successfully created."
}
```
* The `url` is the same as the one sent
* The `mutation_key` is used as a secret key you can use in the future to update the slug, or delete the link.
Since there is no authentication on the site, this is a secure way that the creator can make changes, but no one
else can
* The `shorty` is the short url. Visit this link to be redirected to the longer destination URL. This is what you are here for anyways.
* The `editable` is a URL to a webform (coming in the future) where you could edit the slug if so desired
* The `message` is a status message from the server

----

`PUT /api/v1/links/{mutation_key}`

Use this to change the `slug` and the short URL. I opted not to allow changing the `url` in this method,
it is just easy enough to create a new link (but it could be easily added).

Headers
```
Content-Type: application/json
Accept: application/json
```

Body
```json
{
  "slug": "anewslug"
}
```

The JSON response is the same as the `POST` method above, but with the new shorty and `mutation_key`:
```json
{
  "url":"https://swagger.io/blog",
  "mutation_key":"anewslug-md52ftlozqiz45c7",
  "shorty":"http://shawty.wtf/anewslug",
  "editable":"http://shawty.wtf/edit/anewslug-md52ftlozqiz45c7",
  "message":"Link successfully updated."
}
```

----

`DELETE /api/v1/links/{mutation_key}`

Use this to delete the short URL from the database

Headers
```
Content-Type: application/json
Accept: application/json
```

Body (empty)

The JSON response is a simple message:
```json
{
  "message":"Link successfully deleted."
}
```

----
## Development

Like any Ruby on Rails application, to run this locally requires a few steps.

1. Install Ruby 3.0.2 (I use ASDF here: http://asdf-vm.com/guide/getting-started.html#_1-install-dependencies)
2. Install the gem "bundler": `gem install bundler`
3. Clone this repository: `git clone git@github.com:timothyjoh/shawty-rails.git`
4. In the root of this repo, run `bundle install`, this will install all the dependencies

### Run the server

Run the Rails application locally with
```
bin/rake db:migrate
bin/rails server
```

### Testing and Linting

Testing is done with RSpec, you can run this locally with `guard`
```
bundle exec guard
```
Linting is done with `rubocop`, which will check the formatting on the files
```
rubocop
```

### Updating the Swagger documentation

To update the Swagger documentation, run:
```
bin/rake rswag
```
Swagger docs are built into the [swagger.yml](/swagger/v1/swagger.yaml) file

----

## Deep Thoughts by the author

The following are my thoughts when designing this system.

1. I wanted to create a quick, authentication-free link shortener. This
is why I chose to do the route of having a secret or nonce code in the
database that would allow future editing. Craigslist used to do this,
and the user would have to keep track of the secret editing URL (it would
also be emailed to them) in order to make changes. It's not terribly secure,
but I feel that it will do the job. The application returns the `mutation_key`
which is future access to the web form or API to retrieve their URL for editing
or deletion.
2. I opted to limit the API to just the 3 methods. I did not feel the need to
add a `GET` method, either to list a bunch of short links, nor the individual
link. It seemed unnecessary, since in most cases you are just there for the
short URL and then you are done.
3. I was not used to the `rswag` gem, so that was a new one for me. Struggled
with it a good bit at first and decided I wanted to keep that auto-documentation
in the `link_spec` separate from my actual tests (which I had written first).
I need to dive more into how they work in unison, seems pretty great what it
can do and keep things in one place.
4. Extra-credit: I wanted to take this to the next level and add a Web UI to
allow creation, mutation, and deletion of these links. I plan for the Web UI to
use the APIs directly. I have not yet used webpacker with React in a Rails app,
I am used to keeping them in separate repos, but I am curious to explore that.
I might also opt for a lighter framework like Svelte (which I love playing with),
or just use some minimal vanilla JS to be ultra-lightweight.

----

## Web UI -- Coming Soon

The following are my notes/plans for the upcoming visual pages for Shawty

Web Home
  Input for URL and slug
    Redirects to Editable page shawty.wtf/edit/{slug}

Editable Page
  Link to Short URL shawty.wtf/{slug}
  Input for changing slug (no spaces or special chars, all lowercase)
  Input for secret key (prepopulated)
    Will redirect to new Editable Page
  Explanation of Secret Key
  Form for deleting this short URL

Catch-all
  Redirect to Long URL if found
  Render 404 if not found

404 Page for non-existant slugs
  Contains a half-height header OOPS
  includes the homepage form below (extract to partial)



Input the URL
Optional slug
Post to the server
  - server creates short slug `Faker::Alphanumeric.alphanumeric(number: 10)`
  - server returns short url (with short slug)
  - also returns secret key for updating /expiring `Faker::Alphanumeric.alphanumeric(number: 10)`
    - combination of slug + nonce `"#{slug}-#{secret}"`

Mutation PUT
  - can change the slug
  - must include existing secret key (slug+nonce)
  - returns new secret key
  - returns new short url

Mutation DELETE
  - must include the secret key
  - responds 200 OK


