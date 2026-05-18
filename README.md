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

## Screenshots 

### 🏠 Home Screen

| Home Page |
| :---: |
| <img src="screenshots/Home_page.png" width="350" alt="Home Page"> |
| Displays the complete product list, category-based filtering, loading/error indicators, and navigation to the respective API action panels. |

### ➕ Create Product (POST Request)

| Create UI | Input Validation | Success Response |
| :---: | :---: | :---: |
| <img src="screenshots/POST_request_UI.png" width="250" alt="POST Request UI"> | <img src="screenshots/POST_request_input_validation.png" width="250" alt="POST Request Validation"> | <img src="screenshots/POST_request_success.png" width="250" alt="POST Request Success"> |
| Simple and beautiful form interface to input product title, price, description, category, and image URL. | Real-time input validation ensuring all required fields are accurately populated. | Simulated alert dialog showcasing a successful POST response with the newly created product object from the API. |

### ✏️ Update Product (PUT / PATCH Requests)

| PUT Request UI | PUT Success | PATCH Request UI | PATCH Success |
| :---: | :---: | :---: | :---: |
| <img src="screenshots/PUT_request_UI.png" width="180" alt="PUT Request UI"> | <img src="screenshots/PUT_request_success.png" width="180" alt="PUT Request Success"> | <img src="screenshots/PATCH_request_UI.png" width="180" alt="PATCH Request UI"> | <img src="screenshots/PATCH_request_success.png" width="180" alt="PATCH Request Success"> |
| Pre-populated form to fully modify all attributes of a product. | Success alert reflecting a full updates response. | Panel to selectively modify specific product fields (e.g. updating only price). | Success alert confirming a partial update via PATCH API. |

### 🗑️ Delete Product (DELETE Request)

| Delete Confirmation | Delete Success |
| :---: | :---: |
| <img src="screenshots/DELETE_request_UI.png" width="250" alt="DELETE Request UI"> | <img src="screenshots/DELETE_request_success.png" width="250" alt="DELETE Request Success"> |
| Confirmation prompt/dialog detailing target product info before running the DELETE command. | Success dialog showing status and verification after the simulated deletion of the product. |

