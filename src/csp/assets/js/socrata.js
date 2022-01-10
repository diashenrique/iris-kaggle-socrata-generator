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
      }]
    });
    $('div.head-label').html('<h6 class="mb-0">Kick start your next project 🚀</h6>');

    $('#socrata-dataTable tbody').on('click', 'tr', function () {
      details(table.row(this).index());

      $("#xlarge").modal('show');
    });


    function details(pArrayIndex) {
      var dataDetails = data[pArrayIndex];

      $("#id-dataset").text(dataDetails.resource.id);
      $("#name-dataset").text(dataDetails.resource.name);
      $("#description-dataset").text(dataDetails.resource.description);
      $("#domain-dataset").text(dataDetails.metadata.domain);
      $("#license-dataset").text(dataDetails.metadata.license);
      $("#domain-tag-dataset").text(dataDetails.classification.domain_tags.toString());
      $("#owner-dataset").text(dataDetails.owner.display_name);
      $("#creator-dataset").text(dataDetails.creator.display_name);
      $("#lastweek-dataset").text(dataDetails.resource.page_views.page_views_last_week);
      $("#lastmonth-dataset").text(dataDetails.resource.page_views.page_views_last_month);
      $("#viewtotal-dataset").text(dataDetails.resource.page_views.page_views_total);
      $("#download-dataset").text(dataDetails.resource.download_count);
      $("#createdate-dataset").text(dataDetails.resource.createdAt);
      $("#updatedate-dataset").text(dataDetails.resource.updatedAt);

      dataDetails.resource.columns_name.forEach(function (item, index) {
        $("#detail-dataTable > tbody").append("<tr><td>"+ dataDetails.resource.columns_name[index] +"</td><td>" + dataDetails.resource.columns_field_name[index] + "</td><td>" + dataDetails.resource.columns_datatype[index] + "</td></tr>"); 
      });
    }

    $("#download-btn").on('click', function () {
      // alert($("#id-dataset").html());
      const datasetId = $("#id-dataset").html()
      var settings = {
        "url": "/dataset/importer/import",
        "method": "POST",
        "timeout": 0,
        "headers": {
          "Content-Type": "application/json"
        },
        "data": JSON.stringify({"provider":"socrata","datasetId":datasetId}),
        "error": function(error){
          alert(JSON.stringify(error));
        }
      };
      $.ajax(settings).done(function (response) {
        alert(JSON.stringify(response))
      });
    });

  });
});