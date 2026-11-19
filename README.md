# Customer Supply Chain Analytics | Power BI & PostgreSQL

## Project Overview

An end-to-end **Supply Chain Analytics and Business Intelligence project** built using PostgreSQL, SQL, and Power BI.

The project analyzes the DataCo Global Supply Chain dataset, containing approximately **180,519 order-item records**, to evaluate sales performance, customer behavior, product profitability, and shipping efficiency.

The workflow covers data staging, data quality validation, dimensional modeling, business analysis using SQL, and interactive dashboard development in Power BI.

## Project Objectives

- Analyze overall sales and profitability.
- Identify top-performing products and product categories.
- Understand customer purchasing behavior and profitability.
- Evaluate shipping performance and late delivery rates.
- Compare sales performance across markets and regions.
- Build an interactive dashboard to support business decisions.

## Dataset

**DataCo Global Supply Chain Dataset**

- Approximately 180,519 records.
- Contains order, customer, product, sales, profit, and shipping information.
- Source: DataCo Global Supply Chain Dataset on Kaggle.

The raw dataset is not included in this repository. Download it separately and place it in your local project directory before running the SQL scripts.

## Project Workflow

```text
DataCo CSV Dataset
        |
        v
PostgreSQL Staging Table
        |
        v
Data Quality Checks
        |
        v
Star Schema Data Modeling
        |
        v
SQL Business Analysis
        |
        v
Power BI Dashboard
        |
        v
Business Insights
```

## Database Design

A **Star Schema** was designed to organize the supply chain data and support analytical queries.

### Fact Table

| Table | Description |
|---|---|
| `fact_order_item` | Stores order-item-level measures such as sales, profit, quantity, discount, and price range. |

### Dimension Tables

| Table | Description |
|---|---|
| `dim_customers` | Customer details and customer segment. |
| `dim_product` | Product, category, and department information. |
| `dim_geography` | Market, region, country, and city information. |
| `dim_shipping` | Shipping mode, delivery status, and shipping-day information. |
| `dim_date` | Date attributes including year, quarter, and month. |

A state lookup table, `state_ab`, was also used for state abbreviation mapping.

### Data Modeling Activities

- Created staging and dimension tables.
- Removed duplicate dimension records.
- Generated surrogate keys using `ROW_NUMBER()`.
- Established primary key and foreign key relationships.
- Created indexes on fact table join columns.
- Derived analytical fields such as `price_range` and shipping-day `difference`.

## Data Quality Checks

Data quality validation was performed on the staging data before building the analytical model.

Checks included:

- NULL values in important columns.
- Duplicate order-item records.
- Inconsistent shipping modes and delivery statuses.
- Invalid state values.
- Data consistency across relevant fields.

## SQL Analysis

SQL was used to perform business analysis and validate dashboard metrics.

### SQL Concepts Used

- Joins
- Common Table Expressions (CTEs)
- Window Functions
- `RANK()`
- `LAG()`
- `SUM() OVER()`
- Conditional Aggregation
- `GROUP BY` and `HAVING`
- Views and Indexes

### Business Questions Answered

1. Which markets generate the highest sales and profit?
2. How does sales performance change month over month?
3. Which are the top 10 products by sales?
4. Which customers generate high sales but negative profit?
5. Which shipping modes have the highest late delivery percentage?
6. What is the sales contribution of each customer segment?
7. Which product categories generate the highest revenue?

## Key Performance Indicators

The following metrics were calculated and validated using SQL and Power BI.

| KPI | Result |
|---|---:|
| Total Sales (Post-discount) | $33.05M |
| Total Profit | $3.97M |
| Order Items | 180,519 |
| Distinct Orders | 65,752 |
| Total Customers | 20,652 |
| Quantity Sold | 384,079 |
| Late Delivery Rate | 54.83% |

**Note:** Total Sales uses `order_item_total`, representing the post-discount sales amount. The `sales` column represents pre-discount sales.

## Power BI Dashboard

The interactive Power BI report provides insights across four analytical areas.

### 1. Executive Overview
- Overall sales and profit performance.
- Order-item volume and customer metrics.
- Late delivery percentage.
- Sales performance across markets.

### 2. Customer Analytics
- Sales contribution by customer segment.
- Customer purchasing behavior.
- Customer profitability analysis.
- Identification of high-sales, negative-profit customers.

### 3. Product & Sales Analytics
- Top-performing products.
- Sales by product category and department.
- Product profitability.
- Monthly sales trends.

### 4. Shipping & Logistics
- Late delivery analysis.
- Shipping performance by shipping mode.
- Scheduled versus actual shipping days.
- Delivery status analysis.

## Repository Structure

```text
Customer-Supply-Chain-PBI/
│
├── sql/
│   ├── 01_create_staging.sql
│   ├── 02_create_dimension_table.sql
│   ├── 03_create_fact_index.sql
│   ├── 04_business_queries.sql
│   └── 05_VIEWS.sql
│
├── docs/
│   ├── BRD.pdf
│   ├── FRD.pdf
│   └── REPORT ANALYSIS.pdf
│
├── Customer Chain Project.pbix
│
└── README.md
```

## Technology Stack

| Technology | Purpose |
|---|---|
| PostgreSQL | Data storage, staging, and data modeling |
| SQL | Data validation, transformation, and business analysis |
| Power BI | Interactive dashboards and reporting |
| DAX | KPI calculations and analytical measures |
| Power Query | Data preparation and transformation |

## Documentation

Project documentation is available in the `docs/` directory:

- **BRD.pdf** – Business Requirements Document.
- **FRD.pdf** – Functional Requirements Document.
- **REPORT ANALYSIS.pdf** – Dashboard analysis and business findings.

## How to Use This Project

1. Clone this repository:

   ```bash
   git clone https://github.com/Zafeerxyz/Customer-Supply-Chain-PBI.git
   ```

2. Download the DataCo Global Supply Chain dataset from Kaggle.

3. Create a PostgreSQL database.

4. Load the dataset into the staging table.

5. Execute the SQL scripts in the appropriate order:

   - `01_create_staging.sql`
   - `02_create_dimension_table.sql`
   - `03_create_fact_index.sql`
   - `04_business_queries.sql`
   - `05_VIEWS.sql`

6. Open the Power BI `.pbix` file.

7. Configure the PostgreSQL connection with your database credentials and refresh the data.

## Author

**Mohammed Zafeer K**

Data Analyst | Aspiring Data Engineer

- GitHub: [Zafeerxyz](https://github.com/Zafeerxyz)

---

*This project demonstrates an end-to-end analytical workflow, from raw data ingestion and relational data modeling to SQL-based business analysis and interactive Power BI reporting.*
