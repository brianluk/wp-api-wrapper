# WpApiWrapper

To start your Phoenix app:

  * Install elixir with your favorite package manager
  * Install dependencies with `mix deps.get`
  * Install Node.js dependencies with `npm install`
  * Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000/graphiql`](http://localhost:4000/graphiql) from your browser. You can now interactively query the Relay compatible GraphQL API

## Models

Though the models are based on standard Wordpress tables, the fields may be specific to plugins or other custom fields created for my particular wordpress instance

Some outstanding issues that need to be addressed:

  * Move the table prefix to a configuration variable
  * Remove any custom/plugin fields from base models and dynamically add from a user configuration

## Schema

Still testing and developing the schema to normalize the terms and taxonomy tables. Also need to separate posts from revisions and attachments in the post table

## Sample Query

Below shows a query example to grab the latest 10 posts with Title and Author

```
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
