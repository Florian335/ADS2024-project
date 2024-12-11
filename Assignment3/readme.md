# Assignment 3

Welcome to assignment3

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
Run my simple test file which utilizes the JSONPlaceholder API and outputs the word counts:
```zsh
mvn exec:java -Dexec.mainClass="org.apache.wayang.apps.wordcount.WordCountParquet"
```