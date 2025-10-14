import { type ClientSchema, a, defineData } from "@aws-amplify/backend";

/*== STEP 1 ===============================================================
The section below creates a Todo database table with a "content" field. Try
adding a new "isDone" field as a boolean. The authorization rule below
specifies that any user authenticated via an API key can "create", "read",
"update", and "delete" any "Todo" records.
=========================================================================*/
const schema = a.schema({
  Todo: a
    .model({
      content: a.string(),
      isDone: a.boolean().required()
    })
    .authorization(allow => [allow.publicApiKey()]),

    // WPPost: a.customType({
    //   id: a.integer(),
    //   date: a.date(),
    //   date_gmt: a.datetime(),
    //   title: a.string(),
    //   content: a.string()
    // }),
  //   Post: a.customType({
  //   title: a.string(),
  //   content: a.string(),
  //   author: a.string().required(),
  // }),
  
  Page: a.customType({
    id: a.integer(),
    date: a.string(),
    date_gmt: a.string(),
    title: a.string(),
    content: a.string()
  }),
  
  getPage: a
    .query()
    .arguments({ id: a.id().required() })
    .returns(a.ref("Page"))
    .authorization(allow => [allow.publicApiKey()])
    .handler(
      a.handler.custom({
        dataSource: "BeadFormations",
        entry: "./getPage.js",
      })
    ),


    // /*========
    //   Queries
    // =========*/
    // listPages: a.query()
    // .returns(a.ref("Page").array())
    // .authorization(allow => [allow.publicApiKey()]) // keep same auth for now
    // .handler(
    // a.handler.custom({
    //   dataSource: "BeadFormations",
    //   entry: "./listPages.ts", // point to your new handler file
    // })
    // ),


    /*=======
     Mutations
    =========*/

});

export type Schema = ClientSchema<typeof schema>;

// export const data = defineData({
//   schema,
//   authorizationModes: {
//     defaultAuthorizationMode: 'userPool'
//   }
// });
export const data = defineData({
  schema,
  authorizationModes: {
    // 👇 make API key the default or add as additional mode
    defaultAuthorizationMode: 'apiKey',
    apiKeyAuthorizationMode: {
      // optional — set key expiration (in days)
      expiresInDays: 365,
      description: 'Public API key for read-only WP endpoints',
    },
  },
});

/*== STEP 2 ===============================================================
Go to your frontend source code. From your client-side code, generate a
Data client to make CRUDL requests to your table. (THIS SNIPPET WILL ONLY
WORK IN THE FRONTEND CODE FILE.)

Using JavaScript or Next.js React Server Components, Middleware, Server 
Actions or Pages Router? Review how to generate Data clients for those use
cases: https://docs.amplify.aws/gen2/build-a-backend/data/connect-to-API/
=========================================================================*/

/*
"use client"
import { generateClient } from "aws-amplify/data";
import type { Schema } from "@/amplify/data/resource";

const client = generateClient<Schema>() // use this Data client for CRUDL requests
*/

/*== STEP 3 ===============================================================
Fetch records from the database and use them in your frontend component.
(THIS SNIPPET WILL ONLY WORK IN THE FRONTEND CODE FILE.)
=========================================================================*/

/* For example, in a React component, you can use this snippet in your
  function's RETURN statement */
// const { data: todos } = await client.models.Todo.list()

// return <ul>{todos.map(todo => <li key={todo.id}>{todo.content}</li>)}</ul>
