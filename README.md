# puppet-apim-cluster

Setup WSO2 API Manager distributed cluster through puppet

API Manager uses the following four main components:

| Component | Description |
| ------------- | ------------- |
| Publisher | Enables API providers to easily publish their APIs, share documentation, provision API keys, and gather feedback on API features, quality, and usage. |
| Store | Enables consumers to self-register, discover API functionality, subscribe to APIs, evaluate them, and interact with API publishers. |
| Key Manager | Responsible for all security and key-related operations. |
| Gateway | Responsible for securing, protecting, managing, and scaling API calls. |

![Alt text](apimcluster.png?raw=true "Basic distributed setup")

Following are the current WSO2 API Manager clustering patterns implemented.

Pattern 2

![Alt text](files/images/patterns/Pattern2.png?raw=true "Current clustering pattern")

Pattern 3

![Alt text](files/images/patterns/Pattern3.png?raw=true "Current clustering pattern")

Pattern 5

![Alt text](files/images/patterns/Pattern5.png?raw=true "Current clustering pattern")

Pattern 7

![Alt text](files/images/patterns/Pattern7.png?raw=true "Current clustering pattern")

Pattern 8

![Alt text](files/images/patterns/Pattern8.png?raw=true "Current clustering pattern")
