module HasDate
  extend ActiveSupport::Concern

  included do
    def updated_at
      format_date(object.updated_at)
    end

    def created_at
      format_date(object.created_at)
    end

    protected

    def format_date(date)
      date.strftime('%d.%m.%Y')
    end
  end
end
