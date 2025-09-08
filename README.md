# Airline Reservation System — SQL Project

## 📌 Overview
This project explores the design and performance challenges of an airline reservation system using SQL. It was completed as part of **DSE6210: Big Data SQL and NoSQL**.

## 🎯 Objectives
- Build normalized relational tables for flights, passengers, and reservations.  
- Analyze performance issues without SQL views.  
- Evaluate scalability in a 1NF relational model.  
- Explore optimizations such as views, indexing, and partitioning.  

## 🗂️ Deliverables
- `erd-diagram-highres.png` → Entity Relationship Diagram  
- `queries.sql` → SQL table creation and queries  
- `project-paper.pdf` → Analytical write-up  

## 🛠️ Key Insights
- Without views, repeated joins create performance bottlenecks.  
- **Indexes and partitioning** improve query performance in large datasets.  
- SQL scales well for structured data but may require **NoSQL support** for high-volume, real-time workloads.  

## 📊 Example: ERD Diagram
![ERD Diagram](erd-diagram-highres.png)

## 📂 Repo Structure
/README.md ← this file

/erd-diagram-highres.png

/project-paper.pdf

/queries.sql

## 🔮 Next Steps
- Add **materialized views** to reduce query time for repeated joins.  
- Benchmark SQL performance vs. a **NoSQL alternative** for real-time scalability. 
