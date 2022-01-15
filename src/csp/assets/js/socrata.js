/**
 * DataTables Basic
 */

$(function () {
  'use strict';

  const searchSocrata = new SearchDataset();
  
  searchSocrata.createTable = function(data, tableId) {
    return $(tableId).DataTable({
      "dom": '<"d-flex justify-content-between align-items-center mx-0 row"<"col-sm-12 col-md-6"l><"col-sm-12 col-md-6"f>>t<"d-flex justify-content-between mx-0 row"<"col-sm-12 col-md-6"i><"col-sm-12 col-md-6"p>>',
      "processing": true,
      "data": data.results,
      "columns": [{
        "data": "resource.id"
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
  }

  searchSocrata.details = function(pArrayIndex, data) {
    var dataDetails = data.results[pArrayIndex];

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
      $("#detail-dataTable > tbody").append("<tr><td>" + dataDetails.resource.columns_name[index] + "</td><td>" + dataDetails.resource.columns_field_name[index] + "</td><td>" + dataDetails.resource.columns_datatype[index] + "</td></tr>");
    });
  }

  searchSocrata.clearDetails = function() {
    $("#id-dataset").text("");
    $("#name-dataset").text("");
    $("#description-dataset").text("");
    $("#domain-dataset").text("");
    $("#license-dataset").text("");
    $("#domain-tag-dataset").text("");
    $("#owner-dataset").text("");
    $("#creator-dataset").text("");
    $("#lastweek-dataset").text("");
    $("#lastmonth-dataset").text("");
    $("#viewtotal-dataset").text("");
    $("#download-dataset").text("");
    $("#createdate-dataset").text("");
    $("#updatedate-dataset").text("");
    $("#detail-dataTable > tbody").empty();
  }

  // check for enter key pressed and call search function 
  $('#idSearchSocrata').keypress(function (e) {
    if (e.which == 13) {
      var searchValue = $('#idSearchSocrata').val();
      $(':focus').blur();
      searchSocrata.search(searchValue, "#socrata-dataTable", "socrata");
    }
  });

});