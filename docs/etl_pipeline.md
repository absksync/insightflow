# ETL Pipeline

## Overview

InsightFlow follows a simplified ETL workflow.

ETL stands for:

- Extract
- Transform
- Load

---

## Extract

Source files are loaded from the raw dataset directory.

Input files include:

- Customers
- Orders
- Products
- Sellers
- Reviews
- Payments

---

## Transform

Data validation checks include:

- Missing values
- Null review scores
- Missing delivery dates
- Duplicate customer records

Business transformations include:

- Customer segmentation
- SLA calculation
- Delivery performance analysis
- Customer retention calculation

---

## Load

Validated data is loaded into PostgreSQL.

Database tables include:

- customers
- orders
- products
- sellers
- order_items
- reviews
- payments

---

## Output

The ETL pipeline produces:

- Analytics-ready datasets
- Reporting views
- Dashboard query outputs
- KPI calculations