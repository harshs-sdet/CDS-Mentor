
I updated readme.md
# Project Setup and Execution Guide

## Prerequisites

### 1. Install Python

- **Download Python**: [Python Downloads](https://www.python.org/downloads/)
- **Verify Installation**: Open Command Prompt (cmd) and type:
  ```bash
  python --version

### 2. Install Chrome WebDriver
- **Download WebDriver**: Get the version of Chrome WebDriver that matches your current Chrome browser version from Chrome WebDriver.
- **Install WebDriver**: Download the executable file and place it in:
  ```bash
    C:\Users\username\AppData\Local\Programs\Python\Python311\Scripts

### 3.Set Environment Path
- Add the following paths to your Environment Variables:
  ```bash
  C:\Users\{UserProfile}\AppData\Local\Programs\Python\Python311\
  C:\Users\{UserProfile}\AppData\Local\Programs\Python\Python311\Scripts

### 4. Install PyCharm
- **Download PyCharm**: PyCharm Community Edition (Select the open-source Community version)
- **Set Up PyCharm**:
  - Launch PyCharm.
  - Click on "New Project."
  - Enter the path for creating the project and select "Virtual Env" for the environment.

### 5. Install PyCharm Plugins
- Go to Plugins and install the following plugins:
  - Robot Framework Language Server

### 6. Clone the Repository
- Create and Navigate to a New Folder:
  - Create a new folder and open Command Prompt inside it.
- Clone the Repository

### 7. Install Project Dependencies
- Run the following command to install required Python packages:
  ```bash
  pip install -r .\requirements.txt

## Running Tests
- Example Command to Run Tests:
- Change TC-ID with actual id
    ```bash
    robot --i <TC-ID> -d Reports tests/ui/Mentor-web/TrainerStudio.robot

## Update Test link With Latest Run Report
- To update the test link, please run the below command. Change API-Key with actual key value.
  ```bash
  python TestLink_Integration.py -u "http://testlink-server.centralus.cloudapp.azure.com/lib/api/xmlrpc/v1/xmlrpc.php" -k "<API-Key>" -p "CDS Mentor" -t "CDSMentorTestPlan" -f "UAT" --file "Reports/output.xml"
- To Get the API key, follow below steps:
  - Go to test link home page
     ```bash
     http://testlink-server.centralus.cloudapp.azure.com/index.php
  - Click On My settings from top left.
  - Under API interface, you will find your API key.
