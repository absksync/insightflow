# InsightFlow Architecture

## Overview

InsightFlow is a Customer Experience Analytics and Reporting Platform built on top of a large-scale e-commerce dataset.

The platform simulates a SaaS analytics implementation workflow where raw customer interaction data is ingested, validated, transformed, analyzed, and visualized through business intelligence dashboards.

---

## Architecture Flow

Raw Data
↓
Data Validation
↓
Data Cleaning
↓
PostgreSQL Data Warehouse
↓
Analytics Views
↓
Dashboard Queries
↓
Power BI Dashboards
↓
Business Insights

---

## Components

### Data Layer

Stores raw datasets:

- Customers
- Orders
- Products
- Sellers
- Reviews
- Payments
- Geolocation

### Database Layer

PostgreSQL 16 running inside Docker.

Responsible for:

- Relational modeling
- Data integrity
- Foreign key enforcement
- Analytics storage

### Analytics Layer

Contains:

- KPI calculations
- Customer Experience metrics
- Operational metrics
- SLA analysis
- Retention analysis

### Reporting Layer

Reporting views simplify Power BI integration.

Examples:

- vw_customer_experience_summary
- vw_seller_performance
- vw_customer_retention
- vw_delivery_operations

### Visualization Layer

Power BI dashboards provide:

- Executive Overview
- Customer Experience Analytics
- Operations Performance
- Data Quality Reporting

---

## Business Objectives

- Measure customer satisfaction
- Track operational performance
- Monitor SLA compliance
- Identify customer retention patterns
- Support data-driven decision making