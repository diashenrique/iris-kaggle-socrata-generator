/// Dataset with geom data
Class test.integration.util.Dataset03 Extends %RegisteredObject
{

XData Catalog [ MimeType = application/json ]
{
{
  "results" :
    [
      {
        "resource" :
          {
            "name" : "Community HealthCare Centers",
            "id" : "n9tp-i3k3",
            "parent_fxf" : [],
            "description" : "The locations represent Community Health Care Centers in the City of Hartford. This data was uploaded July 1, 2014",
            "attribution" : "City of Hartford",
            "attribution_link" : "http://www.hartford.gov",
            "contact_email" : null,
            "type" : "dataset",
            "updatedAt" : "2015-06-13T20:14:57.000Z",
            "createdAt" : "2014-07-01T20:21:10.000Z",
            "metadata_updated_at" : "2015-06-13T20:14:57.000Z",
            "data_updated_at" : "2015-06-13T20:13:27.000Z",
            "page_views" :
              {
                "page_views_last_week" : 2,
                "page_views_last_month" : 8,
                "page_views_total" : 624,
                "page_views_last_week_log" : 1.5849625007211563,
                "page_views_last_month_log" : 3.1699250014423126,
                "page_views_total_log" : 9.287712379549449
              },
            "columns_name" :
              [
                "geom",
                "Name",
                "Location",
                "Phone_Number",
                "Description",
                "Neighborhoods",
                "Zip Codes",
                "Counties",
                "Census 2010 Tracts",
                "geom (state)",
                "geom (city)",
                "geom (address)",
                "geom (zip)"
              ],
            "columns_field_name" :
              [
                "geom",
                "name",
                "location",
                "phone_number",
                "description",
                ":@computed_region_35zh_8fi2",
                ":@computed_region_2vdc_22if",
                ":@computed_region_haf6_6xye",
                ":@computed_region_ugzy_ysqh",
                "geom_state",
                "geom_city",
                "geom_address",
                "geom_zip"
              ],
            "columns_datatype" :
              [
                "Point",
                "Text",
                "Text",
                "Text",
                "Text",
                "Number",
                "Number",
                "Number",
                "Number",
                "Text",
                "Text",
                "Text",
                "Text"
              ],
            "columns_description" :
              [ "", "", "", "", "", "", "", "", "", "", "", "", "" ],
            "columns_format" :
              [ {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {} ],
            "download_count" : 3450,
            "provenance" : "official",
            "lens_view_type" : "tabular",
            "lens_display_type" : "table",
            "blob_mime_type" : null,
            "hide_from_data_json" : false,
            "publication_date" : "2015-06-13T20:14:23.000Z"
          },
        "classification" :
          {
            "categories" : [ "health" ],
            "tags" : [],
            "domain_category" : "Public Health",
            "domain_tags" : [ "hartford", "health", "hospital" ],
            "domain_metadata" : []
          },
        "metadata" :
          {
            "domain" : "data.hartford.gov",
            "license" : "Creative Commons 1.0 Universal (Public Domain Dedication)"
          },
        "permalink" : "https://data.hartford.gov/d/n9tp-i3k3",
        "link" : "https://data.hartford.gov/Public-Health/Community-HealthCare-Centers/n9tp-i3k3",
        "owner" :
          {
            "id" : "cdqe-xcn5",
            "user_type" : "interactive",
            "display_name" : "Brett"
          },
        "creator" :
          {
            "id" : "cdqe-xcn5",
            "user_type" : "interactive",
            "display_name" : "Brett"
          }
      }
    ],
  "resultSetSize" : 1,
  "timings" : { "serviceMillis" : 49, "searchMillis" : [ 12, 8 ] },
  "warnings" : []
}
}

XData CsvFile [ MimeType = text/plain ]
{
Name,Description,Location,Phone_Number,geom
"Community Health Services, Inc.","Community Health Services, Inc.",500 ALBANY AV,(860) 249-9625,"(41.7778861525514, -72.6849759475512)"
"Community Health Services, Inc.",Clinical Services - Adult Medicine,500 ALBANY AV,(860) 808-8607,"(41.7778861525514, -72.6849759475512)"
"Community Health Services, Inc.",Clinical Services - Adolescent Medicine,500 ALBANY AV,(860) 808-8720,"(41.7778861525514, -72.6849759475512)"
"Community Health Services, Inc.",Clinical Services - Behavioral Health,500 ALBANY AV,(860) 808-8796,"(41.7778861525514, -72.6849759475512)"
"Community Health Services, Inc.",Clinical Services - Pediatrics,500 ALBANY AV,(860) 808-8720,"(41.7778861525514, -72.6849759475512)"
"Community Health Services, Inc.",Clinical Services - Dental Program,500 ALBANY AV,(860) 808-8745,"(41.7778861525514, -72.6849759475512)"
"Community Health Services, Inc.",Support Service - Revenue Management,500 ALBANY AV,(860) 808-8785,"(41.7778861525514, -72.6849759475512)"
"Community Health Services, Inc.",Support Services - Medical Records,500 ALBANY AV,(860) 808-8770,"(41.7778861525514, -72.6849759475512)"
"Community Health Services, Inc.",Support Services - Medicaid Outreach Worker/Access to Care,500 ALBANY AV,(860) 808-8786,"(41.7778861525514, -72.6849759475512)"
"Charter Oak Health Center, Inc.","Charter Oak Health Center, Inc.",21 GRAND ST,(860) 550-7500,"(41.759250096054, -72.6855334560653)"
"Charter Oak Health Center, Inc.","Satellite - Charter Oak Health Center, Inc.",401 NEW BRITAIN AV,(860) 550-7500,"(41.7399713668717, -72.6960099183982)"
"Charter Oak Health Center, Inc.",Satellite - Albert I Prince Regional Vocational Technical School - School-based Health Center,401 FLATBUSH AV,(860) 951-7112,"(41.7428410122877, -72.7069599191928)"
"Charter Oak Health Center, Inc.",Satellite - COHC at CCMC (Charter Oak Health Center at Connecticut Children's Medical Center,282 WASHINGTON ST,(860) 545-9300,"(41.7538748671282, -72.6821781354167)"
Asylum Hill Family Practice,Asylum Hill Family Practice,99 WOODLAND ST,(860) 714-4212,"(41.7744029976458, -72.7001641101977)"
Hartford Homeless Shelters/Clinics,South Park Inn,75 MAIN ST,(860) 724-0071,"(41.7565084379224, -72.6761720915547)"
Hartford Homeless Shelters/Clinics,Immaculate Conception Shelter,574 PARK ST,(860) 724-4823,"(41.7581555896394, -72.6863665241152)"
Hartford Homeless Shelters/Clinics,McKinney Shelter,34 HUYSHOPE AV,(860) 722-6922 CONTACT: JOSE VEGA CELL: (860) 214-1905,"(41.7577173268238, -72.6661760481738)"
Hartford Homeless Shelters/Clinics,Open Hearth,437 SHELDON ST,(860) 525-3447,"(41.7583511520621, -72.6660322866926)"
Hartford Homeless Shelters/Clinics,Mercy Housing and Shelter,118 MAIN ST,(860) 560-4100,"(41.7569523265891, -72.6751087262975)"
Hartford Homeless Shelters/Clinics,House of Bread,27 CHESTNUT ST,(860) 724-1061,"(41.7733529446348, -72.6808159710957)"
Hartford Homeless Shelters/Clinics,Loaves and Fishes Ministries,120 SIGOURNEY ST,(860) 524-1730,"(41.7686148444475, -72.6931780925149)"
Hartford Homeless Shelters/Clinics,YWCA,135 BROAD ST,(860) 525-1163 ext. 291,"(41.7674999763613, -72.6865809368271)"
Hartford Area Hospitals,Hartford Hospital,80 SEYMOUR ST,(860) 545-5000,"(41.7538186126512, -72.6798876605316)"
Hartford Area Hospitals,Connecticut Children Medical Center (CCMC),282 WASHINGTON ST,(860) 545-9000,"(41.7538748671282, -72.6821781354167)"
Hartford Area Hospitals,Saint Francis Hospital and Medical Center,114 WOODLAND ST,(860) 714-4000 (877) 783-7262,"(41.7755247845828, -72.6987481375234)"
Hartford Area Hospitals,Mount Sinai Rehabilitation Hospital,490 BLUE HILLS AV,(860) 714-3500 (800) 789-7709,"(41.7995265996867, -72.6939284258752)"
}

}
