class BasePage
  include PageObject

  def select_by_keyword(element, keyword, attribute = :id)
    element.when_present
    @browser.element(css: "select[#{attribute}='#{element.attribute(attribute)}'] option[value='#{keyword}']").click
  end

  def fill_elements(**elements)
    elements.each do |name, value|
      case send("#{name}_element")
      when PageObject::Elements::SelectList
        select_by_keyword(send("#{name}_element"), value)
      when PageObject::Elements::TextField
        send("#{name}=", value)
      else
        puts 'Parameter did not match any expected element types'
      end
    end
  end

  def wait_for_animation
    Framework::Core.wait_until(10, 'Waiting for animations to finish') do
      execute_script('return jQuery(":animated").length').zero?
    end
  end
end
