# Product App

A Flutter application that displays products using the [DummyJSON API](https://dummyjson.com/).

## TODO

### Development Tasks

1. **First Commit**

   * Initial Flutter project creation
   * Create the basic project structure
   * Make the first Git commit

2. **Product List & API**

   * Create the product list screen
   * Create API service to retrieve products
   * Display product title, thumbnail, and price

3. **Product Detail**

   * Add product detail screen
   * Display product description
   * Display product price and rating
   * Display product images

4. **Retry Button**

   * Handle API connection timeout
   * Add a Retry button when the product request fails
   * Set API timeout to 5 seconds

5. **Basic Features**

   * Add product search
   * Add search debounce
   * Add pagination when scrolling
   * Add Pull-to-Refresh
   * Add image loading placeholder
   * Handle image loading errors

---

## How to Run

### 1. Clone the Project

```bash
git clone <repository-url>
```

### 2. Go to the Project Folder

```bash
cd product_app
```

### 3. Get Flutter Dependencies

```bash
flutter pub get
```

### 4. Check Connected Devices

```bash
flutter devices
```

Make sure an emulator, simulator, or physical device is connected.

### 5. Run the Application

```bash
flutter run
```

### Run on a Specific Device

You can check the available devices:

```bash
flutter devices
```

Then run the application using the device ID:

```bash
flutter run -d <device-id>
```

---

## API

This application uses the DummyJSON API.

### Get Products

```text
GET https://dummyjson.com/products?limit=20&skip=0
```

Used for loading the product list and pagination.

### Search Products

```text
GET https://dummyjson.com/products/search?q=phone
```

Used for searching products.

### Get Product Detail

```text
GET https://dummyjson.com/products/{id}
```

Used for retrieving the details of a selected product.

---

## AI Assistance

ChatGPT was used during development to validate the planned development workflow and implementation approach.

The workflow was first planned based on the intended application requirements, then ChatGPT was used to review the approach and confirm whether the workflow was technically appropriate.

ChatGPT was also used to assist with:

* Implementing product pagination when scrolling
* Updating the product list with newly loaded products
* Implementing product search using the API search endpoint
* Adding debounce for the search input
* Reviewing and improving the overall Flutter implementation

The final implementation and development decisions were reviewed and applied manually in the project.
