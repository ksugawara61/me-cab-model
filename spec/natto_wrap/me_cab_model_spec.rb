# frozen_string_literal: true

require 'spec_helper'

RSpec.describe NattoWrap::MeCabModel do
  describe 'instance' do
    subject(:mecab_model) do
      described_class.new(
        word: 'ハンバーグ',
        word_class: word_class,
        word_subclass1: '固有名詞',
        word_subclass2: '一般',
        word_subclass3: nil,
        conjugation1: nil,
        conjugation2: nil,
        prototype: 'ハンバーグ',
        reading: 'ハンバーグ',
        pronunciation: 'ハンバーグ'
      )
    end

    let(:word_class) { '名詞' }

    context 'when word_class is noun' do
      let(:word_class) { '名詞' }

      it { is_expected.to be_noun }
    end

    context 'when word_class is verb' do
      let(:word_class) { '動詞' }

      it { is_expected.to be_verb }
    end

    context 'when word_class is adjective' do
      let(:word_class) { '形容詞' }

      it { is_expected.to be_adjective }
    end

    context 'when word_class is adverb' do
      let(:word_class) { '副詞' }

      it { is_expected.to be_adverb }
    end

    context 'when word_class is postpositional_particle' do
      let(:word_class) { '助詞' }

      it { is_expected.to be_postpositional_particle }
    end

    context 'when word_class is conjunction' do
      let(:word_class) { '接続詞' }

      it { is_expected.to be_conjunction }
    end

    context 'when word_class is auxiliary_verb' do
      let(:word_class) { '助動詞' }

      it { is_expected.to be_auxiliary_verb }
    end

    context 'when word_class is determiner' do
      let(:word_class) { '連体詞' }

      it { is_expected.to be_determiner }
    end

    context 'when word_class is interjection' do
      let(:word_class) { '感動詞' }

      it { is_expected.to be_interjection }
    end

    context 'when word_class is symbol' do
      let(:word_class) { '記号' }

      it { is_expected.to be_symbol }
    end

    describe '#to_csv' do
      it do
        expect(mecab_model.to_csv).to eq [
          'ハンバーグ', 0, 0, 0, '名詞', '固有名詞', '一般',
          '*', '*', '*', 'ハンバーグ', 'ハンバーグ', 'ハンバーグ'
        ]
      end
    end
  end

  describe '.to_reading' do
    subject(:reading) { described_class.to_reading(str, str_threshold) }

    let(:str) { '宇宙飛行士' }

    context 'when str size is str_threshold or less' do
      let(:str_threshold) { 5 }

      context 'when str is kanzi' do
        it { is_expected.to eq 'ウチュウヒコウシ' }
      end

      context 'when str is hiragana' do
        let(:str) { 'うちゅう' }

        it { is_expected.to eq 'ウチュウ' }
      end

      context 'when str is katakana' do
        let(:str) { 'ウチュウ' }

        it { is_expected.to eq 'ウチュウ' }
      end
    end

    context 'when str size is more than str_threshold' do
      let(:str_threshold) { 2 }

      it { is_expected.to eq 'ウチュウ' }
    end
  end

  describe '.convert_model' do
    subject(:mecab_models) { described_class.convert_model(str) }

    let(:str) { '今日は晴れです' }

    it do
      expect(mecab_models).to include(
        have_attributes(
          word: '今日',
          word_class: '名詞',
          word_subclass1: '副詞可能',
          word_subclass2: nil,
          word_subclass3: nil,
          conjugation1: nil,
          conjugation2: nil,
          prototype: '今日',
          reading: 'キョウ',
          pronunciation: 'キョー'
        ),
        have_attributes(
          word: 'は',
          word_class: '助詞',
          word_subclass1: '係助詞',
          word_subclass2: nil,
          word_subclass3: nil,
          conjugation1: nil,
          conjugation2: nil,
          prototype: 'は',
          reading: 'ハ',
          pronunciation: 'ワ'
        ),
        have_attributes(
          word: '晴れ',
          word_class: '名詞',
          word_subclass1: '一般',
          word_subclass2: nil,
          word_subclass3: nil,
          conjugation1: nil,
          conjugation2: nil,
          prototype: '晴れ',
          reading: 'ハレ',
          pronunciation: 'ハレ'
        ),
        have_attributes(
          word: 'です',
          word_class: '助動詞',
          word_subclass1: nil,
          word_subclass2: nil,
          word_subclass3: nil,
          conjugation1: '特殊・デス',
          conjugation2: '基本形',
          prototype: 'です',
          reading: 'デス',
          pronunciation: 'デス'
        )
      )
    end
  end

  describe '.create_as_proper_noun' do
    subject(:mecab_model) do
      described_class.create_as_proper_noun('麻婆豆腐', 'マーボードウフ', 'マーボードーフ')
    end

    it do
      expect(mecab_model).to have_attributes(
        word: '麻婆豆腐',
        word_class: '名詞',
        word_subclass1: '固有名詞',
        word_subclass2: '一般',
        word_subclass3: nil,
        conjugation1: nil,
        conjugation2: nil,
        prototype: '麻婆豆腐',
        reading: 'マーボードウフ',
        pronunciation: 'マーボードーフ'
      )
    end

    it { is_expected.to be_noun }
  end

  describe '.load_from_csv' do
    subject(:mecab_models) { described_class.load_from_csv(filename) }

    let(:filename) do
      root = File.dirname __dir__
      File.join(root, 'fixtures', 'dic', 'recipe_dic.csv')
    end

    it do
      expect(mecab_models).to include(
        have_attributes(
          word: '簡単',
          word_class: '名詞',
          word_subclass1: '固有名詞',
          word_subclass2: '一般',
          word_subclass3: nil,
          conjugation1: nil,
          conjugation2: nil,
          prototype: '簡単',
          reading: 'カンタン',
          pronunciation: 'カンタン'
        ),
        have_attributes(
          word: 'お手軽',
          word_class: '名詞',
          word_subclass1: '固有名詞',
          word_subclass2: '一般',
          word_subclass3: nil,
          conjugation1: nil,
          conjugation2: nil,
          prototype: 'お手軽',
          reading: 'オテガル',
          pronunciation: 'オテガル'
        )
      )
    end
  end
end
