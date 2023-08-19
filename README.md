# apache-php-oracle

This repository provides a Docker container that runs an Apache server with PHP 8.2 and Oracle client extensions. It's perfect for PHP applications requiring Oracle database connectivity.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Clone the Project](#clone-the-project)
- [Update Project and Push](#update-project-and-push)
- [OpenShift Deployment](#openshift-deployment)
  - [Build Configuration](#create-a-new-build-configuration)
  - [Start a Build](#start-a-new-build)
  - [Deployment](#deploy-the-image)
  - [Route Management](#route-management)
  - [Logs and Monitoring](#get-logs)
  - [Resource Cleanup](#delete-resources)
- [Docker Deployment](#docker-deployment)
  - [Building the Image](#building-the-image)
  - [Running the Container](#run-a-container-from-the-built-image)
  - [Verifying Container Status](#verify-the-container-is-running)
  - [Accessing the Application](#access-the-application)
- [Notes and Tips](#notes-and-tips)

## Prerequisites

- Git
- OpenShift CLI (if deploying to OpenShift)
- Docker (for Docker deployment)

## Clone the Project

```bash
git clone https://github.com:tshenolo/apache-php-oracle.git
```

## Update Project and Push

```bash
git add .
git commit -m "add/updated files"
git push
```

## OpenShift Deployment

### Create a New Build Configuration

```bash
oc new-build --strategy=docker --binary --name apache-php-oracle 
```

### Start a New Build

```bash
oc start-build apache-php-oracle --from-dir=.
```

### Deploy the Image

```bash
oc new-app apache-php-oracle
```

### Route Management

To create:

```bash
oc expose service/apache-php-oracle --port=8080
```

To verify:

```bash
oc get route apache-php-oracle
```

### Get Logs

To get pods:

```bash
oc get pods
```

To view logs:

```bash
oc logs apache-php-oracle-9cd4b855f-ld2tx -c apache-php-oracle 
```

### Delete Resources

Deployment Configuration:

```bash
oc delete dc/apache-php-oracle
```

Service:

```bash
oc delete svc/apache-php-oracle
```

Route:

```bash
oc delete route/apache-php-oracle
```

## Docker Deployment

### Building the Image

```bash
docker build -t apache-php-oracle-image .
```

### Run a Container from the Built Image

```bash
docker run -d -p 8080:8080 --name apache-php-oracle-container apache-php-oracle-image
```

### Verify the Container is Running

```bash
docker ps
```

### Access the Application

Open your browser and navigate to:

[http://localhost:8080](http://localhost:8080)


## Notes and Tips

- Ensure that the Oracle Instant Client files (`instantclient-basic-linux.x64-19.20.0.0.0dbru.zip` and `instantclient-sdk-linux.x64-19.20.0.0.0dbru.zip`) are present in the same directory as the Dockerfile before building.
- Adjust port mappings as per your application's requirement.
- Remember to clean up resources after testing or use to avoid unused deployments and containers.
