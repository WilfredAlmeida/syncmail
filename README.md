# SyncMail: AI Email Generator built using Syncloop

SyncMail is an AI email generator that generates email based on subject and keywords provided by the user. It uses Google Palm API to generate the emails. SyncMail adds specifically engineered prompts to the user input to generate the emails.

SyncMail's backend APIs are built using [SyncLoop](https://syncloop.com) and it uses Planetscale MySQL as a primary database and Vercel KV Redis database for caching.

## Demo

### The app has the following features
- User Signup and Login
- Viewing email prompts
- Generating emails
- Viewing all generated emails

Tech Used:
- Mobile: Flutter
- Backend: Syncloop
- Database: Planetscale MySQL
- Caching: Vercel Redis KV

### System Architecture
![syncmail drawio](https://github.com/WilfredAlmeida/syncmail/assets/60785452/7cf2e3b4-f324-4a76-a3bf-28f1fd476e81)


### Database Schema
![SyncMail](https://github.com/WilfredAlmeida/syncmail/assets/60785452/a59d89b0-8301-4f4e-8a1f-2b9078b05438)


## Syncloop Services and APIs
The package is named as `chaturmail` in Syncloop dashboard. Here's the exported package [1693724579810.zip](https://github.com/WilfredAlmeida/syncmail/files/12505337/1693724579810.zip)


**Adapters**
- `/chaturMail/adapter/connection/mydb`: Connection to the MySQL database
- `/chaturMail/adapter/createUser`: SQL query for creating user while signup. Input: `{name: string, email: string}`. Output: `{userId: int}`
- `/chaturMail/adapter/fetchEmails`: SQL query for fetching all user generated emails. Input: `{userId: int}`. Output: `{emails: [emails]}`, refer `emails` table in db schema for structure.
- `/chaturMail/adapter/fetchPrompts`: SQL query for fetching all available prompts. Input: None. Output: `{prompts: [prompts]}`, refer `prompts` table in db schema for structure.
- `/chaturMail/adapter/insertGeneratedEmails`: SQL query to insert generated emails into database. Input: `{userId: int, keywords: string, result: string, subject: string}`. Output: None
- `/chaturMail/adapter/loginUser`: SQL query to check if users exists. Used for login if user with given email exists. Input: `{email: string}`. Output: `{id: int, name: string}`

**APIs**
- `POST`: `/chaturMail/email/generateEmail`: Generate email using given subject and prompts. Input: `{keywords: string, promptId: int, subject: string}, {headers.userIdHeaderString: string}`. Output: `{generatedEmail: string}`
- `GET`: `/chaturMail/email/getEmails`: Get all emails generated by user. Input: `{userId: int}`, Output: `{emails: [emails]}`, refer `emails` table.
- `GET`: `/chaturMail/prompts/getCachedPrompts`: Get prompts cached in the Redis DB. This aims to offload the primary database and provide faster response times. Input: None, Output: `{prompts: [prompts]}`, refer `prompts` table.
- `GET`: `/chaturMail/prompts/getPrompts`: Get all prompts from database. Input: None, Output: `{prompts: [prompts]}`, refer `prompts` table.
- `POST`: `/chaturMail/user/createUser`: Create a user. Used for signup. Input: `{email: text, name: text}`, Output: None
- `POST`: `/chaturMail/user/login`: Login user if user exists. Input: `{email: string}`, Output: `{name: string, id: int}`

**Java Services**
- `/chaturMail/utils/StringCleaner`: The generated email text has unwanted special characters due to the structure of the prompts. This Java service sanitizes an input string and removes such unwanted characters. Input: `{inputString: string}`, Output: `{outputString: string}`
- `/chaturMail/utils/stringToInt`: Converts input string to int. Flutter-Dart doesn't allow int values in request headers, this service parses the numeric string from the headers and converts it into int. Input: `{userIdHeaderString: string}`, Output: `{userIdInt: int}`


**Middlewares Used**
- `/middleware/pub/client/http/request`: To make HTTP request to Google Palm and Vercel DB APIs.

### API Screenshots

<details>  
  <summary> API Screenshots</summary>  

  
1. Generate Email `/chaturMail/email/generateEmail`  
   <img width="760" alt="image" src="https://github.com/WilfredAlmeida/syncmail/assets/60785452/cb51283d-7899-4dc7-ae8b-08cc376436b2">  
2. Get generated emails `/chaturMail/email/getEmails`  
   <img width="776" alt="image" src="https://github.com/WilfredAlmeida/syncmail/assets/60785452/d2b90293-6352-42dc-85d7-e5b7d05b5de9">  
3. Get cached prompts from Redis `/chaturMail/prompts/getCachedPrompts`  
   <img width="750" alt="image" src="https://github.com/WilfredAlmeida/syncmail/assets/60785452/f44f81b9-e1f6-4841-91b1-7f9287ec97b5">  
4. Get all prompts `/chaturMail/prompts/getPrompts`  
   <img width="761" alt="image" src="https://github.com/WilfredAlmeida/syncmail/assets/60785452/1295312f-6576-48d0-8b6d-30d711834ab1">  
5. Create user while signup `/chaturMail/user/createUser`  
   <img width="753" alt="image" src="https://github.com/WilfredAlmeida/syncmail/assets/60785452/5c2603fa-43e0-4325-9066-96ee901e2fad">  
6. Login user `/chaturMail/user/login`  
   <img width="759" alt="image" src="https://github.com/WilfredAlmeida/syncmail/assets/60785452/0ead78f7-47d1-4334-abdc-79dc9075b6f7">  


</details>
