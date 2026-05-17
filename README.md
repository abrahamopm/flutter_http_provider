# Product Management App - Provider + HTTP

A Flutter application that performs full CRUD (Create, Read, Update, Delete) operations on product data using the **FakeStore API**. Built with **Provider** state management and the **http** package for networking.

Note: This project and the companion Bloc/Dio project both use the same public API (https://fakestoreapi.com) — they differ only in UI and state-management/network libraries.


## Tech Stack

- **Flutter** - UI Framework
- **Provider** (^6.1.0) - State Management
- **http** (^1.1.0) - Network Requests
- **FakeStore API** - Public REST API for e-commerce products

## API Information

**Base URL:** `https://fakestoreapi.com`

**Endpoints:**
- `GET /products` - List all products
- `GET /products/{id}` - Get single product details
- `POST /products` - Create a new product
- `PUT /products/{id}` - Update a product
- `DELETE /products/{id}` - Delete a product
- `GET /products/categories` - Get all categories
- `GET /products/category/{category}` - Get products by category
