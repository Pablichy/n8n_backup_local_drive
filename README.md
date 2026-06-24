📦 n8n Backup Workflow to Google Drive
Automated backup solution for n8n workflows - Export all your workflows as JSON files and upload them to Google Drive daily.

📋 Table of Contents
Overview

Features

Prerequisites

Installation

Configuration

How It Works

Workflow Diagram

Environment Variables

Security Best Practices

Troubleshooting

Contributing

License

🚀 Overview
This n8n workflow automatically backs up all your n8n workflows daily at 9:00 AM. It exports each workflow as a separate JSON file and uploads them to a specified Google Drive folder, ensuring you never lose your automation configurations.

Perfect for:

🏢 Production environments requiring disaster recovery

👥 Teams sharing workflow templates

🔄 Version control of n8n configurations

💾 Regular backup automation

✨ Features
Feature	Description
⏰ Scheduled Backups	Runs daily at 9:00 AM (configurable cron expression)
📁 Individual File Export	Each workflow is saved as a separate JSON file
☁️ Google Drive Upload	Automatically uploads backups to your Google Drive
📂 Folder Structure	Preserves workflow folder organization
🔄 Loop Processing	Handles multiple workflows efficiently with batch processing
🛡️ Error Handling	Continues execution even if individual files fail
⚙️ Configurable	Easy to customize backup location and schedule
📋 Prerequisites
Before using this workflow, ensure you have:

1. n8n Instance
n8n version 0.218.0 or higher

Admin access to your n8n instance

2. Required n8n Credentials
Credential	Purpose
n8n API	To fetch all workflows from your n8n instance
Google Drive OAuth2	To upload backup files to Google Drive
3. Google Drive Setup
A Google account with Drive access

A dedicated folder for backups (recommended)

OAuth2 credentials configured in n8n

🔧 Installation
Method 1: Import via n8n UI (Recommended)
Download the workflow JSON file from this repository

Open your n8n instance

Navigate to Workflows → Import from File

Select the downloaded JSON file

Click "Import"
curl -X POST \
  http://your-n8n-instance:5678/api/v1/workflows/import \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d @workflow-backup.json ⚙️ Configuration
Step 1: Configure the Schedule
The workflow runs daily at 9:00 AM by default. To customize:

Open the Schedule Trigger node

Modify the cron expression:# Examples:
0 9 * * *     # Daily at 9:00 AM
0 0 * * *     # Daily at midnight
0 */6 * * *   # Every 6 hours
0 0 * * 0     # Every Sunday at midnight Step 2: Set Backup Folder Path
In the setBackupFolder 🗄️ node:// Windows
C:\\backup_n8n\\

// Linux/Mac
/home/user/backups/n8n/

// Using environment variable (recommended)
{{ $env.BACKUP_FOLDER }} 

Step 3: Connect n8n API Credentials
Open the GET WORKFLOWS node

Click Create New or select existing:

Authentication: API Key or OAuth2

Base URL: http://localhost:5678 or your n8n instance URL

API Key: Your n8n API key

Step 4: Configure Google Drive
Open the UPLOAD TO GOOGLE DRIVE node

Connect your Google Drive account:

Click Create New → OAuth2

Authorize n8n to access your Drive

Select or create a destination folder:

Click on folderId field

Browse and select your backup folder
<img width="1780" height="3515" alt="deepseek_mermaid_20260624_9af3b3" src="https://github.com/user-attachments/assets/fca8d290-81fb-4071-9701-0361f0bd19d7" />

Detailed Flow:
Schedule Trigger - Starts the workflow at the configured time

setBackupFolder - Sets the local backup directory

GET WORKFLOWS - Fetches all workflows from n8n API

MAKE JSON FILES - Converts each workflow to JSON format

Loop Over Files - Iterates through each workflow

setPaths - Generates full file paths with folder structure

mkdirP - Creates necessary directories

Wait - Small delay to prevent rate limiting

write backup-file - Saves JSON to local filesystem

UPLOAD TO GOOGLE DRIVE - Uploads file to Google Drive

🗂️ File Structure
Backups are saved with the following structure:
backup_n8n/
├── workflow_name_1.json
├── workflow_name_2.json
├── folder_name/
│   ├── workflow_name_3.json
│   └── workflow_name_4.json
└── ...
