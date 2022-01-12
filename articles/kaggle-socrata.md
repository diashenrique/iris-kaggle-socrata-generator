# How to find the dataset you need?

Hey community! How are you doing?

I hope to find everyone well, and a happy 2022 to all of you!

Over the years, I've been working on a lot of different projects, and I've been able to find a lot of interesting data.

But, most of the time, the dataset that I used to work with was the customer data. When I started to join the contest in the past couple of years, I began to look for specific web datasets.

I've curated a few data by myself, but I was thinking, "This dataset is enough to help others?"

So, discussing the ideas for this contest with Jose, we decided to approach this contest using a _*different perspective*_.

We thought of offering a variety of datasets of any kind from two famous data sources. This way, we can be empowering the users to find and install the desired dataset in a quick and easy way.

## Socrata

The Socrata Open Data API allows you to programmatically access a wealth of open data resources from governments, non-profits, and NGOs around the world.

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

## Graphic User Interface

To make things easier, we're offering a GUI to install the dataset. But this is something that we like to discuss in our next article. In the meanwhile, you can check a sneak peek below:

![Socrata Dataset list](https://raw.githubusercontent.com/diashenrique/iris-kaggle-socrata-generator/master/images/dataset-interface.png)

![Socrata Return Dataset](https://raw.githubusercontent.com/diashenrique/iris-kaggle-socrata-generator/master/images/ui-download-preview.gif)
