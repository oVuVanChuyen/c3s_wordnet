require 'rwordnet'
class WordnetService
  def self.search(keyword)
    lemmas = WordNet::Lemma.find_all(keyword.downcase)
    synsets = lemmas.map { |lemma| lemma.synsets }
    words = synsets.flatten
  end
end
