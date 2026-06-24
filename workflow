{
  "name": "backup",
  "nodes": [
    {
      "parameters": {
        "rule": {
          "interval": [
            {
              "field": "cronExpression",
              "expression": "0 9 * * *"
            }
          ]
        }
      },
      "id": "26158c9c-4798-4740-88be-d5863a45c651",
      "name": "Schedule Trigger",
      "type": "n8n-nodes-base.scheduleTrigger",
      "position": [
        -1024,
        -256
      ],
      "typeVersion": 1.1,
      "notes": "⏰ Este workflow se ejecuta todos los días a las 9:00 AM. Cambia el cron según necesites."
    },
    {
      "parameters": {
        "fields": {
          "values": [
            {
              "name": "folder",
              "stringValue": ""
            }
          ]
        },
        "include": "none",
        "options": {}
      },
      "id": "f7075220-bda0-45dc-8273-ca6eb1ca9c0d",
      "name": "setBackupFolder 🗄️",
      "type": "n8n-nodes-base.set",
      "position": [
        -832,
        -496
      ],
      "notesInFlow": true,
      "notes": "⚠️ CONFIGURACIÓN REQUERIDA: Cambia 'folder' por la ruta donde quieres guardar los backups en tu servidor. Ejemplo: C:\\backup_n8n\\ (Windows) o /home/usuario/backups/ (Linux/Mac)",
      "typeVersion": 3.2
    },
    {
      "parameters": {
        "filters": {},
        "requestOptions": {}
      },
      "id": "520c7645-1231-4e68-9024-9adca2c64b8b",
      "name": "GET WORKFLOWS",
      "type": "n8n-nodes-base.n8n",
      "position": [
        -672,
        -496
      ],
      "typeVersion": 1,
      "notes": "⚠️ CONFIGURACIÓN REQUERIDA: Conecta tu cuenta de n8n API en 'Credentials'",
      "credentials": {
        "n8nApi": {
          "id": "",
          "name": "n8n account"
        }
      }
    },
    {
      "parameters": {
        "mode": "jsonToBinary",
        "options": {
          "fileName": "={{ $json.name }}"
        }
      },
      "id": "750e96eb-7a1f-40df-91fa-5399fbfa40ca",
      "name": "MAKE JSON FILES",
      "type": "n8n-nodes-base.moveBinaryData",
      "position": [
        -800,
        -224
      ],
      "notesInFlow": true,
      "typeVersion": 1
    },
    {
      "parameters": {
        "options": {
          "reset": false
        }
      },
      "id": "48682828-6f2e-417f-8138-446d9137a26e",
      "name": "Loop Over Files",
      "type": "n8n-nodes-base.splitInBatches",
      "typeVersion": 3,
      "position": [
        -560,
        -272
      ]
    },
    {
      "parameters": {
        "operation": "write",
        "fileName": "={{ $('setPaths').item.json.fullFilePath }}",
        "options": {
          "append": false
        }
      },
      "id": "a3545a6c-e786-4aea-a24a-698fee2f3622",
      "name": "write backup-file",
      "type": "n8n-nodes-base.readWriteFile",
      "typeVersion": 1,
      "position": [
        -256,
        -80
      ],
      "onError": "continueRegularOutput"
    },
    {
      "parameters": {
        "amount": 0.4
      },
      "id": "517160da-f85b-4967-a361-e87acb36f8ce",
      "name": "Wait",
      "type": "n8n-nodes-base.wait",
      "typeVersion": 1.1,
      "position": [
        16,
        -464
      ],
      "webhookId": ""
    },
    {
      "parameters": {
        "command": "={{ ($json.folder) ? 'mkdir -p ' + ($('setBackupFolder 🗄️').item.json.folder + $json.folder) : '' }} "
      },
      "id": "dbdff1e5-a827-4f5c-904b-7ad45c7bed5d",
      "name": "mkdirP",
      "type": "n8n-nodes-base.executeCommand",
      "typeVersion": 1,
      "position": [
        -224,
        -480
      ]
    },
    {
      "parameters": {
        "assignments": {
          "assignments": [
            {
              "id": "91059f9d-1a93-46a7-b390-37367ee516f5",
              "name": "fullFilePath",
              "value": "={{ $('setBackupFolder 🗄️').item.json.folder }}{{ ($binary.data.directory ? $binary.data.directory + '/' : '')}}{{$binary.data.fileName}}.json",
              "type": "string"
            },
            {
              "id": "3c742aa2-0a97-4f2c-9577-6db764ef6c34",
              "name": "folder",
              "value": "={{ ($binary.data.directory ? $binary.data.directory + '/' : '')}}",
              "type": "string"
            }
          ]
        },
        "includeOtherFields": true,
        "options": {
          "includeBinary": true
        }
      },
      "id": "8c86c08b-780b-4b3d-af86-385f15a6b75c",
      "name": "setPaths",
      "type": "n8n-nodes-base.set",
      "typeVersion": 3.3,
      "position": [
        -448,
        -496
      ]
    },
    {
      "parameters": {
        "name": "={{ $('GET WORKFLOWS').item.json.name }}",
        "driveId": {
          "__rl": true,
          "mode": "list",
          "value": "My Drive"
        },
        "folderId": {
          "__rl": true,
          "value": "",
          "mode": "list"
        },
        "options": {}
      },
      "id": "8b976bf2-4420-464c-9426-03159e63629c",
      "name": "UPLOAD TO GOOGLE DRIVE",
      "type": "n8n-nodes-base.googleDrive",
      "position": [
        128,
        -144
      ],
      "typeVersion": 3,
      "alwaysOutputData": false,
      "executeOnce": false,
      "retryOnFail": false,
      "notes": "⚠️ CONFIGURACIÓN REQUERIDA: 1) Conecta tu cuenta de Google Drive en 'Credentials'. 2) Selecciona o crea una carpeta destino en 'folderId'",
      "credentials": {
        "googleDriveOAuth2Api": {
          "id": "",
          "name": "Google Drive account"
        }
      }
    }
  ],
  "pinData": {},
  "connections": {
    "Schedule Trigger": {
      "main": [
        [
          {
            "node": "setBackupFolder 🗄️",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "setBackupFolder 🗄️": {
      "main": [
        [
          {
            "node": "GET WORKFLOWS",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "GET WORKFLOWS": {
      "main": [
        [
          {
            "node": "MAKE JSON FILES",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "MAKE JSON FILES": {
      "main": [
        [
          {
            "node": "Loop Over Files",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Loop Over Files": {
      "main": [
        [],
        [
          {
            "node": "setPaths",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "setPaths": {
      "main": [
        [
          {
            "node": "mkdirP",
            "type": "main",
            "index": 0
          },
          {
            "node": "Wait",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Wait": {
      "main": [
        [
          {
            "node": "write backup-file",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "write backup-file": {
      "main": [
        [
          {
            "node": "Loop Over Files",
            "type": "main",
            "index": 0
          },
          {
            "node": "UPLOAD TO GOOGLE DRIVE",
            "type": "main",
            "index": 0
          }
        ]
      ]
    }
  },
  "active": true,
  "settings": {
    "executionOrder": "v1"
  },
  "versionId": "a9f95302-6915-475a-890d-6eeb55870c89",
  "meta": {
    "templateCredsSetupCompleted": true,
    "instanceId": ""
  },
  "id": "Jucx2f7kluJfWnUp",
  "tags": []
}
