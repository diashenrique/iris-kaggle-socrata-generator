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
$ git clone https://github.com/diashenrique/iris-rad-studio.git
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

## Dream team

* [Henrique Dias](https://community.intersystems.com/user/henrique-dias-2)
* [José Roberto Pereira](https://community.intersystems.com/user/jos%C3%A9-roberto-pereira-0)
  
