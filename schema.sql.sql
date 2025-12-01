-- ============================
-- BANCO DE DADOS
-- ============================
DROP DATABASE IF EXISTS dio_scan;
CREATE DATABASE dio_scan;
USE dio_scan;

-- ============================
-- TABELA: customers (PF e PJ)
-- ============================
DROP TABLE IF EXISTS customers;
CREATE TABLE customers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    email VARCHAR(150) UNIQUE,
    type ENUM('PF','PJ') NOT NULL,
    documento VARCHAR(25) NOT NULL, -- CPF ou CNPJ
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================
-- TABELA: suppliers
-- ============================
DROP TABLE IF EXISTS suppliers;
CREATE TABLE suppliers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    tax_id VARCHAR(25) UNIQUE,
    contact_email VARCHAR(150)
);

-- ============================
-- TABELA: sellers
-- ============================
DROP TABLE IF EXISTS sellers;
CREATE TABLE sellers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    tax_id VARCHAR(25),
    email VARCHAR(150)
);

-- ============================
-- TABELA: products
-- ============================
DROP TABLE IF EXISTS products;
CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    sku VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    stock INT DEFAULT 0
);

-- ============================
-- TABELA: product_suppliers (N:N)
-- ============================
DROP TABLE IF EXISTS product_suppliers;
CREATE TABLE product_suppliers (
    product_id INT,
    supplier_id INT,
    PRIMARY KEY(product_id, supplier_id),
    FOREIGN KEY(product_id) REFERENCES products(id) ON DELETE CASCADE,
    FOREIGN KEY(supplier_id) REFERENCES suppliers(id) ON DELETE CASCADE
);

-- ============================
-- TABELA: payment_methods
-- ============================
DROP TABLE IF EXISTS payment_methods;
CREATE TABLE payment_methods (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    method VARCHAR(100) NOT NULL,
    provider VARCHAR(100),
    details TEXT,
    FOREIGN KEY(customer_id) REFERENCES customers(id) ON DELETE CASCADE
);

-- ============================
-- TABELA: deliveries
-- ============================
DROP TABLE IF EXISTS deliveries;
CREATE TABLE deliveries (
    id INT AUTO_INCREMENT PRIMARY KEY,
    status ENUM('pendente','em_transito','entregue','cancelado') NOT NULL,
    tracking_code VARCHAR(100),
    estimated_delivery_date DATE
);

-- ============================
-- TABELA: orders
-- ============================
DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    seller_id INT,
    delivery_id INT,
    payment_method_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(customer_id) REFERENCES customers(id),
    FOREIGN KEY(seller_id) REFERENCES sellers(id),
    FOREIGN KEY(delivery_id) REFERENCES deliveries(id),
    FOREIGN KEY(payment_method_id) REFERENCES payment_methods(id)
);

-- ============================
-- TABELA: order_items
-- ============================
DROP TABLE IF EXISTS order_items;
CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY(order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY(product_id) REFERENCES products(id)
);

-- ============================
-- INSERTS INICIAIS
-- ============================

-- === Clientes ===
INSERT INTO customers (name, email, type, documento) VALUES
('João Silva', 'joaosilva@gmail.com', 'PF', '875.711.360-24'),
('Auto Elétrica Jonos', 'autojonos@gmail.com', 'PJ', '875.711.360-24/0001-99');

-- === Fornecedores ===
INSERT INTO suppliers (name, tax_id, contact_email) VALUES
('Sampari Auto Peças', '068.508.210-59/0001-05', 'autosampari@gmail.com'),
('Fornecedor Lucas', '644.330.050-53/0001-56', 'lucasvend@gmail.com');

-- === Vendedores ===
INSERT INTO sellers (name, tax_id, email) VALUES
('Paulo', '068.508.210-59', 'paulo45@gmail.com'),
('Lucas', '644.330.050-53', 'lucasvend@gmail.com');

-- === Produtos ===
INSERT INTO products (sku, name, description, price, stock) VALUES
('PEC-001', 'Porta Escovas', 'Peça de reposição para alternador Fiat', 37.80, 15),
('PEC-002', 'Regulador de Voltagem', 'Regulador para alternadores Fiat', 43.00, 12);

-- === Produtos e seus fornecedores ===
INSERT INTO product_suppliers (product_id, supplier_id) VALUES
(1, 1),
(2, 2);

-- === Métodos de pagamento ===
INSERT INTO payment_methods (customer_id, method, provider) VALUES
(1, 'Cartão', 'Visa'),
(1, 'Pix', 'Chave CPF'),
(2, 'Boleto', NULL);

-- === Entregas ===
INSERT INTO deliveries (status, tracking_code, estimated_delivery_date) VALUES
('pendente', NULL, '2025-12-05');

-- === Pedido ===
INSERT INTO orders (customer_id, seller_id, delivery_id, payment_method_id) VALUES
(1, 1, 1, 1);

-- === Itens do pedido ===
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 37.80),
(1, 2, 1, 43.00);

-- ============================
-- CONSULTAS TESTE
-- ============================

-- Produtos
SELECT * FROM products;

-- Estoque baixo
SELECT sku, name, stock
FROM products
WHERE stock < 20;

-- Total do pedido João
SELECT o.id AS pedido,
       c.name AS cliente,
       SUM(oi.unit_price * oi.quantity) AS total
FROM orders o
JOIN customers c ON c.id = o.customer_id
JOIN order_items oi ON oi.order_id = o.id
GROUP BY o.id, c.name;

-- Produtos + fornecedores
SELECT p.name AS produto, GROUP_CONCAT(s.name SEPARATOR ', ') AS fornecedores
FROM products p
JOIN product_suppliers ps ON p.id = ps.product_id
JOIN suppliers s ON s.id = ps.supplier_id
GROUP BY p.name;