class GoogleHomePage < BasePage
  page_url 'http://google.com'

  text_field :search_box, id: 'lst-ib'

  button :search_button, name: 'btnK'

  def search(term)
    search_box_element.send_keys term
    send_keys :escape
    search_button
  end
end
