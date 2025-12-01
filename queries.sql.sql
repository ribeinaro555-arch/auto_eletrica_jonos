-- QUERIES: Consultas de teste

-- Listar todos os produtos
SELECT * FROM products;

-- Produtos com estoque baixo
SELECT sku, name, stock
FROM products
WHERE stock < 20;

-- Total do pedido do cliente João
SELECT o.id AS pedido,
       c.name AS cliente,
       SUM(oi.unit_price * oi.quantity) AS total
FROM orders o
JOIN customers c ON c.id = o.customer_id
JOIN order_items oi ON oi.order_id = o.id
GROUP BY o.id, c.name;

-- Relação de produtos e seus fornecedores
SELECT p.name AS produto,
       GROUP_CONCAT(s.name SEPARATOR ', ') AS fornecedores
FROM products p
JOIN product_suppliers ps ON p.id = ps.product_id
JOIN suppliers s ON s.id = ps.supplier_id
GROUP BY p.name;