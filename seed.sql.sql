-- SEED: Inserção de dados de exemplo

-- Clientes
INSERT IGNORE INTO customers (name, email, type, documento) VALUES
('João Silva', 'joaosilva@gmail.com', 'PF', '875.711.360-24'),
('Auto Elétrica Jonos', 'autojonos@gmail.com', 'PJ', '875.711.360-24/0001-99');

-- Fornecedores
INSERT INTO suppliers (name, tax_id, contact_email) VALUES
('Sampari Auto Peças', '068.508.210-59/0001-05', 'autosampari@gmail.com'),
('Fornecedor Lucas', '644.330.050-53/0001-56', 'lucasvend@gmail.com');

-- Vendedores
INSERT INTO sellers (name, tax_id, email) VALUES
('Paulo', '068.508.210-59', 'paulo45@gmail.com'),
('Lucas', '644.330.050-53', 'lucasvend@gmail.com');

-- Produtos
INSERT INTO products (sku, name, description, price, stock) VALUES
('PEC-001', 'Porta Escovas', 'Peça de reposição para alternador Fiat', 37.80, 15),
('PEC-002', 'Regulador de Voltagem', 'Regulador para alternadores Fiat', 43.00, 12);

-- Produtos e seus fornecedores
INSERT INTO product_suppliers (product_id, supplier_id) VALUES
(1, 1),
(2, 2);

-- Métodos de pagamento
INSERT INTO payment_methods (customer_id, method, provider) VALUES
(1, 'Cartão', 'Visa'),
(1, 'Pix', 'Chave CPF'),
(2, 'Boleto', NULL);

-- Entregas
INSERT INTO deliveries (status, tracking_code, estimated_delivery_date) VALUES
('pendente', NULL, '2025-12-05');

-- Pedido
INSERT INTO orders (customer_id, seller_id, delivery_id, payment_method_id) VALUES
(1, 1, 1, 1);

-- Itens do pedido
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 37.80),
(1, 2, 1, 43.00);
