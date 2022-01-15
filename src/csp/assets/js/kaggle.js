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
    var dataDetails = data[pArrayIndex];

    $("#id-dataset").text(dataDetails.id);

    // dataDetails.resource.columns_name.forEach(function (item, index) {
    //   $("#detail-dataTable > tbody").append("<tr><td>" + dataDetails.resource.columns_name[index] + "</td><td>" + dataDetails.resource.columns_field_name[index] + "</td><td>" + dataDetails.resource.columns_datatype[index] + "</td></tr>");
    // });
  }

  searchKaggle.clearDetails = function() {
    $("#id-dataset").text("");
  }

  // check for enter key pressed and call search function 
  $('#idSearchKaggle').keypress(function (e) {
    if (e.which == 13) {
      var searchValue = $('#idSearchKaggle').val();
      $(':focus').blur();
      searchKaggle.search(searchValue, "#kaggle-dataTable", "kaggle", "kaggle");
    }
  });

});