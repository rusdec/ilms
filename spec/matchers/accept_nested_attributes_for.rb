# http://www.rubyexample.com/snippet/ruby/spec_helperrb_pareshgupta_ruby
#
# Use:
# it do
#   should accept_but_reject_nested_attributes_for(:association_name)
#     .and_accept({valid_values => true})
#     .but_reject({ :reject_if_nil => nil })
# end

RSpec::Matchers.define :accept_but_reject_nested_attributes_for do |association|
  match do |model|
    @model = model
    @nested_att_present = model.respond_to?("#{association}_attributes=".to_sym)
    if @nested_att_present && @reject.present?
      model.send("#{association}_attributes=".to_sym, @reject)
      @not_rejecteds = model.send("#{association}")
    end
    @nested_att_present && ( @reject.empty? || @not_rejecteds.empty? )
  end

  failure_message do
    messages = []
    @not_rejecteds.each do |not_rejected|
      messages << "reject values #{not_rejected.inspect} for association #{association}"
    end
    "expected #{@model.class} to " + messages.join(", ")
  end

  description do
    desc = "reject if attributes are #{@reject.inspect}"
  end

  chain :reject do |reject|
    reject = [reject] unless reject.is_a?(Array)
    @reject = reject
  end
end
