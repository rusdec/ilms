class JsonResponsibleBot
  attr_reader :errors

  def initialize(params = {})
    errors_count = params[:errors_count] || 0
    @errors = []
    errors_count.times { @errors.push(error) }
    class << errors
      def full_messages
        map { |error| error.full_message }
      end
    end
  end

  def persisted?
    false
  end

  protected

  def error
    OpenStruct.new(full_message: "AnyErrorText")
  end
end
