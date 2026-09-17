# Brazilian E-Commerce Product Analytics

Product analytics case study based on the [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce).

The project demonstrates an end-to-end analytics workflow: data validation, relational database design, SQL analysis, product metric calculation, Python-based exploration, data visualization, and business recommendations.

## Executive Summary

The analysis covers 99,441 orders placed on the Olist marketplace.

The main findings are:

- Only 3.12% of customers made more than one purchase.
- Repeat customers generated more revenue per customer, although their average order value was slightly lower.
- Revenue was concentrated in a relatively small group of product categories.
- Delivery performance varied substantially across Brazilian states.
- States with longer average delivery times also tended to have higher cancellation rates.

The main business opportunities are improving customer retention, investigating underperforming delivery routes, and running targeted campaigns in high-revenue product categories.

## Business Objective

The objective of the project is to understand customer purchasing behavior and identify opportunities to increase revenue and improve the customer experience.

The analysis focuses on the following business questions:

1. What are the marketplace's key product and revenue metrics?
2. How frequently do customers make repeat purchases?
3. Which product categories generate the most revenue?
4. How does customer behavior differ between one-time and repeat buyers?
5. How do delivery speed and on-time delivery vary across states?
6. Which regions and product categories have the highest cancellation rates?
7. What actions could improve retention, logistics, and revenue?

## Dataset

The project uses the Brazilian E-Commerce Public Dataset published by Olist.

The dataset contains information about:

- customers;
- orders;
- order items;
- payments;
- products;
- sellers;
- product category translations;
- customer and seller locations.

The main analytical model consists of seven connected PostgreSQL tables. The detailed table descriptions, relationships, primary keys, and foreign keys are documented in the [data model](docs/03_data_model.md).

The customer review table is not included in the current analysis and is treated as a project limitation.

## Technology Stack

- PostgreSQL
- SQL
- Python
- pandas
- Matplotlib
- Seaborn
- Jupyter Notebook
- Git and GitHub

## Project Workflow

1. Imported the source data into PostgreSQL.
2. Checked missing values, duplicate records, data types, key uniqueness, and referential integrity.
3. Created primary and foreign key constraints.
4. Built a relational data model.
5. Performed exploratory SQL analysis.
6. Calculated customer, revenue, cancellation, and delivery metrics.
7. Conducted additional analysis and visualization in Python.
8. Translated the results into business insights and recommendations.

## Key Metrics

| Metric | Value | Definition |
|---|---:|---|
| Total orders | 99,441 | Number of distinct orders |
| Total payment value | 16.0M BRL | Sum of customer payments |
| Average order value | 161 BRL | Total payment value divided by the number of paid orders |
| Repeat purchase rate | 3.12% | Share of unique customers with more than one order |
| Cancellation rate | 0.63% | Share of orders with the `canceled` status |
| Average delivery time | 12.5 days | Average time between purchase and delivery for delivered orders |
| On-time delivery rate | 91.89% | Share of delivered orders received by the estimated delivery date |

All monetary values are expressed in Brazilian reals.

## Key Findings

### 1. Customer retention is the main growth opportunity

Only 3.12% of customers made more than one purchase. This means that the marketplace depends primarily on one-time buyers and has substantial room to improve repeat purchasing.

### 2. Repeat customers are more valuable over their lifetime

Repeat customers generated more revenue per customer because they placed multiple orders. However, one-time customers had a slightly higher average order value.

This distinction is important: repeat customers are more valuable because of purchase frequency, not because they spend more on every individual order.

### 3. Revenue is concentrated in a limited number of categories

A relatively small group of categories generated a large share of total sales. Health and beauty was among the strongest-performing categories.

These categories are suitable candidates for targeted merchandising and customer retention campaigns.

### 4. Delivery performance differs across states

Average delivery time and on-time delivery rate varied considerably by customer state. Some regions consistently experienced slower delivery.

This indicates that national averages can hide important regional logistics problems.

### 5. Delivery performance may be connected to cancellations

States with longer average delivery times also tended to show higher cancellation rates. This is an observational relationship and does not, by itself, prove that longer delivery times cause cancellations.

Additional route- and seller-level analysis would be required to test this hypothesis.

## Business Recommendations

### Improve Customer Retention

- Introduce a second-purchase campaign for first-time customers.
- Test personalized product recommendations based on the category of the first order.
- Measure the share of customers making a second purchase within 30, 60, and 90 days.

### Investigate Regional Logistics Performance

- Prioritize states with the longest delivery times and lowest on-time delivery rates.
- Analyze seller-to-customer routes to identify recurring delivery bottlenecks.
- Track delivery metrics separately by state instead of relying only on national averages.

### Run Targeted Category Campaigns

- Test promotions and cross-selling campaigns in high-revenue categories.
- Use health and beauty as one of the initial categories for retention experiments.
- Evaluate campaigns using incremental orders, revenue, average order value, and repeat purchase rate.

## Repository Structure

├── docs/                Project documentation and data model
├── notebooks/           Python analysis and visualizations
├── sql/                 Data validation and analytical SQL scripts
├── .env.example         Example configuration without credentials
├── .gitignore           Files excluded from version control
├── requirements.txt     Python dependencies
└── README.md            Project overview and main results

## Reproducing the Analysis

1. Download the source files from the [Kaggle dataset page](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce).
2. Create a PostgreSQL database and import the required CSV files.
3. Run the SQL scripts in the `sql/` directory in numerical order.
4. Create a Python environment and install the dependencies:
5. Store the local database connection settings in environment variables. Database credentials must not be committed to the repository.
6. Run the notebooks from the `notebooks/` directory from top to bottom.

## Limitations

- Customer reviews are not included in the current version of the analysis.
- The dataset does not contain customer acquisition costs, marketing channels, product margins, or marketplace commissions.
- Revenue recommendations therefore do not necessarily represent profitability recommendations.
- Relationships observed in aggregated data should not be interpreted as causal effects.
- The dataset represents a historical period and should not be treated as a description of Olist's current performance.

## Possible Extensions

- Cohort retention analysis
- RFM customer segmentation
- Statistical analysis of delivery performance and cancellations
- Customer review analysis
- Interactive Power BI or Tableau dashboard
- A/B test design for a second-purchase campaign
