// OP1: insertMany() : insert all 3 documents from sample_documents.json
db.products.insertMany([
  {
    _id: "ELEC001",
    name: "Samsung 55\" 4K Smart TV",
    category: "Electronics",
    brand: "Samsung",
    price: 54999,
    currency: "INR",
    description: "55-inch Crystal 4K UHD Smart Television with built-in Wi-Fi and voice assistant support.",
    specifications: {
      warranty_years: 2,
      voltage: "110-240V",
      power_consumption_watts: 120,
      screen_size_inches: 55,
      resolution: "3840x2160",
      connectivity: ["HDMI", "USB", "Bluetooth", "Wi-Fi"]
    },
    stock_quantity: 35,
    ratings: {
      average: 4.5,
      total_reviews: 1284
    },
    tags: ["4K", "Smart TV", "HDR", "Voice Control"],
    listed_date: "2024-06-15",
    is_active: true
  },
  {
    _id: "CLOTH001",
    name: "Men's Slim Fit Cotton Shirt",
    category: "Clothing",
    brand: "Allen Solly",
    price: 1499,
    currency: "INR",
    description: "Premium slim-fit cotton formal shirt available in multiple colors and sizes.",
    specifications: {
      material: "100% Cotton",
      fit: "Slim Fit",
      sleeve_type: "Full Sleeve",
      pattern: "Solid",
      care_instructions: ["Machine Wash", "Do Not Bleach", "Medium Iron"]
    },
    available_sizes: [
      { size: "S", stock: 20 },
      { size: "M", stock: 45 },
      { size: "L", stock: 30 },
      { size: "XL", stock: 15 },
      { size: "XXL", stock: 8 }
    ],
    available_colors: ["White", "Sky Blue", "Navy", "Black"],
    ratings: {
      average: 4.2,
      total_reviews: 567
    },
    tags: ["Formal", "Cotton", "Office Wear"],
    listed_date: "2024-09-01",
    is_active: true
  },
  {
    _id: "GROC001",
    name: "Organic Honey - Raw & Unfiltered",
    category: "Groceries",
    brand: "Dabur",
    price: 425,
    currency: "INR",
    description: "500g jar of raw, unfiltered organic honey sourced from the Himalayan foothills.",
    specifications: {
      weight_grams: 500,
      organic_certified: true,
      shelf_life_months: 24,
      storage_instructions: "Store in a cool, dry place away from direct sunlight."
    },
    nutritional_info: {
      serving_size_grams: 20,
      calories: 64,
      total_carbohydrates_grams: 17,
      sugars_grams: 16,
      protein_grams: 0.1,
      fat_grams: 0
    },
    manufacturing_date: "2024-03-10",
    expiry_date: "2026-03-10",
    batch_number: "DBR-HNY-20240310-A7",
    allergens: [],
    stock_quantity: 200,
    ratings: {
      average: 4.7,
      total_reviews: 2310
    },
    tags: ["Organic", "Natural", "Immunity Booster"],
    listed_date: "2024-04-01",
    is_active: true
  }
]);

// OP2: find() : retrieve all Electronics products with price > 20000
db.products.find({
  category: "Electronics",
  price: { $gt: 20000 }
});

// OP3: find() : retrieve all Groceries expiring before 2025-01-01
db.products.find({
  category: "Groceries",
  expiry_date: { $lt: "2025-01-01" }
});

// OP4: updateOne() : add a "discount_percent" field to a specific product
db.products.updateOne(
  { _id: "CLOTH001" },
  { $set: { discount_percent: 15 } }
);

// OP5: createIndex() : Create an index on category field and explain why.
// Creating an index on the "category" field speeds up queries that filter or sort by category.
// Since product catalog queries almost always involve browsing or searching within a specific category
// (e.g., "show all Electronics" or "find Groceries expiring soon"),
// this index allows MongoDB to quickly locate matching documents using a B-tree lookup
// instead of scanning every document in the collection.
// This is especially important as the catalog grows to thousands or millions of products.
db.products.createIndex({ category: 1 });