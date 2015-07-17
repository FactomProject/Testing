# Testing
These are tools for testing the Factom API.

- **entries** holds files that
 - can be redirected as entry input for the *mkchain* or *put* command
 - are used by the Factom API Test Script for making chains and creating entries

- **full**
 - contains **full.sh**, the Bash script for testing all the commands of the entire Factom API emphasizing boundary conditions and potential vulnerabilities

 - contains copies of both the current
    - Factom API Test Script 
     - automatically executes the steps described in the: 
    - Factom API Test Plan
     - describes entry conditions for the script run (what must be true of the environment for the Test Script to work properly) 
     - describes all the tests executed by the Factom API Test Script
     - allows recording of the results of a particular run
     - automatically calculates test statistics for a particular run

- **get-latest-code**
 - contains:
   - **To-get-the-latest-API-code**
     - step by step instructions on how to prepare a clean Factom CLI environment prior to testing and use
    - **go-version.sh**
     - resets
     - sets the correct **go** version
     - initializes the **go** path
     - sets the **go** directory
    - **sweep-environment.sh**
     - deletes database and temporary files
     - retrieves, compiles, and installs the latest **factom**, **factom-cli**, and **factom wallet** code files 


- - -
Standard procedure is to:
1. Follow the instructions in **To-get-the-latest-API-code** to prepare the environment and get the latest Factom API code
2. Run **full.sh**, the Bash script for testing all the commands of the entire Factom API
3. Record the results of the test run in A COPY (don't overwrite the original!!!) of the Test Plan

    
