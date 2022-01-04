/// Description
Class test.integration.util.Dataset01
{

/// Dataset with columns name as numbers and with brackets
XData Dataset01 [ MimeType = text/plain ]
{
Score Type,2015-16,2016-17,2017-18,2018-19,Head Start FACES 2009,EA Validation Study (2013-2014),SPP Goal
Classroom Organization,5.67,5.55,5.96,6.25,4.7,5.26,6
Emotional Support,6.14,6.29,6.38,6.61,5.3,5.96,6
Instructional Support,2.65,3.06,3.42,3.18,2.3,2.34,4.5
Non- FCC Classroom Count,14,32,48,73,,,
}

XData Dataset01Catalog [ MimeType = application/json ]
{
{
  "results" :
    [
      {
        "resource" :
          {
            "name" : "SPP Average CLASS Scores",
            "id" : "fx5g-857s",
            "parent_fxf" : [],
            "description" : "This data set shows the CLASS PreK assessment scores for Seattle Preschool Program (SPP) classrooms overtime, compared to two benchmark programs: Head Start or Early Achievers and SPP's overall goal. The SPP scores only include non-Family Child Care providers.\n\nThe CLASS PreK is an assessment tool used to rate classroom practices in preschool by measuring the interactions between children and adults. It is one of the assessments that contribute to a provider agency’s Early Achievers rating. CLASS is widely used in Pre-K classrooms as it describes multiple dimensions of teaching that are linked to student achievement and development, and it has been validated in over 2,000 classrooms. \n\nThe teaching practices assessed are grouped into three domains: Emotional Support, Classroom Organization and Instructional Support. CLASS uses a 7-point rating scale. A score of 1 or 2 indicates low range quality; a score of 6 or 7 indicates high-quality.\n\nSources for comparison programs' CLASS scores:\n\nAikens, N., Klein, A. K., Tarullo, L., & West, J. (2013). Getting ready for kindergarten: Children's progress during Head Start. FACES 2009 Report.(OPRE Report 2013–21a) Office of Planning. Research and Evaluation, Administration for Children and Families. Washington, D.C.: US Department of Health and Human Services. \n\nChildcare Quality & Early Learning Center for Research & Professional Development (Unpublished). Early Achievers Standards Validation Study. Seattle: University of Washington..",
            "attribution" : null,
            "attribution_link" : null,
            "contact_email" : null,
            "type" : "dataset",
            "updatedAt" : "2020-12-03T23:35:02.000Z",
            "createdAt" : "2019-12-19T18:03:55.000Z",
            "metadata_updated_at" : "2020-12-03T23:35:02.000Z",
            "data_updated_at" : "2019-12-19T18:12:07.000Z",
            "page_views" :
              {
                "page_views_last_week" : 1,
                "page_views_last_month" : 13,
                "page_views_total" : 542,
                "page_views_last_week_log" : 1.0,
                "page_views_last_month_log" : 3.8073549220576037,
                "page_views_total_log" : 9.084808387804362
              },
            "columns_name" :
              [
                "SPP Goal",
                "EA Validation Study (2013-2014)",
                "2018-19",
                "2017-18",
                "2016-17",
                "2015-16",
                "Head Start FACES 2009",
                "Score Type"
              ],
            "columns_field_name" :
              [
                "spp_goal",
                "ea_validation_study_2013",
                "_2018_19",
                "_2017_18",
                "_2016_17",
                "_2015_16",
                "head_start_faces_2009",
                "score_type"
              ],
            "columns_datatype" :
              [
                "Number",
                "Number",
                "Number",
                "Number",
                "Number",
                "Number",
                "Number",
                "Text"
              ],
            "columns_description" : [ "", "", "", "", "", "", "", "" ],
            "columns_format" : [ {}, {}, {}, {}, {}, {}, {}, {} ],
            "download_count" : 639,
            "provenance" : "official",
            "lens_view_type" : "tabular",
            "lens_display_type" : "table",
            "blob_mime_type" : null,
            "hide_from_data_json" : false,
            "publication_date" : "2019-12-19T18:12:07.000Z"
          },
        "classification" :
          {
            "categories" : [ "infrastructure", "health", "politics" ],
            "tags" : [],
            "domain_category" : "Education",
            "domain_tags" :
              [
                "assessment",
                "classroom",
                "deel",
                "department of early learning",
                "early achievers",
                "education",
                "head start",
                "preschool",
                "spp",
                "<spp average class scores>"
              ],
            "domain_metadata" :
              [
                {
                  "key" : "Department_Department",
                  "value" : "Department of Education and Early Learning"
                },
                {
                  "key" : "Refresh-Frequency_Frequency",
                  "value" : "Annually"
                }
              ]
          },
        "metadata" :
          { "domain" : "data.seattle.gov", "license" : "Public Domain" },
        "permalink" : "https://data.seattle.gov/d/fx5g-857s",
        "link" : "https://data.seattle.gov/Education/SPP-Average-CLASS-Scores/fx5g-857s",
        "owner" :
          {
            "id" : "jeh9-kkpm",
            "user_type" : "interactive",
            "display_name" : "Campbell, Holly"
          },
        "creator" :
          {
            "id" : "jeh9-kkpm",
            "user_type" : "interactive",
            "display_name" : "Campbell, Holly"
          }
      }
    ],
  "resultSetSize" : 1,
  "timings" : { "serviceMillis" : 40, "searchMillis" : [ 13, 7 ] },
  "warnings" : []
}
}

}
