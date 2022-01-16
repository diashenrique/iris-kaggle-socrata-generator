function SearchDataset() {
    const _this = this;
    
    // DataTable instance
    let table = null;
  
    this.createTable = function(data, tableId) {
    }
  
    this.details = function(pArrayIndex, data) {
    }
  
    this.clearDetails = function() {
    }
  
    this.search = function(query, tableId, provider, credentialsKey) {
      if (table && table.destroy) {
        table.destroy();
      }
      // check if query is empty or not
      if (query.length === 0) {
        Swal.fire({
          icon: 'error',
          title: 'Oops...',
          text: 'The search field cannot be empty.',
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
          "provider": provider,
          "terms": query,
          "credentials": credentialsKey
        }),
        "timeout": 0,
        "error": (error) => {
            finishSwalLoadingError(error);
        }
      };
  
      $.ajax(settings).done(function(response) {
        var data = response;
        table = _this.createTable(data, tableId);
  
        $(`${tableId} tbody`).on('click', 'tr', function() {
          _this.clearDetails();
          _this.details(table.row(this).index(), data);
  
          $("#xlarge").modal('show');
        });
  
        $("#download-btn").on('click', function () {
          if ($("#license-dataset").html().length === 0) {
            Swal.fire({
              icon: 'error',
              title: 'Oops...',
              text: 'This dataset is not licensed.',
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
                    "provider": provider,
                    "datasetId": datasetId,
                    "credentials": credentialsKey
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
      });
  
      function getErrorMsg(error) {
        if (error) {
          if (typeof (error) === "object") {
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
    }
  }