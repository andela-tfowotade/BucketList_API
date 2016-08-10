<h1>iBucket API</h1>
<hr />
[![Build Status](https://travis-ci.org/andela-tfowotade/BucketList_API.svg?branch=ch-add-badges-127970379)](https://travis-ci.org/andela-tfowotade/BucketList_API) [![Code Climate](https://codeclimate.com/repos/57aa511d33e29c197f001ff0/badges/0fc2357b66db1e0366fc/gpa.svg)](https://codeclimate.com/repos/57aa511d33e29c197f001ff0/feed) [![Coverage Status](https://coveralls.io/repos/github/andela-tfowotade/BucketList_API/badge.svg?branch=develop)](https://coveralls.io/github/andela-tfowotade/BucketList_API?branch=develop)

<h3>Overview</h3>

iBucket is an API that lets you manage a bucket list. A bucket list is simply a number of experiences or achievements that a person hopes to have or accomplish during their lifetime.



<h3>Getting Started</h3>

Visit the iBucket <a href="https://ibucket.herokuapp.com/">API Documentation</a>. It is clearly written and easy to understand and use.
  


<h3>External Dependencies</h3>

All the dependencies can be found in the <a href="https://github.com/andela-tfowotade/BucketList_API/blob/develop/Gemfile">Gemfile.</a>



<h3>Available End Points</h3>
Below is the list of available endpoints in the BucketList API. Some end points are not available publicly and hence, can only be accessed when you sign up and log in.

<table>
<tr>
  <th>End Point</th>
  <th>Functionality</th>
  <th>Public Access</th>
</tr>

<tr>
  <td>GET /api/v1/</td>
  <td>Welcome user</td>
  <td>TRUE</td>
</tr>

<tr>
  <td>POST /api/v1/auth/create_user</td>
  <td>Create a new user</td>
  <td>TRUE</td>
</tr>

<tr>
  <td>POST /api/v1/auth/login</td>
  <td>Logs a user in</td>
  <td>TRUE</td>
</tr>

<tr>
  <td>DELETE /api/v1/auth/logout</td>
  <td>Logs a user out</td>
  <td>FALSE</td>
</tr>

<tr>
  <td>GET /api/v1/bucketlists</td>
  <td>List all the created bucket lists</td>
  <td>FALSE</td>
</tr>

<tr>
  <td>POST /api/v1/bucketlists</td>
  <td>Create a new bucket list</td>
  <td>FALSE</td>
</tr>

<tr>
  <td>GET /bucketlists/:id</td>
  <td>Get single bucket list</td>
  <td>FALSE</td>
</tr>

<tr>
  <td>PUT /bucketlists/:id</td>
  <td>Update this bucket list</td>
  <td>FALSE</td>
</tr>

<tr>
  <td>DELETE /bucketlists/:id</td>
  <td>Delete this single bucket list</td>
  <td>FALSE</td>
</tr>

<tr>
  <td>GET /bucketlists/:id/items</td>
  <td>Lists all items in the single bucket list.</td>
  <td>FALSE</td>
</tr>

<tr>
  <td>POST /bucketlists/:id/items</td>
  <td>Creates a new item in the bucket list</td>
  <td>FALSE</td>
</tr>

<tr>
  <td>PUT /bucketlists/:id/items/:item_id</td>
  <td>Updates a bucket list item</td>
  <td>FALSE</td>
</tr>

<tr>
  <td>DELETE /bucketlists/:id/items/:item_id</td>
  <td>Deletes an item in a bucket list</td>
  <td>FALSE</td>
</tr>
</table>



<h3>JSON Data Model</h3>
A typical bucket list requested by a user would look like this:
<pre>
  {
    id: 1,
    name: “New Year Goals”,
    items: [
           {
               id: 1,
               name: “I to do this before the end of this year”,
               done: false
             }
           ]
    created_by: “John”
}
</pre>



<h3> Pagination </h3>
The BucketList API comes with pagination by default, so the number of results to display to users can be specified when listing the bucket lists, by supplying the <code>page</code> and <code>limit</code> in the request to the API. 

<h4>Example</h4>
<b>Request:</b>
<pre>
GET https://ibucket.herokuapp.com/api/v1/bucketlists?page=2&limit=20
</pre>

<b>Response:</b>
<pre>
20 bucket list records belonging to the logged in user starting from the 21st gets returned. 
</pre>



<b>Searching by Name</b>
Users can search for a bucket list by using it's name as the search parameter when making a <code>GET</code> request to list the bucketlists.

<h4>Example</h4>

<b>Request:</b>
 <pre>
  GET https://ibucket.herokuapp.com/api/v1/bucketlists?q="bucket1"
 </pre>

<b>Response:</b>
<pre>
Bucket lists that include name “bucket1” gets returned
</pre>



<h3> Versions</h3>
iBucket API currently has only one version and can be accessed via this link - <a href="https://ibucket.herokuapp.com/api/v1/">https://ibucket.herokuapp.com/api/v1/</a>



<h3>Running Test</h3>
The Bucket List API uses `rspec` for testing. Continuous Integration is carried out via Travis CI. 

To test locally, go through the following steps.

1. Clone the repo to your local machine.

  ```bash
  $  git clone git@github.com:andela-tfowotade/BucketList_API.git
  ```

2. `cd` into the `BucketList_API` folder.

  ```bash
  $  cd BucketList_API
  ```

3. Install dependencies

  ```bash
    $  bundle install
  ```

4. Set up and migrate the database.

  ```bash
  $ rake db:setup && rake db:migrate
  ```

5. Run the tests.

  ```bash
  $  bundle exec rspec
  ``` 


<h3>Limitations</h3>
The API might not be able to handle large requests but this will be reviewed as users increase.