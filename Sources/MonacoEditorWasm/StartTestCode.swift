


let START_CODE_A: String = """

fruits = ["apple", "banana", "cherry"]
numbers = [1, 2, 3, 4, 5]

numbers_dict = {1: "one", 2: "two", 3: "three"}
dict_numbers = {"one": 1, "two": 2, "three": 3}

# Subscript examples
fruit = fruits[0]  # str from list[str]
number = numbers[1]  # int from list[int]
word = numbers_dict[1]  # str from dict[int, str]
word2 = dict_numbers["two"]  # int from dict[str, int]

def hello():
    print("Hello, World!")

b = "hello"

class MyClassA:
    def __init__(self):
        self.property = "value"
        
        a = 1
        b = a
        c = b
    
    def method(self):
        # method implementation
        e = 1
        f = e
        c = b

        f = fruits
        # Now f is list[str], not int!

        fruit = fruits[0]  # str from list[str]
        number = numbers[1]  # int from list[int]
        word = numbers_dict[1]  # str from dict[int, str]

class MyClassB:
    def __init__(self):
        self.property = "value"
        
        a = 1
        b = a
        c = b
    
    def method(self):
        # method implementation
        e = 1
        f = e
        c = b

        f = fruits
        # Now f is list[str], not int!

        fruit = fruits[0]  # str from list[str]
        number = numbers[1]  # int from list[int]
        word = numbers_dict[1]  # str from dict[int, str]
        letter = fruit[1]

        p = self.self.property
"""

let START_CODE_B: String = """
# Intermediate Python Example - Data Processing & Analysis
from dataclasses import dataclass

# Global configuration variables
TAX_RATE = 0.08
DISCOUNT_THRESHOLD = 1000.0
MAX_ITEMS_PER_ORDER = 50
DEFAULT_CURRENCY = "USD"
WAREHOUSE_LOCATION = "San Francisco"

# Global counters and state
total_orders_created = 0
total_revenue = 0.0
active_customers = []
product_categories = ["Electronics", "Furniture", "Clothing", "Books"]

# Global cache
price_cache = {}
customer_cache = {}

# Data models
@dataclass
class Product:
    id: int
    name: str
    price: float
    category: str
    in_stock: bool = True

@dataclass
class Order:
    order_id: int
    customer_name: str
    items: list
    total: float

    def add_item(self, product: Product):
        self.items.append(product)
        self.total = self.total + product.price

    def add_random_item(self, product_list: list):
        import random
        product = random.choice(product_list)
        self.add_item(product)

class Database:
    def __init__(this, connection_string: str):
        this.connection = connection_string
        this.products: dict = {}
        this.orders: dict = {}
        this._next_order_id = 1
        
        # Use global variables
        this.currency = DEFAULT_CURRENCY
        this.location = WAREHOUSE_LOCATION
    
    def add_product(this, product: Product):
        global total_revenue
        
        this.products[product.id] = product
        
        # Update global price cache
        cache_key = f"{product.category}_{product.id}"
        price_cache[cache_key] = product.price
        
        return product.id
    
    def get_product(this, product_id: int):
        if product_id in this.products:
            return this.products[product_id]
        return None
    
    def create_order(this, customer: str, product_ids: list):
        global total_orders_created
        
        items = []
        total_price = 0.0
        
        # Check max items constraint
        if len(product_ids) > MAX_ITEMS_PER_ORDER:
            product_ids = product_ids[:MAX_ITEMS_PER_ORDER]
        
        for pid in product_ids:
            product = this.get_product(pid)
            if product and product.in_stock:
                items.append(product)
                total_price = total_price + product.price
        
        # Apply tax
        tax_amount = total_price * TAX_RATE
        total_with_tax = total_price + tax_amount
        
        # Apply discount if threshold met
        final_total = total_with_tax
        if total_price >= DISCOUNT_THRESHOLD:
            discount = total_price * 0.1
            final_total = total_with_tax - discount
        
        order = Order(
            order_id=this._next_order_id,
            customer_name=customer,
            items=items,
            total=final_total
        )
        
        this.orders[order.order_id] = order
        this._next_order_id = this._next_order_id + 1
        
        # Update global counters
        total_orders_created = total_orders_created + 1
        
        # Track customer
        if customer not in active_customers:
            active_customers.append(customer)
            customer_cache[customer] = []
        
        customer_cache[customer].append(order.order_id)
        
        return order

class InventoryManager:
    def __init__(me, db: Database):
        me.database = db
        me.low_stock_threshold = 10
        
        # Use global categories
        me.categories = product_categories
    
    def get_products_by_category(me, category: str):
        results = []
        
        # Check if category is valid
        if category not in product_categories:
            return results
        
        for product_id in me.database.products:
            product = me.database.products[product_id]
            if product.category == category:
                results.append(product)
        
        return results
    
    def calculate_category_revenue(me, category: str):
        products = me.get_products_by_category(category)
        total = 0.0
        
        for product in products:
            product_price = product.price
            
            # Apply tax rate
            price_with_tax = product_price * (1 + TAX_RATE)
            total = total + price_with_tax
        
        return total
    
    def find_expensive_products(me, min_price: float):
        expensive = []
        
        # Use global discount threshold as reference
        threshold = DISCOUNT_THRESHOLD / 2
        actual_min = max(min_price, threshold)
        
        for pid in me.database.products:
            prod = me.database.products[pid]
            if prod.price >= actual_min:
                expensive.append(prod)
        
        return expensive

class OrderProcessor:
    def __init__(self, inventory: InventoryManager):
        self.inventory = inventory
        self.processed_count = 0
        
        # Reference global currency
        self.currency = DEFAULT_CURRENCY
    
    def process_order(self, order: Order):
        global total_revenue
        
        if not order.items:
            return False
        
        customer = order.customer_name
        item_count = len(order.items)
        order_total = order.total
        
        # Update global revenue
        total_revenue = total_revenue + order_total
        
        # Check against global max items
        if item_count > MAX_ITEMS_PER_ORDER:
            print(f"Warning: Order exceeds max items ({MAX_ITEMS_PER_ORDER})")
        
        print(f"Processing order for {customer}: {item_count} items, ${order_total}")
        
        self.processed_count = self.processed_count + 1
        return True
    
    def get_order_summary(self, order: Order):
        # Calculate tax portion
        subtotal = order.total / (1 + TAX_RATE)
        tax_portion = order.total - subtotal
        
        summary = {
            "id": order.order_id,
            "customer": order.customer_name,
            "item_count": len(order.items),
            "total": order.total,
            "tax": tax_portion,
            "currency": self.currency
        }
        
        return summary

def setup_sample_data(db: Database):
    # Create sample products
    laptop = Product(
        id=1,
        name="Laptop Pro",
        price=1299.99,
        category="Electronics",
        in_stock=True
    )
    
    mouse = Product(
        id=2,
        name="Wireless Mouse",
        price=29.99,
        category="Electronics",
        in_stock=True
    )
    
    desk = Product(
        id=3,
        name="Standing Desk",
        price=599.99,
        category="Furniture",
        in_stock=False
    )
    
    chair = Product(
        id=4,
        name="Ergonomic Chair",
        price=399.99,
        category="Furniture",
        in_stock=True
    )
    
    # Add products to database
    db.add_product(laptop)
    db.add_product(mouse)
    db.add_product(desk)
    db.add_product(chair)
    
    return [laptop, mouse, desk, chair]

def analyze_inventory(inventory: InventoryManager):
    # Get electronics
    electronics = inventory.get_products_by_category("Electronics")
    electronics_count = len(electronics)
    
    # Get first electronic item
    if electronics:
        first_item = electronics[0]
        first_name = first_item.name
        first_price = first_item.price
        
        # Use global tax rate
        price_with_tax = first_price * (1 + TAX_RATE)
        print(f"First electronics item: {first_name} at ${first_price} (${price_with_tax} with tax)")
    
    # Calculate revenue
    electronics_revenue = inventory.calculate_category_revenue("Electronics")
    furniture_revenue = inventory.calculate_category_revenue("Furniture")
    
    combined_revenue = electronics_revenue + furniture_revenue
    
    # Find expensive items using global threshold
    expensive_threshold = DISCOUNT_THRESHOLD / 2
    expensive_items = inventory.find_expensive_products(expensive_threshold)
    expensive_count = len(expensive_items)
    
    # Access global cache
    cache_size = len(price_cache)
    customer_count = len(active_customers)
    
    stats = {
        "electronics_count": electronics_count,
        "electronics_revenue": electronics_revenue,
        "furniture_revenue": furniture_revenue,
        "total_revenue": combined_revenue,
        "expensive_count": expensive_count,
        "cache_size": cache_size,
        "active_customers": customer_count,
        "tax_rate": TAX_RATE
    }
    
    return stats

def main():
    global total_revenue
    
    # Initialize database with global location
    connection_str = f"sqlite:///{WAREHOUSE_LOCATION}/inventory.db"
    db = Database(connection_str)
    
    # Setup sample data
    products = setup_sample_data(db)
    product_count = len(products)
    print(f"Added {product_count} products to database")
    
    # Create inventory manager
    inventory = InventoryManager(db)
    
    # Analyze inventory
    stats = analyze_inventory(inventory)
    total_rev = stats["total_revenue"]
    tax_rate_used = stats["tax_rate"]
    print(f"Total revenue: ${total_rev} (tax rate: {tax_rate_used})")
    
    # Create sample orders
    order1 = db.create_order("Alice Johnson", [1, 2])
    order2 = db.create_order("Bob Smith", [4])
    
    # Process orders
    processor = OrderProcessor(inventory)
    
    success1 = processor.process_order(order1)
    if success1:
        summary1 = processor.get_order_summary(order1)
        customer1 = summary1["customer"]
        total1 = summary1["total"]
        tax1 = summary1["tax"]
        currency1 = summary1["currency"]
        print(f"Order processed for {customer1}: ${total1} {currency1} (tax: ${tax1})")
    
    success2 = processor.process_order(order2)
    if success2:
        summary2 = processor.get_order_summary(order2)
        items2 = summary2["item_count"]
        print(f"Second order has {items2} items")
    
    # Final statistics using globals
    processed = processor.processed_count
    global_orders = total_orders_created
    global_rev = total_revenue
    customers = len(active_customers)
    
    print(f"\\nTotal orders processed: {processed}")
    print(f"Global orders count: {global_orders}")
    print(f"Global revenue: ${global_rev}")
    print(f"Active customers: {customers}")
    
    # Check customer history
    if "Alice Johnson" in customer_cache:
        alice_orders = customer_cache["Alice Johnson"]
        alice_order_count = len(alice_orders)
        print(f"Alice has {alice_order_count} orders")
    
    # Get specific product and check properties
    laptop_product = db.get_product(1)
    if laptop_product:
        laptop_name = laptop_product.name
        laptop_price = laptop_product.price
        is_available = laptop_product.in_stock
        
        # Calculate price with tax
        price_with_tax = laptop_price * (1 + TAX_RATE)
        
        if is_available:
            print(f"{laptop_name} is available for ${laptop_price} (${price_with_tax} with tax)")

if __name__ == "__main__":
    main()
"""

let START_CODE_C: String = """
# Advanced Python Code Example - API Client with Type Inference
from typing import Optional, Dict, List, Any, TypeVar, Generic
from dataclasses import dataclass
import asyncio
import json

# Type variable for generic response
T = TypeVar('T')

@dataclass
class User:
    id: int
    name: str
    email: str
    age: Optional[int] = None
    is_active: bool = True

@dataclass
class APIResponse(Generic[T]):
    status: int
    data: Optional[T]
    error: Optional[str] = None
    headers: Dict[str, str] = None

class RateLimiter:
    def __init__(self, max_requests: int, window: float):
        self.max_requests = max_requests
        self.window = window
        self.requests: List[float] = []
        self._lock = asyncio.Lock()
    
    async def acquire(self):
        async with self._lock:
            now = asyncio.get_event_loop().time()
            self.requests = [t for t in self.requests if now - t < self.window]
            
            if len(self.requests) >= self.max_requests:
                wait_time = self.window - (now - self.requests[0])
                await asyncio.sleep(wait_time)
            
            self.requests.append(now)

class APIClient:
    def __init__(self, base_url: str, api_key: str, rate_limit: int = 100):
        self.base_url = base_url.rstrip('/')
        self.api_key = api_key
        self.limiter = RateLimiter(rate_limit, 60.0)
        self.session = None
        self._cache: Dict[str, Any] = {}
    
    async def __aenter__(self):
        return self
    
    async def __aexit__(self, exc_type, exc_val, exc_tb):
        if self.session:
            await self.session.close()
    
    def _build_headers(self, extra: Optional[Dict[str, str]] = None) -> Dict[str, str]:
        headers = {
            'Authorization': f'Bearer {self.api_key}',
            'Content-Type': 'application/json',
            'User-Agent': 'SwiftyMonacoIDE/1.0'
        }
        if extra:
            headers.update(extra)
        return headers
    
    async def get(self, endpoint: str, params: Optional[Dict[str, Any]] = None) -> APIResponse[Dict]:
        # Check cache first
        cache_key = f"{endpoint}:{json.dumps(params or {})}"
        if cache_key in self._cache:
            cached_data = self._cache[cache_key]
            return APIResponse(status=200, data=cached_data)
        
        await self.limiter.acquire()
        
        url = f'{self.base_url}/{endpoint.lstrip("/")}'
        headers = self._build_headers()
        
        try:
            response = await self._make_request('GET', url, headers=headers, params=params)
            data = await response.json()
            
            # Cache successful responses
            self._cache[cache_key] = data
            
            return APIResponse(status=response.status, data=data, headers=response.headers)
        except Exception as e:
            error_msg = str(e)
            return APIResponse(status=500, data=None, error=error_msg)
    
    async def post(self, endpoint: str, data: Dict[str, Any]) -> APIResponse[Dict]:
        await self.limiter.acquire()
        
        url = f'{self.base_url}/{endpoint.lstrip("/")}'
        headers = self._build_headers()
        
        try:
            response = await self._make_request('POST', url, headers=headers, json=data)
            result = await response.json()
            
            # Invalidate relevant cache entries
            self._invalidate_cache(endpoint)
            
            return APIResponse(status=response.status, data=result, headers=response.headers)
        except Exception as e:
            error_msg = str(e)
            return APIResponse(status=500, data=None, error=error_msg)
    
    def _invalidate_cache(self, endpoint: str):
        keys_to_remove = [k for k in self._cache.keys() if k.startswith(endpoint)]
        for key in keys_to_remove:
            del self._cache[key]
    
    async def batch_get(self, endpoints: List[str]) -> List[APIResponse[Dict]]:
        tasks = [self.get(endpoint) for endpoint in endpoints]
        results = await asyncio.gather(*tasks, return_exceptions=True)
        return results

class UserService:
    def __init__(self, client: APIClient):
        self.client = client
        self.users_cache: Dict[int, User] = {}
    
    async def get_user(self, user_id: int) -> Optional[User]:
        if user_id in self.users_cache:
            cached_user = self.users_cache[user_id]
            return cached_user
        
        response = await self.client.get(f'/users/{user_id}')
        
        if response.status == 200 and response.data:
            user_data = response.data
            user = User(
                id=user_data['id'],
                name=user_data['name'],
                email=user_data['email'],
                age=user_data.get('age'),
                is_active=user_data.get('is_active', True)
            )
            self.users_cache[user_id] = user
            return user
        
        return None
    
    async def get_users(self, filters: Optional[Dict[str, Any]] = None) -> List[User]:
        params = filters or {}
        response = await self.client.get('/users', params=params)
        
        if response.status == 200 and response.data:
            users_data = response.data
            users = [
                User(
                    id=u['id'],
                    name=u['name'],
                    email=u['email'],
                    age=u.get('age'),
                    is_active=u.get('is_active', True)
                )
                for u in users_data
            ]
            
            # Cache all users
            for user in users:
                self.users_cache[user.id] = user
            
            return users
        
        return []
    
    async def create_user(self, user_data: Dict[str, Any]) -> Optional[User]:
        response = await self.client.post('/users', user_data)
        
        if response.status in [200, 201] and response.data:
            new_user_data = response.data
            new_user = User(
                id=new_user_data['id'],
                name=new_user_data['name'],
                email=new_user_data['email'],
                age=new_user_data.get('age'),
                is_active=new_user_data.get('is_active', True)
            )
            self.users_cache[new_user.id] = new_user
            return new_user
        
        return None

async def process_users(service: UserService, user_ids: List[int]):
    # Fetch multiple users
    tasks = [service.get_user(uid) for uid in user_ids]
    users = await asyncio.gather(*tasks)
    
    # Filter active users
    active_users = [u for u in users if u and u.is_active]
    
    # Process each active user
    for user in active_users:
        name_upper = user.name.upper()
        email_domain = user.email.split('@')[1]
        
        print(f"Processing {name_upper} from {email_domain}")
        
        if user.age and user.age > 18:
            adult_count = 1
        else:
            minor_count = 1

async def main():
    async with APIClient('https://api.example.com', 'secret-key-123', rate_limit=50) as client:
        service = UserService(client)
        
        # Single user fetch
        user = await service.get_user(123)
        if user:
            user_name = user.name
            user_email = user.email
            print(f"User: {user_name}, Email: {user_email}")
        
        # Batch fetch
        user_ids = [1, 2, 3, 4, 5]
        await process_users(service, user_ids)
        
        # Create new user
        new_user_data = {
            'name': 'Alice Smith',
            'email': 'alice@example.com',
            'age': 28
        }
        new_user = await service.create_user(new_user_data)
        if new_user:
            new_id = new_user.id
            print(f"Created user with ID: {new_id}")
        
        # Get all active users
        active_filters = {'is_active': True}
        all_users = await service.get_users(active_filters)
        total_count = len(all_users)
        print(f"Found {total_count} active users")
        
        # Extract names
        names = [u.name for u in all_users]
        first_name = names[0] if names else "Unknown"

if __name__ == '__main__':
    asyncio.run(main())
"""