# Standard output:
# OpenStruct.new({foo: 'bar'}).to_json
# => "{\"table\":{\"foo\":\"bar\"}}"
#
# Monkey patching output:
# OpenStruct.new({foo: 'bar'}).to_json
# => "{\"foo\":\"bar\"}"
class OpenStruct
  def as_json(options = nil)
    @table.as_json(options)
  end
end
