# Assignment 1

Welcome to the first assignment.

---

## Folders Overview

### **results_tpch**
Explore all performance results in the `Results` folder.

### **notebooks**
Explore my working notebooks in the `notebooks` folder.

### **implementations**
Explore my SQL and Python implementations of Naive Bayes in the `implementations` folder. Alongisde, there are the performance results.

---
### **Prerequisites**

Snowflake account.

---

### **How to run the experiments**

Follow the steps below to clone, build, and test my SSB Benchmark implementation.

---

## **Step-by-Step Instructions**

### **1. Clone the Repository**
Use the following command to clone the repository with all submodules:
```zsh
git clone --recurse-submodules <repository-url>
```
### **2. Check submodules**
Check if the submodules are initialzed correctly:
```zsh
git submodule update --init --recursive
```
### **3. Upload data to Snowflake**
The data is available in yelp_review_full.

### **4. Run my implementations**
You can just run the queries in Snowsight that are under implementations: naive-bayes-train.sql and udtf_train.sql