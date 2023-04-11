# Cloud Kitchen App

The app aims to tackle the problem of locating homespun food services in your locality, making them more accessible, and streamlining business operations for these services.

## Getting Started

To clone and run this application, you'll need Git installed in your computer.

From your command line:

```bash
# Clone this repository to your local machine
git clone https://github.com/diaas14/cloud-kitchen-app.git

# Change the current working directory
cd cloud-kitchen-app
```

## Note to Collaborators

1. Clone repository

```bash
# Clone this repository to your local machine
git clone https://github.com/diaas14/cloud-kitchen-app.git
```

2. Install Node, Flutter, Docker and Kubernetes if you haven't already.

3. To run the Node.js backend microservices -

- Install Skaffold by following the instructions on the Skaffold website.
- Make sure Docker and Kubernetes is up and running
- In your terminal, navigate to the root directory of the project.
- Run skaffold dev to build and deploy the microservices and React app server to your local Kubernetes cluster.
- Wait for Skaffold to finish deploying the microservices.

4. To run flutter app -

- Navigate to ./client directory.
- Install dependencies by running `flutter pub get`
- Connect a mobile device that is on the same network.
- Run the app by running `flutter run`

5. Pull changes to your local repository before you make any changes

```bash
git pull
```

6. Push your changes

```bash
git push origin main
```

7. Raise a Pull Request before merging branches
