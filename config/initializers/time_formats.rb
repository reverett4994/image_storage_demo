date_formats = {
  concise: '%B %e, %Y' # January 28, 2015
}

Time::DATE_FORMATS.merge! date_formats
Date::DATE_FORMATS.merge! date_formats
