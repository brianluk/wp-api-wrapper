# WpApiWrapper

To start your Phoenix app:

  * Install elixir with your favorite package manager
  * Install dependencies with `mix deps.get`
  * Install Node.js dependencies with `npm install`
  * Edit the dev.exs or the appropriate env config to point to the mysql db
  * Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000/graphiql`](http://localhost:4000/graphiql) from your browser. You can now interactively query the Relay compatible GraphQL API

## Models

Though the models are based on standard Wordpress tables, the fields may be specific to plugins or other custom fields created for my particular wordpress instance

## Schema

Still testing and developing the schema to normalize the terms and taxonomy tables. Also need to separate posts from revisions and attachments in the post table

## Sample Query

Below shows a query example to grab the latest 10 posts with Title and Author

```graphql
query {
  index {
    latestPosts(first: 10) {
      pageInfo {
        hasNextPage
        hasPreviousPage
      }
      edges {
        node {
          postTitle
          postAuthor {
            displayName
          }
        }
      }
    }
  }
}
```
## In progress

* Abstract out the table prefix (mining_)
* Abstract out specific plugin/custom edits like bitly meta data
* Posts content should be pulled from latest revision
* Incorporating filters to ignore or include posts

## To do for production

* Add authorization module

## Clean up

* Standardize query formation. Currently a mix of pipe vs sql
* Implement :time scalar for post date
