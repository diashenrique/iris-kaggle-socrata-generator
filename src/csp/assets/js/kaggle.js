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
        "data": "totalBytes",
        "render": function (data, type, row, meta) {
          let label = "";
          if (type === 'display') {
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
          }
          return label;
        }
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

    // const response = {
    //   "datasetFiles": [
    //     {
    //       "ref": "KaggleV2-May-2016.csv",
    //       "datasetRef": "joniarroba/noshowappointments",
    //       "ownerRef": "joniarroba",
    //       "name": "KaggleV2-May-2016.csv",
    //       "creationDate": "2017-08-20T23:49:38.6Z",
    //       "description": null,
    //       "fileType": ".csv",
    //       "url": "https://www.kaggle.com/",
    //       "totalBytes": 10739535,
    //       "columns": [
    //         {
    //           "order": 0,
    //           "name": "PatientId",
    //           "type": "Uuid",
    //           "originalType": "",
    //           "description": null
    //         },
    //         {
    //           "order": 1,
    //           "name": "AppointmentID",
    //           "type": "Uuid",
    //           "originalType": "",
    //           "description": null
    //         },
    //         {
    //           "order": 2,
    //           "name": "Gender",
    //           "type": "String",
    //           "originalType": "",
    //           "description": null
    //         },
    //         {
    //           "order": 3,
    //           "name": "ScheduledDay",
    //           "type": "DateTime",
    //           "originalType": "",
    //           "description": null
    //         },
    //         {
    //           "order": 4,
    //           "name": "AppointmentDay",
    //           "type": "DateTime",
    //           "originalType": "",
    //           "description": null
    //         },
    //         {
    //           "order": 5,
    //           "name": "Age",
    //           "type": "Uuid",
    //           "originalType": "",
    //           "description": null
    //         },
    //         {
    //           "order": 6,
    //           "name": "Neighbourhood",
    //           "type": "String",
    //           "originalType": "",
    //           "description": null
    //         },
    //         {
    //           "order": 7,
    //           "name": "Scholarship",
    //           "type": "Uuid",
    //           "originalType": "",
    //           "description": null
    //         },
    //         {
    //           "order": 8,
    //           "name": "Hipertension",
    //           "type": "Uuid",
    //           "originalType": "",
    //           "description": null
    //         },
    //         {
    //           "order": 9,
    //           "name": "Diabetes",
    //           "type": "Uuid",
    //           "originalType": "",
    //           "description": null
    //         },
    //         {
    //           "order": 10,
    //           "name": "Alcoholism",
    //           "type": "Uuid",
    //           "originalType": "",
    //           "description": null
    //         },
    //         {
    //           "order": 11,
    //           "name": "Handcap",
    //           "type": "Uuid",
    //           "originalType": "",
    //           "description": null
    //         },
    //         {
    //           "order": 12,
    //           "name": "SMS_received",
    //           "type": "Uuid",
    //           "originalType": "",
    //           "description": null
    //         },
    //         {
    //           "order": 13,
    //           "name": "No-show",
    //           "type": "Boolean",
    //           "originalType": "",
    //           "description": null
    //         }
    //       ]
    //     }
    //   ],
    //   "errorMessage": null
    // }
    // setDetails(response);
  }

  function setDetails(response) {
    var dataDetails = response.datasetFiles[0];
    $("#id-dataset").text(dataDetails.ref);
  }

  searchKaggle.clearDetails = function() {
    $("#id-dataset").text("");
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