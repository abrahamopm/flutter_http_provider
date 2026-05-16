# User Management App - Provider + HTTP

A Flutter application that performs full CRUD (Create, Read, Update, Delete) operations on user data using the **ReqRes API**. Built with **Provider** state management and **http** package for networking.


## Tech Stack

- **Flutter** - UI Framework
- **Provider** (^6.1.0) - State Management
- **http** (^1.1.0) - Network Requests
- **ReqRes API** - Public REST API for user management

## API Information

**Base URL:** `https://reqres.in/api`

**Endpoints:**
- `GET /users` - List all users (pagination supported)
- `GET /users/{id}` - Get single user details
- `POST /users` - Create a new user
- `PUT /users/{id}` - Update a user
- `DELETE /users/{id}` - Delete a user
