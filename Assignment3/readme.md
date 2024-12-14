# Assignment 3

Welcome to the third assignment!

---

## Folders Overview

### **Operators**
Discover my custom **ParquetSource** operator and all adjacent files in the `Operators` folder.

### **Results**
Explore all performance results in the `Results` folder.

---

### **How to run my Apache Wayang fork and test the custom ParquetSource operator**

Follow the steps below to clone, build, and test your custom Apache Wayang fork.

---

## **Prerequisites**
Ensure the following tools are installed and configured on your system:
- **Java 11**: Installed and added to your system's `PATH`.
- **Apache Maven**: Installed and added to your system's `PATH`.
- **Ubuntu WSL**: If you are on Windows, it is significantly easier to run Apache Wayang in the Ubuntu subsystem.
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
### **3.Navigate to incubator-wayang**
```zsh
cd incubator-wayang
```
### **4.Compile Apache Wayang**
```zsh
mvn clean install -DskipTests
```
### **5.Navigate to wayang-benchmark**
```zsh
cd wayang-benchmark
```
### **6. Recompile the module**
```zsh
mvn clean
mvn compile
```
### **7. Run the custom test**
Run my simple test file. Adjust the inputURL to match the parquet file in the yelp_review_full. Train is the large file and test is the small file. Afterwards run:
```zsh
mvn exec:java -Dexec.mainClass="org.apache.wayang.apps.wordcount.WordCountParquet"
```
### **BONUS: Run the TextFileSource operator**
To generate the txt files just go to the convert notebook and run it. Afterwards go to Wayang Benchmark and run:
```zsh
mvn exec:java -Dexec.mainClass="org.apache.wayang.apps.wordcount.WordCountFile"
```