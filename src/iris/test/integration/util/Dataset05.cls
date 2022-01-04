/// Description
Class test.integration.util.Dataset05 Extends %RegisteredObject
{

XData Catalog [ MimeType = application/json ]
{
{
  "results" :
    [
      {
        "resource" :
          {
            "name" : "COVID-19 testing by healthcare system",
            "id" : "vzxr-ymut",
            "parent_fxf" : [],
            "description" : "The data set summarizes the number of COVID-19 tests completed among Santa Clara County residents by major healthcare systems in the county. Each ‘test’ or ‘testing incident’ represents at least one specimen tested per person, per day. This does not represent the number of individuals tested, as some people are tested multiple times over time because of the risk of frequent exposure. Source: California Reportable Disease Information Exchange. Data notes: The daily average rate of tests is the daily average number of tests completed over the past 7 days per 100,000 people served by the individual healthcare system. The State of California has defined an initial goal of at least 150 tests per day per 100,000 people. Bay Area County Health Officers set a goal of 200 tests per day per 100,000 people. \n\nThis table was updated for the last time on May 20, 2021.",
            "attribution" : "County of Santa Clara Public Health Department",
            "attribution_link" : null,
            "contact_email" : null,
            "type" : "dataset",
            "updatedAt" : "2021-05-28T21:43:40.000Z",
            "createdAt" : "2020-07-15T19:19:37.000Z",
            "metadata_updated_at" : "2021-05-28T21:43:39.000Z",
            "data_updated_at" : "2021-05-28T21:43:40.000Z",
            "page_views" :
              {
                "page_views_last_week" : 3,
                "page_views_last_month" : 15,
                "page_views_total" : 1037,
                "page_views_last_week_log" : 2.0,
                "page_views_last_month_log" : 4.0,
                "page_views_total_log" : 10.019590728357882
              },
            "columns_name" :
              [
                "people_served",
                "daily_avg_test",
                "daily_avg_rate",
                "total_tests",
                "tests_7days",
                "hcs"
              ],
            "columns_field_name" :
              [
                "number_of_people_served",
                "daily_average_count_in_the",
                "daily_average_rate_in_the",
                "cumulative_number_of_tests",
                "number_of_tests_in_the_past",
                "healthcare_system"
              ],
            "columns_datatype" :
              [ "Number", "Number", "Number", "Number", "Number", "Text" ],
            "columns_description" :
              [
                "Number of People Served",
                "Daily Average Count in the Past Week",
                "Daily Average Rate in the Past Week",
                "Cumulative Number of Tests",
                "Number of Tests in the Past Week",
                "Name of site"
              ],
            "columns_format" : [ {}, {}, {}, {}, {}, {} ],
            "download_count" : 532,
            "provenance" : "official",
            "lens_view_type" : "tabular",
            "lens_display_type" : "table",
            "blob_mime_type" : null,
            "hide_from_data_json" : false,
            "publication_date" : "2020-07-16T15:22:58.000Z"
          },
        "classification" :
          {
            "categories" : [ "public safety" ],
            "tags" : [],
            "domain_category" : "COVID-19",
            "domain_tags" :
              [
                "corona virus",
                "covid",
                "health care",
                "hospital",
                "public health",
                "rate",
                "test"
              ],
            "domain_metadata" : []
          },
        "metadata" : { "domain" : "data.sccgov.org" },
        "permalink" : "https://data.sccgov.org/d/vzxr-ymut",
        "link" : "https://data.sccgov.org/COVID-19/COVID-19-testing-by-healthcare-system/vzxr-ymut",
        "owner" :
          {
            "id" : "rw6b-a4ks",
            "user_type" : "interactive",
            "display_name" : "open.data"
          },
        "creator" :
          {
            "id" : "rw6b-a4ks",
            "user_type" : "interactive",
            "display_name" : "open.data"
          }
      }
    ],
  "resultSetSize" : 1,
  "timings" : { "serviceMillis" : 98, "searchMillis" : [ 43, 39 ] },
  "warnings" : []
}
}

XData CsvFile [ MimeType = text/plain ]
{
hcs,people_served,total_tests,tests_7days,daily_avg_test,daily_avg_rate
County of Santa Clara Health System,300000,911430,5239,748,249
El Camino Health,140000,84898,1551,222,159
HCA Healthcare,264200,34850,696,99,37
Kaiser Permanente,600000,454792,7160,1023,171
PAMF/Sutter Health,426000,94966,1291,184,43
Stanford,329400,384915,10091,1442,438
}

}
