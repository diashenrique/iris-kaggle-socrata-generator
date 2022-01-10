/// Dataset with line break in header
Class test.integration.util.Dataset02 Extends %RegisteredObject
{

XData Catalog [ MimeType = application/json ]
{
{
  "results" :
    [
      {
        "resource" :
          {
            "name" : "2014 - 2015 Parent School Survey Data",
            "id" : "hdpu-mku8",
            "parent_fxf" : [],
            "description" : "2015 NYC School Survey parent data for all schools\r\nTo understand the perceptions of families, students, and teachers regarding their school.  School leaders use feedback from the survey to reflect and make improvements to schools and programs. Also, results from the survey used to help measure school quality. \r\nEach year, all parents, teachers, and students in grades 6-12 take the NYC School Survey. The survey is aligned to the DOE's Framework for Great Schools. It is designed to collect important information about each school's ability to support student success.",
            "attribution" : "NYC Department of Education",
            "attribution_link" : null,
            "contact_email" : null,
            "type" : "dataset",
            "updatedAt" : "2021-07-09T18:33:54.000Z",
            "createdAt" : "2019-01-03T18:25:48.000Z",
            "metadata_updated_at" : "2021-07-09T18:33:54.000Z",
            "data_updated_at" : "2019-01-03T18:45:44.000Z",
            "page_views" :
              {
                "page_views_last_week" : 2,
                "page_views_last_month" : 6,
                "page_views_total" : 328,
                "page_views_last_week_log" : 1.5849625007211563,
                "page_views_last_month_log" : 2.807354922057604,
                "page_views_total_log" : 8.361943773735241
              },
            "columns_name" :
              [
                "Total Parent \nResponse Rate",
                "School Name",
                "DBN",
                "Total Student Response Rate",
                "Total Teacher Response Rate"
              ],
            "columns_field_name" :
              [
                "total_parent_response_rate",
                "school_name",
                "dbn",
                "total_student_response_rate",
                "total_teacher_response_rate"
              ],
            "columns_datatype" : [ "Text", "Text", "Text", "Text", "Text" ],
            "columns_description" : [ "", "", "", "", "" ],
            "columns_format" : [ {}, {}, {}, {}, {} ],
            "download_count" : 479,
            "provenance" : "official",
            "lens_view_type" : "tabular",
            "lens_display_type" : "table",
            "blob_mime_type" : null,
            "hide_from_data_json" : false,
            "publication_date" : "2019-01-03T18:45:44.000Z"
          },
        "classification" :
          {
            "categories" : [ "education" ],
            "tags" : [],
            "domain_category" : "Education",
            "domain_tags" : [],
            "domain_metadata" :
              [
                { "key" : "Update_Automation", "value" : "No" },
                { "key" : "Update_Date-Made-Public", "value" : "1/3/2019" },
                {
                  "key" : "Update_Update-Frequency",
                  "value" : "Historical Data"
                },
                {
                  "key" : "Dataset-Information_Agency",
                  "value" : "Department of Education (DOE)"
                }
              ]
          },
        "metadata" : { "domain" : "data.cityofnewyork.us" },
        "permalink" : "https://data.cityofnewyork.us/d/hdpu-mku8",
        "link" : "https://data.cityofnewyork.us/Education/2014-2015-Parent-School-Survey-Data/hdpu-mku8",
        "owner" :
          {
            "id" : "ftn3-awiu",
            "user_type" : "interactive",
            "display_name" : "Vaughan Coleman"
          },
        "creator" :
          {
            "id" : "ftn3-awiu",
            "user_type" : "interactive",
            "display_name" : "Vaughan Coleman"
          }
      }
    ],
  "resultSetSize" : 1,
  "timings" : { "serviceMillis" : 102, "searchMillis" : [ 13, 44 ] },
  "warnings" : []
}
}

/// No data was saved due this dataset has no license definied
XData CsvFile [ MimeType = text/plain ]
{
DBN,School Name,"Total Parent 
Response Rate",Total Teacher Response Rate,Total Student Response Rate
dbn,,rr_p,rr_t,rr_s
}

}
