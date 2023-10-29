# Клас "Parser" відповідає за парсинг інформації з веб-сторінок.

require './item.rb'

class Parser
  # Ініціалізує новий екземпляр класу "Parser" з вказаною URL та налаштуваннями додатку.
  #
  # @param url [String] URL-адреса веб-сторінки для парсингу.
  # @param app [MainApplication] Посилання на головний додаток для отримання налаштувань фільтрації.
  def initialize(url, app)
    html = URI.open(url)
    @doc = Nokogiri::HTML(html)
    @condition = app.filter_settings
  end

  # "parse_items" виконує парсинг веб-сторінки на основі вказаних умов фільтрації.

  # @return [Array] Масив об'єктів "Item" з інформацією про товари, які відповідають умовам фільтрації.
  def parse_items
    # Вибір всіх елементів на сторінці <div class='content'>.
    elements = @doc.css('div.content')
    
    # Створення порожнього масиву для зберігання об'єктів "Item".
    cars = []
  
    # Ітерація через кожен знайдений елемент для отримання інформації.
    elements.each do |content|
      # Отримання назви автомобіля.
      car_name = content.css('span.blue.bold').text
  
      # Перевірка, чи назва автомобіля відповідає умовам фільтрації, використовуючи регулярний вираз.
      if Regexp.new(@condition, Regexp::IGNORECASE).match(car_name)
        # Отримання року виробництва автомобіля.
        car_year = content.css('a > span').text
  
        # Отримання характеристик автомобіля.
        car_characteristics = content.css('div.generation').text
  
        # Отримання ціни автомобіля.
        car_price = content.css('span.bold.size22.green[data-currency="USD"]').text
  
        # Створення об'єкта "Item" з отриманою інформацією та додавання його до масиву "cars".
        car_info = Item.new(car_name, car_year, car_characteristics, car_price)
        cars << car_info
      end
    end
  
    # Повертає масив об'єктів "Item", які відповідають умовам фільтрації.
    cars
  end
  
end
