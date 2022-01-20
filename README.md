 [![Gitter](https://img.shields.io/badge/Available%20on-Intersystems%20Open%20Exchange-00b2a9.svg)](https://openexchange.intersystems.com/package/intersystems-iris-dev-template)
 [![Quality Gate Status](https://community.objectscriptquality.com/api/project_badges/measure?project=intersystems_iris_community%2Fintersystems-iris-dev-template&metric=alert_status)](https://community.objectscriptquality.com/dashboard?id=intersystems_iris_community%2Fintersystems-iris-dev-template)
 [![Reliability Rating](https://community.objectscriptquality.com/api/project_badges/measure?project=intersystems_iris_community%2Fintersystems-iris-dev-template&metric=reliability_rating)](https://community.objectscriptquality.com/dashboard?id=intersystems_iris_community%2Fintersystems-iris-dev-template)

# IRIS Kaggle Socrata Generator
Do you need some real data to use in your projects?

Why not use real data from the best sources?!

Our goal it's to allow every developer find and use the best dataset possible for their projects, in a quick and easy way.

## Prerequisites
Make sure you have [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) and [Docker desktop](https://www.docker.com/products/docker-desktop) installed.

## Installation

1. Clone/git pull the repo into any local directory

```
$ git clone https://github.com/diashenrique/iris-kaggle-socrata-generator.git
```

2. Open the terminal in this directory and run:

```
$ docker-compose build
```

3. Run the IRIS container with your project:

```
$ docker-compose up -d
```

## How to Test it

### Socrata

For this initial release, we are using Socrata APIs to search and download and speficic dataset.

Open the API tool of your preference like [Postman](https://www.postman.com/), [Hoppscotch](https://hoppscotch.io/) 

```
GET> https://api.us.socrata.com/api/catalog/v1?only=dataset&q=healthcare
```
This endpoint will return all healthcare related datasets, like the image below: 
![Socrata Return Dataset](https://raw.githubusercontent.com/diashenrique/iris-kaggle-socrata-generator/master/images/socrata_return.png)

Now, get the ID. In this case the id is: "n9tp-i3k3"

Go the the terminal

```
IRISAPP>set api = ##class(dc.dataset.importer.service.socrata.SocrataApi).%New()

IRISAPP>do api.InstallDataset({"datasetId": "n9tp-i3k3", "verbose":true})

Compilation started on 01/07/2022 01:01:28 with qualifiers 'cuk'
Compiling class dc.dataset.imported.DsCommunityHealthcareCenters
Compiling table dc_dataset_imported.DsCommunityHealthcareCenters
Compiling routine dc.dataset.imported.DsCommunityHealthcareCenters.1
Compilation finished successfully in 0.108s.

Class name: dc.dataset.imported.DsCommunityHealthcareCenters
Header: Name VARCHAR(250),Description VARCHAR(250),Location VARCHAR(250),Phone_Number VARCHAR(250),geom VARCHAR(250)
Records imported: 26
```

After the command above, your dataset it's ready to use! 
![Socrata Return Dataset](https://raw.githubusercontent.com/diashenrique/iris-kaggle-socrata-generator/master/images/socrata_sql_afterImport.png)

### Kaggle

To use the datasets from Kaggle, you need to register on the [website](https://www.kaggle.com/). After that, you need to create an API token to use Kaggle's API.

![Kaggle Token Creation](https://raw.githubusercontent.com/diashenrique/iris-kaggle-socrata-generator/master/images/kaggle-account-create-api.png)

Now, just like with Socrata, you can use the API to search and download the dataset.

```
GET> https://www.kaggle.com/api/v1/datasets/list?search=appointments
```

This endpoint will return all healthcare related datasets, like the image below:
![Kaggle Return Dataset](https://raw.githubusercontent.com/diashenrique/iris-kaggle-socrata-generator/master/images/kaggle-get-datasetlist.png)

Now, get the ref value. In this case the ref is: "joniarroba/noshowappointments"

The parameters below "_your-username_", and "_your-password_" are the parameters provided by Kaggle when you create the API token.

```
IRISAPP>Set crendtials = ##class(dc.dataset.importer.service.CredentialsService).%New()

IRISAPP>Do crendtials.SaveCredentials("kaggle", "<your-username>", "<your-password>")

IRISAPP>Set api = ##class(dc.dataset.importer.service.kaggle.KaggleApi).%New()

IRISAPP>Do api.InstallDataset({"datasetId":"joniarroba/noshowappointments", "credentials":"kaggle", "verbose":true})

Class name: dc.dataset.imported.DsNoshowappointments
Header: PatientId INTEGER,AppointmentID INTEGER,Gender VARCHAR(250),ScheduledDay DATE,AppointmentDay DATE,Age INTEGER,Neighbourhood VARCHAR(250),Scholarship INTEGER,Hipertension INTEGER,Diabetes INTEGER,Alcoholism INTEGER,Handcap INTEGER,SMS_received INTEGER,No-show VARCHAR(250)
Records imported: 259
```

After the command above, your dataset it's ready to use!

![Kaggle Select](https://raw.githubusercontent.com/diashenrique/iris-kaggle-socrata-generator/master/images/kaggle-select.png)

## Graphic User Interface

We're offering a GUI to install the dataset to make things easier. But this is something that we like to discuss in our next article. In the meanwhile, you can check a sneak peek below while we are polishing a few things before the official release:

![Socrata Dataset list](https://raw.githubusercontent.com/diashenrique/iris-kaggle-socrata-generator/master/images/dataset-interface.png)

![Socrata Return Dataset](https://raw.githubusercontent.com/diashenrique/iris-kaggle-socrata-generator/master/images/ui-download-preview.gif)
## Dream team

* [Henrique Dias](https://community.intersystems.com/user/henrique-dias-2)
* [José Roberto Pereira](https://community.intersystems.com/user/jos%C3%A9-roberto-pereira-0)
