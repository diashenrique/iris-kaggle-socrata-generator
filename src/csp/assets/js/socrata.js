/**
 * DataTables Basic
 */

$(function () {
  'use strict';

  // DataTable instance
  let table = null;

  function searchSocrata(query) {
  
    // check if query is empty or not
    if (query.length === 0) {
      Swal.fire({
        icon: 'error',
        title: 'Oops...',
        text: 'The search field cannot be empty.',
        //footer: '<a href=' + a + '>Please contact the owner to get a license.</a>',
        customClass: {
          confirmButton: 'btn btn-primary'
        },
        buttonsStyling: false
      });

      return;
    }

    var settings = {
      "url": "/dataset/importer/search",
      "method": "POST",
      "headers": {
        "Content-Type": "application/json"
      },
      "data": JSON.stringify({
        "provider": "socrata", 
        "terms": query
      }),
      "timeout": 0,
    };
  
    $.ajax(settings).done(function (response) {
      console.log(response.results);
  
      var data = response.results;
  
      table = $("#socrata-dataTable").DataTable({
        "dom": '<"d-flex justify-content-between align-items-center mx-0 row"<"col-sm-12 col-md-6"l><"col-sm-12 col-md-6"f>>t<"d-flex justify-content-between mx-0 row"<"col-sm-12 col-md-6"i><"col-sm-12 col-md-6"p>>',
        "processing": true,
        "data": data,
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
      $('div.head-label').html('<h6 class="mb-0">Kick start your next project 🚀</h6>');
  
      $('#socrata-dataTable tbody').on('click', 'tr', function () {
        clearDetails();
        details(table.row(this).index());
  
        $("#xlarge").modal('show');
      });
  
  
      function details(pArrayIndex) {
        let license = "";
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
          $("#detail-dataTable > tbody").append("<tr><td>" + dataDetails.resource.columns_name[index] + "</td><td>" + dataDetails.resource.columns_field_name[index] + "</td><td>" + dataDetails.resource.columns_datatype[index] + "</td></tr>");
        });
      }
      
      function finishSwalLoadingSuccess(response) {
        Swal.fire(
          "Success!",
          getSuccessMsg(response),
          "success"
        );
      }
      
      function finishSwalLoadingError(error) {
        Swal.fire(
          "Internal Error",
          getErrorMsg(error),
          "error"
        );
      }
  
      $("#download-btn").on('click', function () {
        
        if ($("#license-dataset").html().length === 0) {
          Swal.fire({
            icon: 'error',
            title: 'Oops...',
            text: 'This dataset is not licensed.',
            //footer: '<a href=' + a + '>Please contact the owner to get a license.</a>',
            customClass: {
              confirmButton: 'btn btn-primary'
            },
            buttonsStyling: false
          });
  
        } else {
  
          Swal.fire({
            title: 'Downloading...',
            html: 'Your dataset in on the way!<br/><div id="progressDiv"></div>',
            showConfirmButton: false,
            didOpen: () => {
              Swal.showLoading();
              const datasetId = $("#id-dataset").html()
              var settings = {
                "url": "/dataset/importer/import",
                "method": "POST",
                "timeout": 0,
                "headers": {
                  "Content-Type": "application/json"
                },
                "data": JSON.stringify({
                  "provider": "socrata",
                  "datasetId": datasetId
                }),
                "error": function (error) {
                  finishSwalLoadingError(error);
                }
              };
              return $.ajax(settings).done(function (response) {
                const progressInfoId = response.ProgressInfoKey;
                const intId = setInterval(() => {
                  $.ajax({
                    "url": `/dataset/importer/import/status/${progressInfoId}`,
                    "method": "GET",
                    "timeout": 0,
                    "headers": {
                      "Content-Type": "application/json"
                    },
                    "error": function (error) {
                      clearInterval(intId);
                      finishSwalLoadingError(error);
                    }
                  }).done(response => {
                    const el = Swal.getHtmlContainer().querySelector('#progressDiv');
                    el.textContent = `${response.status}`;
                    if (response.status === "success") {
                      clearInterval(intId);
                      finishSwalLoadingSuccess(response.data);
                    } else if (response.status === "error") {
                      clearInterval(intId);
                      finishSwalLoadingError(response.data);
                    }
                  });
                }, 1000);
              });
            }
          });
        }
      });
  
      function getErrorMsg(error) {
        if (error) {
          if (typeof(error) === "object") {
            if (error.status && error.status.toString() === "401") {
              return error.statusText;
            } else if (error.responseJSON && error.responseJSON.summary) {
              return error.responseJSON.summary;
            }
          } else {
            return error;
          }
        }
        return "";
      }
  
      function getSuccessMsg(response) {
        if (response) {
          if (response.className) {
            return `There was imported <b>${response.records} records</b> on class <b>${response.className}</b>.`;
          }
        }
        return "";
      }
  
      function clearDetails() {
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
    });
  }

  // check for enter key pressed and call search function 

  $('#idSearchSocrata').keypress(function (e) {
    if (e.which == 13) {
      var searchValue=$('#idSearchSocrata').val();
      //alert(searchValue);
      $(':focus').blur()
      
      if (table && table.destroy) {
        table.destroy();
      }
      searchSocrata(searchValue);
    }
   });   

});