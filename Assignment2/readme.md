# Assignment 2

Welcome to the second assignment.

---

## Folders Overview

### **Results**
Explore all performance results in the `Results` folder.

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
### **3. Create the data folder**
```zsh
mkdir data
mkdir -p data/{sf_1,sf_10,sf_50}
```

### **4. Navigate to the dbgen and compile**
```zsh
cd ads2024-ssb-dbgen
make
```

### **5. Generate data**
Replace SF with either 1, 10 or 50. (or all). NOTE: run this command and then run the command in number 6.
```zsh
dbgen -s SF -T a
```

### **6. Move the generated data to the data folder in the respective SF folder.**
```zsh
mv *.tbl ..data/SF
```
### **7. Now you can run the notebook duckdb-API.ipynb.**