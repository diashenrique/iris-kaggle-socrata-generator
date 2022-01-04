/// Description
Class test.integration.util.Dataset04 Extends %RegisteredObject
{

XData Catalog [ MimeType = application/json ]
{
{
  "results" :
    [
      {
        "resource" :
          {
            "name" : "Access to Healthcare",
            "id" : "emzy-79p5",
            "parent_fxf" : [],
            "description" : "Percent of population 18-64 years of age with no health insurance coverage by race/ethnicity in New Orleans and the United States",
            "attribution" : "U.S. Census",
            "attribution_link" : null,
            "contact_email" : null,
            "type" : "dataset",
            "updatedAt" : "2018-04-05T17:45:28.000Z",
            "createdAt" : "2018-02-21T20:31:22.000Z",
            "metadata_updated_at" : "2018-04-05T17:45:28.000Z",
            "data_updated_at" : "2018-04-02T19:47:31.000Z",
            "page_views" :
              {
                "page_views_last_week" : 2,
                "page_views_last_month" : 13,
                "page_views_total" : 273,
                "page_views_last_week_log" : 1.5849625007211563,
                "page_views_last_month_log" : 3.8073549220576037,
                "page_views_total_log" : 8.098032082960527
              },
            "columns_name" :
              [ "Year", "Geography", "Percent without coverage", "Race" ],
            "columns_field_name" :
              [ "year", "geography", "percent_without_coverage", "race" ],
            "columns_datatype" : [ "Text", "Text", "Number", "Text" ],
            "columns_description" : [ "", "", "", "" ],
            "columns_format" :
              [
                { "decimalSeparator" : ".", "groupSeparator" : "," },
                {},
                {
                  "precisionStyle" : "percentage",
                  "percentScale" : "100",
                  "decimalSeparator" : ".",
                  "groupSeparator" : ","
                },
                {}
              ],
            "download_count" : 47,
            "provenance" : "official",
            "lens_view_type" : "tabular",
            "lens_display_type" : "table",
            "blob_mime_type" : null,
            "hide_from_data_json" : false,
            "publication_date" : "2018-04-02T19:48:27.000Z"
          },
        "classification" :
          {
            "categories" : [],
            "tags" : [],
            "domain_category" : "Health",
            "domain_tags" : [
                              "health",
                              "inclusive growth",
                              "prosperity index"
                            ],
            "domain_metadata" : []
          },
        "metadata" :
          {
            "domain" : "data.datacenterresearch.org",
            "license" : "Public Domain"
          },
        "permalink" : "https://data.datacenterresearch.org/d/emzy-79p5",
        "link" : "https://data.datacenterresearch.org/Health/Access-to-Healthcare/emzy-79p5",
        "owner" :
          {
            "id" : "t8ta-svdx",
            "user_type" : "interactive",
            "display_name" : "Bernardo Espinosa"
          },
        "creator" :
          {
            "id" : "t8ta-svdx",
            "user_type" : "interactive",
            "display_name" : "Bernardo Espinosa"
          }
      }
    ],
  "resultSetSize" : 1,
  "timings" : { "serviceMillis" : 70, "searchMillis" : [ 12, 31 ] },
  "warnings" : []
}
}

XData CsvFile [ MimeType = text/plain ]
{
Geography,Year,Race,Percent without coverage
New Orleans,2009,Black or African American,36.51
New Orleans,2009,"White, not Hispanic",20.51
New Orleans,2009,Hispanic or Latino,53.76
New Orleans,2010,Black or African American,30.27
New Orleans,2010,"White, not Hispanic",15.79
New Orleans,2010,Hispanic or Latino,53.88
New Orleans,2011,Black or African American,31.42
New Orleans,2011,"White, not Hispanic",17.64
New Orleans,2011,Hispanic or Latino,46.13
New Orleans,2012,Black or African American,28.57
New Orleans,2012,"White, not Hispanic",14.75
New Orleans,2012,Hispanic or Latino,45.82
New Orleans,2013,Black or African American,25.52
New Orleans,2013,"White, not Hispanic",13.56
New Orleans,2013,Hispanic or Latino,47.2
New Orleans,2014,Black or African American,25.06
New Orleans,2014,"White, not Hispanic",12.56
New Orleans,2014,Hispanic or Latino,40.15
New Orleans,2015,Black or African American,18.46
New Orleans,2015,"White, not Hispanic",10
New Orleans,2015,Hispanic or Latino,27.96
New Orleans,2016,Black or African American,13.69
New Orleans,2016,"White, not Hispanic",9.84
New Orleans,2016,Hispanic or Latino,33.1
United States,2009,Black or African American,25.15
United States,2009,"White, not Hispanic",14.8
United States,2009,Hispanic or Latino,42.36
United States,2010,Black or African American,25.64
United States,2010,"White, not Hispanic",15.33
United States,2010,Hispanic or Latino,42.87
United States,2011,Black or African American,25.02
United States,2011,"White, not Hispanic",15.02
United States,2011,Hispanic or Latino,41.61
United States,2012,Black or African American,24.46
United States,2012,"White, not Hispanic",14.71
United States,2012,Hispanic or Latino,40.75
United States,2013,Black or African American,24.13
United States,2013,"White, not Hispanic",14.43
United States,2013,Hispanic or Latino,39.9
United States,2014,Black or African American,19.16
United States,2014,"White, not Hispanic",11.37
United States,2014,Hispanic or Latino,32.78
United States,2015,Black or African American,15.44
United States,2015,"White, not Hispanic",8.87
United States,2015,Hispanic or Latino,27.53
United States,2016,Black or African American,13.66
United States,2016,"White, not Hispanic",8.1
United States,2016,Hispanic or Latino,25.4
}

}
