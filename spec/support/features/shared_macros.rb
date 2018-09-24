module Features
  module SharedMacros
    def format_date(date)
      date.strftime('%d.%m.%Y')
    end

    def click_edit_remote_link
      first(:css, '.remote-links a.edit').click
    end

    def click_destory_remote_link
      first(:css, '.remote-links a.destroy').click
    end
  end
end
