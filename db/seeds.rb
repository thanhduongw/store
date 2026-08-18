require "open-uri"

puts "== Seeding database =="

# ───────────────────────────────────────────
# Users
# ───────────────────────────────────────────
admin = User.find_or_create_by!(email_address: "admin@store.com") do |u|
  u.first_name  = "Admin"
  u.last_name   = "Store"
  u.password    = "password123"
  u.admin       = true
end
puts "  Admin: #{admin.email_address}"

customer = User.find_or_create_by!(email_address: "khachhang@store.com") do |u|
  u.first_name = "Nguyễn"
  u.last_name  = "Văn An"
  u.password   = "password123"
  u.admin      = false
end
puts "  Khách hàng: #{customer.email_address}"

# ───────────────────────────────────────────
# Categories
# ───────────────────────────────────────────
category_names = [
  "Điện thoại & Phụ kiện",
  "Máy tính & Laptop",
  "Thời trang Nam",
  "Thời trang Nữ",
  "Mỹ phẩm & Làm đẹp",
  "Nhà cửa & Đời sống",
  "Thể thao & Dã ngoại",
  "Sách & Văn phòng phẩm"
]

categories = category_names.each_with_object({}) do |name, h|
  cat = Category.find_or_create_by!(name: name)
  h[name] = cat
end
puts "  Đã tạo #{categories.size} danh mục"

# ───────────────────────────────────────────
# Products
# ───────────────────────────────────────────
products_data = [
  # Điện thoại & Phụ kiện
  {
    name: "iPhone 15 Pro Max 256GB",
    description: "iPhone 15 Pro Max với chip A17 Pro mạnh mẽ, camera 48MP, màn hình Super Retina XDR 6.7 inch, thiết kế titan cao cấp. Hỗ trợ 5G, Action Button và USB-C.",
    price: 29_990_000,
    compare_at_price: 34_990_000,
    inventory_count: 50,
    sku: "IP15PM-256",
    status: "active",
    category: categories["Điện thoại & Phụ kiện"]
  },
  {
    name: "Samsung Galaxy S24 Ultra 512GB",
    description: "Samsung Galaxy S24 Ultra với bút S Pen tích hợp, camera 200MP, màn hình Dynamic AMOLED 2X 6.8 inch, RAM 12GB, hỗ trợ AI Galaxy.",
    price: 27_990_000,
    compare_at_price: 31_990_000,
    inventory_count: 35,
    sku: "SGS24U-512",
    status: "active",
    category: categories["Điện thoại & Phụ kiện"]
  },
  {
    name: "Xiaomi Redmi Note 13 Pro+ 256GB",
    description: "Redmi Note 13 Pro+ với camera 200MP, sạc nhanh HyperCharge 120W, màn hình AMOLED 6.67 inch 120Hz, pin 5000mAh. Giá tốt nhất phân khúc.",
    price: 8_490_000,
    compare_at_price: 10_990_000,
    inventory_count: 120,
    sku: "RN13PP-256",
    status: "active",
    category: categories["Điện thoại & Phụ kiện"]
  },
  {
    name: "Tai nghe Bluetooth Sony WH-1000XM5",
    description: "Tai nghe chống ồn chủ động Sony WH-1000XM5 với thuật toán chống ồn AI, âm thanh Hi-Res, thời lượng pin 30 giờ, kết nối đa điểm.",
    price: 6_990_000,
    compare_at_price: 8_990_000,
    inventory_count: 80,
    sku: "SW-XM5",
    status: "active",
    category: categories["Điện thoại & Phụ kiện"]
  },
  {
    name: "Ốp lưng iPhone 15 Series cao cấp",
    description: "Ốp lưng chống sốc 4 góc, chất liệu TPU cao cấp kết hợp viền nhựa PC cứng. Tương thích với iPhone 15, 15 Plus, 15 Pro, 15 Pro Max.",
    price: 199_000,
    compare_at_price: 350_000,
    inventory_count: 500,
    sku: "CASE-IP15",
    status: "active",
    category: categories["Điện thoại & Phụ kiện"]
  },

  # Máy tính & Laptop
  {
    name: "Laptop ASUS VivoBook 15 i5-1335U",
    description: "Laptop văn phòng ASUS VivoBook 15 trang bị Intel Core i5-1335U thế hệ 13, RAM 16GB DDR4, SSD 512GB NVMe, màn hình FHD IPS 15.6 inch, Windows 11.",
    price: 15_990_000,
    compare_at_price: 18_490_000,
    inventory_count: 40,
    sku: "ASUS-VB15-I5",
    status: "active",
    category: categories["Máy tính & Laptop"]
  },
  {
    name: "MacBook Air M2 13 inch 8GB 256GB",
    description: "MacBook Air với chip Apple M2, màn hình Liquid Retina 13.6 inch, thiết kế siêu mỏng không quạt, thời lượng pin đến 18 giờ. Màu Midnight.",
    price: 26_990_000,
    compare_at_price: 29_990_000,
    inventory_count: 25,
    sku: "MBA-M2-256",
    status: "active",
    category: categories["Máy tính & Laptop"]
  },
  {
    name: "Chuột không dây Logitech MX Master 3S",
    description: "Chuột ergonomic cao cấp Logitech MX Master 3S, cảm biến 8000 DPI, cuộn MagSpeed, kết nối Bluetooth hoặc USB Receiver, pin sạc USB-C.",
    price: 2_290_000,
    compare_at_price: nil,
    inventory_count: 150,
    sku: "LG-MXM3S",
    status: "active",
    category: categories["Máy tính & Laptop"]
  },

  # Thời trang Nam
  {
    name: "Áo phông nam basic cotton 100%",
    description: "Áo phông nam form regular, chất liệu cotton 100% cao cấp thoáng mát, thấm hút mồ hôi tốt. Có nhiều màu sắc. Size S-M-L-XL-XXL.",
    price: 150_000,
    compare_at_price: 250_000,
    inventory_count: 1000,
    sku: "TSHIRT-M-001",
    status: "active",
    category: categories["Thời trang Nam"]
  },
  {
    name: "Quần jean nam slim fit xanh đậm",
    description: "Quần jean nam form slim fit, chất liệu denim co giãn 4 chiều, thoải mái khi vận động. Đường may chắc chắn, màu xanh đậm cổ điển. Size 28-36.",
    price: 490_000,
    compare_at_price: 750_000,
    inventory_count: 200,
    sku: "JEAN-M-SLIM",
    status: "active",
    category: categories["Thời trang Nam"]
  },
  {
    name: "Áo sơ mi nam dài tay trắng công sở",
    description: "Áo sơ mi nam dài tay form slim chuyên nghiệp, chất liệu cotton pha polyester chống nhàu nhẹ, màu trắng tinh. Phù hợp môi trường công sở.",
    price: 320_000,
    compare_at_price: nil,
    inventory_count: 300,
    sku: "SHIRT-M-WHITE",
    status: "active",
    category: categories["Thời trang Nam"]
  },

  # Thời trang Nữ
  {
    name: "Váy hoa nhí maxi dáng dài mùa hè",
    description: "Váy maxi dáng dài họa tiết hoa nhí tươi tắn, chất liệu lụa mát mịn, thiết kế cổ V tinh tế. Phù hợp đi chơi, dạo phố, du lịch. Size S-M-L.",
    price: 380_000,
    compare_at_price: 550_000,
    inventory_count: 150,
    sku: "DRESS-F-FLORAL",
    status: "active",
    category: categories["Thời trang Nữ"]
  },
  {
    name: "Túi xách nữ da PU cao cấp",
    description: "Túi xách tay nữ chất liệu da PU cao cấp, dây đeo điều chỉnh được, nhiều ngăn tiện lợi, khóa kéo chắc chắn. Phong cách thanh lịch, sang trọng.",
    price: 690_000,
    compare_at_price: 990_000,
    inventory_count: 80,
    sku: "BAG-F-PU001",
    status: "active",
    category: categories["Thời trang Nữ"]
  },

  # Mỹ phẩm & Làm đẹp
  {
    name: "Kem dưỡng ẩm Innisfree Green Tea",
    description: "Kem dưỡng ẩm chiết xuất trà xanh Jeju của Innisfree, cung cấp độ ẩm lên đến 24 giờ, làm mịn và sáng da. 50ml. Da mọi loại.",
    price: 350_000,
    compare_at_price: 420_000,
    inventory_count: 200,
    sku: "INF-GT-CREAM",
    status: "active",
    category: categories["Mỹ phẩm & Làm đẹp"]
  },
  {
    name: "Son môi lì Maybelline SuperStay",
    description: "Son môi lì bền màu Maybelline SuperStay Matte Ink, lên màu chuẩn, không gây khô môi, bền đến 16 giờ. Bộ sưu tập nhiều màu thời thượng.",
    price: 185_000,
    compare_at_price: 229_000,
    inventory_count: 500,
    sku: "MAY-SS-LIP",
    status: "active",
    category: categories["Mỹ phẩm & Làm đẹp"]
  },

  # Nhà cửa & Đời sống
  {
    name: "Nồi chiên không dầu Xiaomi 6L",
    description: "Nồi chiên không dầu Xiaomi dung tích 6L, công suất 1800W, 10 chế độ nấu thông minh, bề mặt chống dính cao cấp, điều khiển cảm ứng. Kết nối app Mi Home.",
    price: 2_490_000,
    compare_at_price: 3_290_000,
    inventory_count: 60,
    sku: "XM-AF-6L",
    status: "active",
    category: categories["Nhà cửa & Đời sống"]
  },
  {
    name: "Bộ chăn ga gối cotton 4 món",
    description: "Bộ chăn ga gối cotton 4 món gồm: 1 ga trải giường, 1 chăn mỏng, 2 vỏ gối. Chất liệu 100% cotton mềm mịn, thoáng mát, không phai màu. Size 1m6x2m.",
    price: 890_000,
    compare_at_price: 1_290_000,
    inventory_count: 100,
    sku: "BED-SET-4P",
    status: "active",
    category: categories["Nhà cửa & Đời sống"]
  },

  # Thể thao & Dã ngoại
  {
    name: "Giày chạy bộ Nike Air Zoom Pegasus 40",
    description: "Giày chạy bộ Nike Air Zoom Pegasus 40 với đệm Air Zoom phản hồi năng lượng, phần mũi giày rộng thoải mái, đế cao su chịu mài mòn. Size 38-45.",
    price: 3_200_000,
    compare_at_price: 3_990_000,
    inventory_count: 70,
    sku: "NIKE-AZP40",
    status: "active",
    category: categories["Thể thao & Dã ngoại"]
  },

  # Sách & Văn phòng phẩm
  {
    name: "Sổ tay bìa cứng A5 dotted 160 trang",
    description: "Sổ tay bìa cứng A5 với layout dotted tiện lợi cho bullet journal, giấy dày 120gsm không lem mực, có dải đánh dấu, bookmark. Nhiều màu bìa.",
    price: 85_000,
    compare_at_price: nil,
    inventory_count: 800,
    sku: "NB-A5-DOT",
    status: "active",
    category: categories["Sách & Văn phòng phẩm"]
  },

  # Draft products
  {
    name: "Máy tính bảng Samsung Galaxy Tab S9",
    description: "Samsung Galaxy Tab S9 11 inch, chip Snapdragon 8 Gen 2, RAM 8GB, màn hình Dynamic AMOLED 2X, bút S Pen đi kèm. (Sắp ra mắt)",
    price: 18_990_000,
    compare_at_price: nil,
    inventory_count: 0,
    sku: "SGT-S9",
    status: "draft",
    category: categories["Máy tính & Laptop"]
  },
  {
    name: "Giày sandal nữ đế bánh mì",
    description: "Giày sandal nữ đế bánh mì cao 5cm, quai chéo điều chỉnh được, chất liệu da PU mềm mại. (Đang chuẩn bị nhập hàng)",
    price: 450_000,
    compare_at_price: nil,
    inventory_count: 0,
    sku: "SANDAL-F-BM",
    status: "draft",
    category: categories["Thời trang Nữ"]
  }
]

products = {}
products_data.each do |data|
  p = Product.find_or_create_by!(sku: data[:sku]) do |prod|
    prod.name            = data[:name]
    prod.description     = data[:description]
    prod.price           = data[:price]
    prod.compare_at_price = data[:compare_at_price]
    prod.inventory_count = data[:inventory_count]
    prod.status          = data[:status]
    prod.category        = data[:category]
  end
  products[data[:sku]] = p
end
puts "  Đã tạo #{products.size} sản phẩm"

# ───────────────────────────────────────────
# Product Images (Unsplash - free license)
# ───────────────────────────────────────────
puts "  Đính kèm ảnh sản phẩm từ Unsplash..."

BASE_URL = "https://images.unsplash.com"
IMG_PARAMS = "?w=800&q=80&auto=format&fit=crop"

PRODUCT_IMAGES = {
  "IP15PM-256" => [
    "#{BASE_URL}/photo-1736191550786-46a46aa47394#{IMG_PARAMS}",
    "#{BASE_URL}/photo-1620787384355-59e33847ab6a#{IMG_PARAMS}"
  ],
  "SGS24U-512" => [
    "#{BASE_URL}/photo-1565967249821-083c4775e5bc#{IMG_PARAMS}",
    "#{BASE_URL}/photo-1598327105740-820e04db502e#{IMG_PARAMS}"
  ],
  "RN13PP-256" => [
    "#{BASE_URL}/photo-1598327105740-820e04db502e#{IMG_PARAMS}",
    "#{BASE_URL}/photo-1565967249821-083c4775e5bc#{IMG_PARAMS}"
  ],
  "SW-XM5" => [
    "#{BASE_URL}/photo-1761120359417-e7b609cef1ca#{IMG_PARAMS}",
    "#{BASE_URL}/photo-1780585455616-fb9483ffab53#{IMG_PARAMS}"
  ],
  "CASE-IP15" => [
    "#{BASE_URL}/photo-1620787384355-59e33847ab6a#{IMG_PARAMS}",
    "#{BASE_URL}/photo-1736191550786-46a46aa47394#{IMG_PARAMS}"
  ],
  "ASUS-VB15-I5" => [
    "#{BASE_URL}/photo-1675868374427-123788a7291c#{IMG_PARAMS}",
    "#{BASE_URL}/photo-1541746590489-c4097dfb2197#{IMG_PARAMS}"
  ],
  "MBA-M2-256" => [
    "#{BASE_URL}/photo-1541746590489-c4097dfb2197#{IMG_PARAMS}",
    "#{BASE_URL}/photo-1675868374427-123788a7291c#{IMG_PARAMS}"
  ],
  "LG-MXM3S" => [
    "#{BASE_URL}/photo-1739742473235-34a7bd9b8f87#{IMG_PARAMS}"
  ],
  "TSHIRT-M-001" => [
    "#{BASE_URL}/photo-1620799139652-715e4d5b232d#{IMG_PARAMS}",
    "#{BASE_URL}/photo-1651761179569-4ba2aa054997#{IMG_PARAMS}"
  ],
  "JEAN-M-SLIM" => [
    "#{BASE_URL}/photo-1565084888279-aca607ecce0c#{IMG_PARAMS}",
    "#{BASE_URL}/photo-1515459961680-58264ee27219#{IMG_PARAMS}"
  ],
  "SHIRT-M-WHITE" => [
    "#{BASE_URL}/photo-1651761179569-4ba2aa054997#{IMG_PARAMS}",
    "#{BASE_URL}/photo-1620799139652-715e4d5b232d#{IMG_PARAMS}"
  ],
  "DRESS-F-FLORAL" => [
    "#{BASE_URL}/photo-1777888766761-6af980dc6ef6#{IMG_PARAMS}",
    "#{BASE_URL}/photo-1590967563224-7b831c6a89df#{IMG_PARAMS}"
  ],
  "BAG-F-PU001" => [
    "#{BASE_URL}/photo-1560891958-68bb1fe7fb78#{IMG_PARAMS}"
  ],
  "INF-GT-CREAM" => [
    "#{BASE_URL}/photo-1715702130909-a5b2942a411b#{IMG_PARAMS}"
  ],
  "MAY-SS-LIP" => [
    "#{BASE_URL}/photo-1570088727237-68500d217455#{IMG_PARAMS}"
  ],
  "XM-AF-6L" => [
    "#{BASE_URL}/photo-1556912102-ea493a2a5b93#{IMG_PARAMS}"
  ],
  "BED-SET-4P" => [
    "#{BASE_URL}/photo-1606855637183-ea2a00b6f15f#{IMG_PARAMS}",
    "#{BASE_URL}/photo-1595526114035-0d45ed16cfbf#{IMG_PARAMS}"
  ],
  "NIKE-AZP40" => [
    "#{BASE_URL}/photo-1562613521-6b5293e5b0ea#{IMG_PARAMS}",
    "#{BASE_URL}/photo-1617813774819-2b086f744456#{IMG_PARAMS}"
  ],
  "NB-A5-DOT" => [
    "#{BASE_URL}/photo-1761322572550-967ea8c0bfd9#{IMG_PARAMS}"
  ],
  "SGT-S9" => [
    "#{BASE_URL}/photo-1565967249821-083c4775e5bc#{IMG_PARAMS}"
  ],
  "SANDAL-F-BM" => [
    "#{BASE_URL}/photo-1777888766761-6af980dc6ef6#{IMG_PARAMS}"
  ]
}.freeze

PRODUCT_IMAGES.each do |sku, urls|
  product = products[sku]
  next unless product
  next if product.images.attached?

  urls.each_with_index do |url, idx|
    begin
      io = URI.open(
        url,
        "User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36",
        read_timeout: 30,
        open_timeout: 15
      )
      fname = "#{sku.downcase.gsub(/[^a-z0-9]/, '_')}_#{idx + 1}.jpg"
      product.images.attach(io: io, filename: fname, content_type: "image/jpeg")
    rescue => e
      puts "    ✗ #{sku} ảnh #{idx + 1}: #{e.message[0..100]}"
    end
  end

  puts "  ✓ #{product.name}: #{product.images.count} ảnh"
end

# ───────────────────────────────────────────
# Orders (chỉ tạo nếu chưa có)
# ───────────────────────────────────────────
if Order.count.zero?
  active_products = Product.active.where("inventory_count > 0").to_a

  orders_data = [
    {
      user: customer,
      full_name: "Nguyễn Văn An",
      phone: "0901234567",
      address: "123 Đường Lê Lợi, Quận 1, TP.HCM",
      status: "shipped",
      items: [
        { product: active_products.find { |p| p.sku == "TSHIRT-M-001" }, qty: 2 },
        { product: active_products.find { |p| p.sku == "JEAN-M-SLIM" }, qty: 1 }
      ]
    },
    {
      user: customer,
      full_name: "Nguyễn Văn An",
      phone: "0901234567",
      address: "123 Đường Lê Lợi, Quận 1, TP.HCM",
      status: "paid",
      items: [
        { product: active_products.find { |p| p.sku == "INF-GT-CREAM" }, qty: 1 },
        { product: active_products.find { |p| p.sku == "MAY-SS-LIP" }, qty: 3 }
      ]
    },
    {
      user: nil,
      full_name: "Trần Thị Bích",
      phone: "0912345678",
      address: "456 Đường Nguyễn Huệ, Quận 1, TP.HCM",
      status: "pending",
      items: [
        { product: active_products.find { |p| p.sku == "DRESS-F-FLORAL" }, qty: 1 },
        { product: active_products.find { |p| p.sku == "BAG-F-PU001" }, qty: 1 }
      ]
    },
    {
      user: nil,
      full_name: "Lê Minh Tuấn",
      phone: "0987654321",
      address: "789 Đường Trần Phú, Quận 5, TP.HCM",
      status: "cancelled",
      items: [
        { product: active_products.find { |p| p.sku == "XM-AF-6L" }, qty: 1 }
      ]
    },
    {
      user: customer,
      full_name: "Nguyễn Văn An",
      phone: "0901234567",
      address: "123 Đường Lê Lợi, Quận 1, TP.HCM",
      status: "pending",
      items: [
        { product: active_products.find { |p| p.sku == "NB-A5-DOT" }, qty: 5 },
        { product: active_products.find { |p| p.sku == "TSHIRT-M-001" }, qty: 3 }
      ]
    }
  ]

  orders_data.each do |data|
    items = data[:items].select { |i| i[:product].present? }
    next if items.empty?

    total = items.sum { |i| i[:product].price * i[:qty] }

    order = Order.create!(
      user:      data[:user],
      full_name: data[:full_name],
      phone:     data[:phone],
      address:   data[:address],
      status:    data[:status],
      total:     total
    )

    items.each do |i|
      order.order_items.create!(
        product:      i[:product],
        product_name: i[:product].name,
        quantity:     i[:qty],
        price:        i[:product].price
      )
    end
  end

  puts "  Đã tạo #{Order.count} đơn hàng demo"
else
  puts "  Bỏ qua đơn hàng (đã có #{Order.count} đơn)"
end

puts "== Seed hoàn tất =="
puts ""
puts "  Đăng nhập admin : admin@store.com / password123"
puts "  Đăng nhập user  : khachhang@store.com / password123"
