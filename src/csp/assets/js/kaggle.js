/**
 * DataTables Basic
 */

 $(function () {
  'use strict';

  const searchKaggle = new SearchDataset();
  
  searchKaggle.createTable = function(data, tableId) {
    return $(tableId).DataTable({
      "dom": '<"d-flex justify-content-between align-items-center mx-0 row"<"col-sm-12 col-md-6"l><"col-sm-12 col-md-6"f>>t<"d-flex justify-content-between mx-0 row"<"col-sm-12 col-md-6"i><"col-sm-12 col-md-6"p>>',
      "processing": true,
      "data": data,
      "columns": [{
        "data": "id"
      }, {
        "data": "title"
      }, {
        "data": "viewCount"
      }, {
        "data": "downloadCount"
      }, {
        "data": "licenseName",
        "defaultContent": ""
      }, {
        "data": "url",
        "render": function (data, type, row, meta) {
          if (type === 'display') {
            data = '<a href="' + row.url + '" target="_blank"><span class="font-weight-bold">' + data + '</span></a>';
          }
          return data;
        }
      }]
    });
  }

  searchKaggle.details = function(pArrayIndex, data) {
    const datasetId = data[pArrayIndex].ref;
    var settings = {
      "url": "/dataset/importer/details",
      "method": "POST",
      "headers": {
        "Content-Type": "application/json"
      },
      "data": JSON.stringify({
        "provider": "kaggle",
        "datasetId": datasetId,
        "credentials": getKaggleConfig().key
      }),
      "timeout": 0,
      "error": (error) => {
          finishSwalLoadingError(error);
      }
    };
    $.ajax(settings).done(function(response) {
      setDetails(response);
    });
  }

  function setDetails(response) {
    
    $("#detail-dataTable > tbody").children().remove();


    var dataDetails = response.datasetFiles[0];
    
    console.log("dataDetails", dataDetails);
    
    $("#id-dataset").text(`${dataDetails.datasetRef}/${dataDetails.ref}`);
    $("#name-dataset").text(dataDetails.name);
    $("#description-dataset").text(dataDetails.description);
    $("#filetype-dataset").text("file type: " + dataDetails.fileType);
    $("#owner-dataset").text(dataDetails.ownerRef);
    $("#id-totalsize").text(calcSize(dataDetails.totalBytes));
    $("#createdate-dataset").text(dataDetails.creationDate);

    // loop through array of columns in dataDetails
    for (var i = 0; i < dataDetails.columns.length; i++) {
      $("#detail-dataTable > tbody").append("<tr><td>" + dataDetails.columns[i].name + "</td><td>" + dataDetails.columns[i].type + "</td><td>" + dataDetails.columns[i].description + "</td></tr>");
    }
  }

  searchKaggle.clearDetails = function() {
    $("#id-dataset").text("");
  }

  function calcSize(data) {
    let label = "";
    const units = ['B', 'KB', 'MB', 'GB', 'TB']
    let n = parseInt(data);
    for (const unit in units) {
      if (n >= 1000) {
        n = n / 1000
      } else {
        label = `${Math.round(n)} ${units[unit]}`
        break;
      }
    }
    return label;
  }

  $('#idSearchKaggle').keypress(function (e) {
    if (e.which == 13) {
      var searchValue = $('#idSearchKaggle').val();
      $(':focus').blur();
      searchKaggle.search(searchValue, "#kaggle-dataTable", "kaggle", getKaggleConfig().key);
    }
  });

  function getKaggleConfig() {
    return JSON.parse(localStorage.getItem("kaggleConfig") || "{}")
  }

  function setKaggleConfig(key, username) {
    localStorage.setItem("kaggleConfig", JSON.stringify({"key":key, "username":username}));
  }

  $('#kaggleConfigModal').on('shown.bs.modal', function (e) {
    const config = getKaggleConfig();
    $('#modalConfigKey').val(config.key);
    $('#modalUsername').val(config.username);
  });

  $('#saveKaggleConfig').click(function (e) {
    const key = $('#modalConfigKey').val();
    const username = $('#modalUsername').val();
    const password = $('#modalPassword').val();
    const settings = {
      "url": "/dataset/importer/credentials",
      "method": "POST",
      "headers": {
        "Content-Type": "application/json"
      },
      "dataType": "text",
      "data": JSON.stringify({
        "key": key, 
        "username": username, 
        "password": password
      }),
      "timeout": 0,
      "error": (error) => {
          finishSwalLoadingError(error);
      }
    };
    $.ajax(settings).done(function() {
      setKaggleConfig(key, username);
      finishSwalLoadingSuccess("Crendentials saved!");
    });
  });

});