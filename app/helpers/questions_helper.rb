module QuestionsHelper
  def hash_tag(text)
    text.scan(/\B#\w*[a-zA-Zа-яА-Я]+\w*/).to_s.delete '[]",' unless text.nil?
  end
end
