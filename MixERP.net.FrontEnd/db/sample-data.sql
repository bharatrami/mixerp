﻿INSERT INTO core.suppliers(supplier_code, company_name, first_name, middle_name, last_name, account_id)
SELECT 'PES-0001', 'PES Technologies', 'Binod', '', 'Upadhyaya', (SELECT account_id FROM core.accounts WHERE account_name='Accounts Payable');
 
INSERT INTO core.items(item_code, item_name, item_group_id, brand_id, preferred_supplier_id, unit_id, hot_item, tax_id, reorder_level, maintain_stock, cost_price, selling_price)
SELECT 'ITP', 'IBM Thinkpadd II Laptop', 1, 1, 1, 1, 'No', 1, 10, 'Yes', 80000, 125000;

INSERT INTO core.items(item_code, item_name, item_group_id, brand_id, preferred_supplier_id, unit_id, hot_item, tax_id, reorder_level, maintain_stock, cost_price, selling_price)
SELECT 'AIT', 'Acer Iconia Tab', 1, 1, 1, 1, 'Yes', 1, 10, 'Yes', 40000, 65000;

INSERT INTO core.items(item_code, item_name, item_group_id, brand_id, preferred_supplier_id, unit_id, hot_item, tax_id, reorder_level, maintain_stock, cost_price, selling_price)
SELECT 'IXM', 'Intex Mouse', 1, 1, 1, 1, 'No', 1, 10, 'Yes', 200, 350;

INSERT INTO core.items(item_code, item_name, item_group_id, brand_id, preferred_supplier_id, unit_id, hot_item, tax_id, reorder_level, maintain_stock, cost_price, selling_price)
SELECT 'MSO', 'Microsoft Office Premium Edition', 1, 1, 1, 1, 'Yes', 1, 10, 'Yes', 30000, 35000;

INSERT INTO core.items(item_code, item_name, item_group_id, brand_id, preferred_supplier_id, unit_id, hot_item, tax_id, reorder_level, maintain_stock, cost_price, selling_price)
SELECT 'LBS', 'Lotus Banking Solution', 1, 1, 1, 1, 'Yes', 1, 10, 'No', 150000, 150000;

INSERT INTO core.items(item_code, item_name, item_group_id, brand_id, preferred_supplier_id, unit_id, hot_item, tax_id, reorder_level, maintain_stock, cost_price, selling_price)
SELECT 'CAS', 'CAS Banking Solution', 1, 1, 1, 1, 'Yes', 1, 10, 'No', 40000, 40000;

INSERT INTO core.items(item_code, item_name, item_group_id, brand_id, preferred_supplier_id, unit_id, hot_item, tax_id, reorder_level, maintain_stock, cost_price, selling_price)
SELECT 'SGT', 'Samsung Galaxy Tab 10.1', 1, 1, 1, 1, 'No', 1, 10, 'Yes', 30000, 45000;


INSERT INTO office.stores(office_id, store_code, store_name, address, store_type_id, allow_sales)
SELECT 1, 'STORE-1', 'Store 1', 'Office', 2, true UNION ALL
SELECT 1, 'GODOW-1', 'Godown 1', 'Office', 2, false;

INSERT INTO office.cash_repositories(office_id, cash_repository_code, cash_repository_name, description)
SELECT 2, 'DRW1', 'Drawer 1', 'Drawer' UNION ALL
SELECT 2, 'VLT', 'Vault', 'Vault';