# frozen_string_literal: true

module NattoWrap
  # NOTE: https://taku910.github.io/mecab/
  class MeCabModel
    attr_accessor :word, :word_class,
                  :word_subclass1, :word_subclass2, :word_subclass3,
                  :conjugation1, :conjugation2,
                  :prototype, :reading, :pronunciation

    def initialize(word: nil, word_class: nil,
                   word_subclass1: nil, word_subclass2: nil, word_subclass3: nil,
                   conjugation1: nil, conjugation2: nil,
                   prototype: nil, reading: nil, pronunciation: nil)
      @word = word
      @word_class = get_object(word_class)
      @word_subclass1 = get_object(word_subclass1)
      @word_subclass2 = get_object(word_subclass2)
      @word_subclass3 = get_object(word_subclass3)
      @conjugation1 = get_object(conjugation1)
      @conjugation2 = get_object(conjugation2)
      @prototype = get_object(prototype) || word
      @reading = get_object(reading) || @prototype
      @pronunciation = get_object(pronunciation) || @reading
    end

    def noun?
      @word_class == '名詞'
    end

    def verb?
      @word_class == '動詞'
    end

    def adjective?
      @word_class == '形容詞'
    end

    def adverb?
      @word_class == '副詞'
    end

    def postpositional_particle?
      @word_class == '助詞'
    end

    def conjunction?
      @word_class == '接続詞'
    end

    def auxiliary_verb?
      @word_class == '助動詞'
    end

    def determiner?
      @word_class == '連体詞'
    end

    def interjection?
      @word_class == '感動詞'
    end

    def symbol?
      @word_class == '記号'
    end

    def to_csv
      [
        @word, 0, 0, 0, @word_class,
        get_str(@word_subclass1), get_str(@word_subclass2), get_str(@word_subclass3),
        get_str(@conjugation1), get_str(@conjugation2),
        get_str(@prototype), get_str(@reading), get_str(@pronunciation)
      ]
    end

    private

    def get_object(str)
      str != '*' ? str : nil
    end

    def get_str(object)
      object || '*'
    end

    class << self
      def to_reading(str, str_threshold = 20)
        # NOTE: 負荷とパフォーマンスが気になるので上限を超えている場合は切り詰める
        mecab_models = convert_model(str.slice(0, str_threshold).tr('ぁ-ん', 'ァ-ン'))
        mecab_models.inject('') { |reading, model| reading + model.reading }
      end

      def extract_nouns(str)
        convert_model(str).select(&:noun?)
      end

      def convert_model(str)
        @natto ||= Natto::MeCab.new
        natto_objects = @natto.parse(str)
        natto_objects.delete_suffix!("EOS\n")
        natto_objects.split("\n").map { |natto_object| create_from_natto_object(natto_object) }
      end

      def create_as_proper_noun(word, reading = nil, pronunciation = nil)
        new(
          word: word, word_class: '名詞',
          word_subclass1: '固有名詞', word_subclass2: '一般', word_subclass3: nil,
          conjugation1: nil, conjugation2: nil,
          prototype: word,
          reading: reading || word,
          pronunciation: pronunciation || reading || word
        )
      end

      def load_from_csv(filename)
        CSV.open(filename, 'r') do |rows|
          rows.map do |row|
            new(
              word: row[0], word_class: row[4],
              word_subclass1: row[5], word_subclass2: row[6], word_subclass3: row[7],
              conjugation1: row[8], conjugation2: row[9],
              prototype: row[10], reading: row[11], pronunciation: row[12]
            )
          end
        end
      end

      private

      def create_from_natto_object(natto_object)
        objects = natto_object.split("\t")
        word = objects.first
        word_class_objects = objects.last.split(',')
        new(
          word: word, word_class: word_class_objects[0],
          word_subclass1: word_class_objects[1],
          word_subclass2: word_class_objects[2],
          word_subclass3: word_class_objects[3],
          conjugation1: word_class_objects[4],
          conjugation2: word_class_objects[5],
          prototype: word_class_objects[6],
          reading: word_class_objects[7],
          pronunciation: word_class_objects[8]
        )
      end
    end
  end
end
