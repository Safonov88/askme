module QuestionsHelper
  def hash_tag(text)
    a = ""
    a = text.scan(/\B#\w*[a-zA-Zа-яА-Я]+\w*/).to_s unless text.nil?
    a.delete '[]",'
  end
end
