# Shawty - delicious URL shortener

Input the URL
Optional slug
Post to the server
  - server creates short slug
  - server returns short url (with short slug)
  - also returns secret key for updating /expiring
    - combination of slug + nonce

Mutation PUT
  - can change the slug
  - must include existing secret key (slug+nonce)
  - returns new secret key
  - returns new short url

Mutation DELETE
  - must include the secret key
  - responds 200 OK


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
