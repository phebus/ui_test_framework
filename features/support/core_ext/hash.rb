class Hash
  def deep_merge(second)
    merger = proc { |_key, v1, v2| v1.is_a?(Hash) && v2.is_a?(Hash) ? v1.merge(v2, &merger) : v2 }
    merge(second, &merger)
  end

  def symbolize_keys
    Hash[map { |(k, v)| [k.to_sym, v] }]
  end

  class << self
    def from_xml(xml_io)
      result = Nokogiri::XML(xml_io)
      { result.root.name.to_sym => xml_node_to_hash(result.root) }
    rescue StandardError => e
      raise "Error converting xml to hash: #{e}"
    end

    def xml_node_to_hash(node)
      return prepare(node.content.to_s) unless node.element?

      # If we are at the root of the document, start the hash
      result_hash = {}
      if node.attributes != {}
        result_hash[:attributes] = {}
        node.attributes.keys.each do |key|
          result_hash[:attributes][node.attributes[key].name.to_sym] = prepare(node.attributes[key].value)
          result_hash[node.attributes[key].name.snake_case.to_sym] = prepare(node.attributes[key].value)
        end
      end

      return result_hash unless node.children.size.positive?

      node.children.each do |child|
        result      = xml_node_to_hash(child)
        child_name  = child.name.snake_case.to_sym

        if child.name == "text" || child.name == "#cdata-section"
          return prepare(result) unless child.next_sibling || child.previous_sibling
        elsif result_hash[child_name]
          if result_hash[child_name].is_a?(Object::Array)
            result_hash[child_name] << prepare(result)
          else
            result_hash[child_name] = [result_hash[child_name]] << prepare(result)
          end
        else
          result_hash[child_name] = prepare(result)
        end
      end

      result_hash
    end

    def prepare(data)
      data.class == String && data.to_i.to_s == data ? data.to_i : data
    end
  end
end
