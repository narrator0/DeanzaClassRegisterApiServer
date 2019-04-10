class DeAnzaScraper
  class MyportalScraper
    def scrape(termcode)
      # termcode 201842
      get_courses(termcode)
    end

    private
    def get_courses(termcode)
      response   = RestClient.post(myportal_course_url, payload(termcode))
      html       = Nokogiri::HTML.parse response
      course_row = html.css('.CourseRow')

      courses = Array.new
      course_row.each do |row|
        tds = row.css('td')

        courses.push({
          crn: tds[2].children.first.text,
          status: tds[4].text,
          seats_available: tds[13].text.to_i,
          waitlist_slots_available: tds[14].text.to_i,
          waitlist_slots_capacity: tds[15].text.to_i
        })
      end

      courses
    end

    def myportal_course_url
      'https://ssb-prod.ec.fhda.edu/PROD/fhda_opencourses.P_GetCourseList'
    end

    def payload(termcode)
      { 'termcode': termcode }
    end
  end
end
