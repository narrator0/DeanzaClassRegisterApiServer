class DeAnzaScraper
  class NewWebsiteScraper
    def scrape(quarter)
      get_courses(department_list, quarter)
    end

    private
    def department_list
      html = get_parsed_html 'https://www.deanza.edu/schedule/'

      dept_options = html.css('#dept-select option')
      dept_options = dept_options.map { |option| option.attr('value') }

      # the first option is just the prompt
      dept_options.shift

      dept_options
    end

    def get_courses(dept_options, quarter)
      courses = Array.new

      dept_options.each do |department|
        puts "Scraping data from #{course_list_url(department, quarter)}..."
        html = get_parsed_html course_list_url(department, quarter)

        # get the table of courses
        table_rows = html.css('.table-schedule tbody tr')

        # there might be some case where nothing is found
        next if table_rows.empty?

        courses.push extract_course_data(table_rows)
      end

      courses
    end

    def get_parsed_html(url)
      Nokogiri::HTML.parse(RestClient::get(url))
    end

    def course_list_url(department, quarter)
      "https://www.deanza.edu/schedule/listings.html?dept=#{department}&t=#{quarter}"
    end

    def numberOfExtraLectures(row)
      rowspan = row.css('td').first.attr('rowspan').to_i
      rowspan == nil ? 0 : rowspan - 1
    end

    def extract_lecture_data(row)
      tds = row.css('td')

      {
        title:      tds[0].children.text,
        days:       tds[1].text,
        times:      tds[2].text,
        instructor: tds[3].children.text,
        location:   tds[4].text
      }
    end

    def extract_course_data(table_rows)
      courses = Array.new

      current_row = 0
      while current_row < table_rows.count
        tds = table_rows[current_row].css('td')

        course = {
          crn:      tds[0].text,
          course:   tds[1].text,
          # section:  tds[2].text,

          'lectures_attributes' => [{
            title:      tds[3].children.text,
            days:       tds[4].text,
            times:      tds[5].text,
            instructor: tds[6].children.text,
            location:   tds[7].text
          }]
        }

        # if it has more than one lectures
        # get lecture data from the next n rows
        numberOfExtraLectures(table_rows[current_row]).times do |num|
          course['lectures_attributes'].push extract_lecture_data(table_rows[current_row + 1])
          current_row += 1
        end

        courses.push course
        current_row += 1
      end

      courses
    end
  end
end
