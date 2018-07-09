module Features
  module CourseMasterMacros
    module CoursesMacros
      def date_format(date)
        date.strftime('%d.%m.%Y')
      end
    end
  end
end
