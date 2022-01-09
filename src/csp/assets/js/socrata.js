/**
 * DataTables Basic
 */

$(function () {
  'use strict';

  var settings = {
    "url": "https://api.us.socrata.com/api/catalog/v1?only=dataset&q=healthcare",
    "method": "GET",
    "timeout": 0,
  };

  $.ajax(settings).done(function (response) {
    console.log(response.results);

    var data = response.results;

    /*
    for (var i in data) {
      console.log(i, data[i].resource.columns_name, data[i].resource.columns_field_name, data[i].resource.columns_datatype);
    }
    */

    var table = $("#socrata-dataTable").DataTable({
      "dom": '<"d-flex justify-content-between align-items-center mx-0 row"<"col-sm-12 col-md-6"l><"col-sm-12 col-md-6"f>>t<"d-flex justify-content-between mx-0 row"<"col-sm-12 col-md-6"i><"col-sm-12 col-md-6"p>>',
      "processing": true,
      "data": data,
      "columns": [{
        "data": "resource.id",
        "render": function (data, type, row, meta) {
          if (type === 'display') {
            data = '<a href="' + data + '" target="_blank"><span class="font-weight-bold">' + data + '</span></a>';
          }
          return data;
        }
      }, {
        "data": "resource.name"
      }, {
        "data": "resource.page_views.page_views_total"
      }, {
        "data": "resource.download_count"
      }, {
        "data": "metadata.license",
        "defaultContent": ""
      }, {
        "data": "permalink",
        "render": function (data, type, row, meta) {
          if (type === 'display') {
            data = '<a href="' + row.permalink + '" target="_blank"><span class="font-weight-bold">' + data + '</span></a>';
          }
          return data;
        }
      }],
      dom: '<"card-header border-bottom p-1"<"head-label"><"dt-action-buttons text-end"B>><"d-flex justify-content-between align-items-center mx-0 row"<"col-sm-12 col-md-6"l><"col-sm-12 col-md-6"f>>t<"d-flex justify-content-between mx-0 row"<"col-sm-12 col-md-6"i><"col-sm-12 col-md-6"p>>',
      lengthMenu: [10, 25, 50, 75, 100],
      buttons: [{
        text: feather.icons['download-cloud'].toSvg({
          class: 'me-50 font-small-4'
        }) + 'Download',
        className: 'download-btn btn btn-primary'
      }]
    });
    $('div.head-label').html('<h6 class="mb-0">Kick start your next project 🚀</h6>');

    $('#socrata-dataTable tbody').on('click', 'tr', function () {
      alert('Row index: ' + table.row(this).index());
    });

    $(".download-btn").on('click', function () {
      alert("Download");
    });

  });
});