module Features
  module CourseMasterMacros
    module Shared
      def fill_editor(name = nil, params = {})
        params[:with] = ' ' if params[:with].nil? || params[:with].blank?
        find("#editor_#{name.to_s.gsub(/ /, '_').underscore} .ql-editor").set(params[:with])
      end
    end
  end
end
