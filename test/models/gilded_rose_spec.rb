require 'rails_helper'

describe GildedRose do

  describe '#update_quality' do
    it 'does not change the name' do
      items = [Item.new('foo', 0, 0)]
      GildedRose.new(items).update_quality()
      expect(items[0].name).to eq 'foo'
    end

    it 'does not degrade quality below zero' do
      no_quality_item = Item.new('bar', 1, 0)
      one_quality_item = Item.new('baz', 0, 1)
      items = [no_quality_item, one_quality_item]
      GildedRose.new(items).update_quality()
      expect(items.map(&:quality)).to all(eq 0)
    end

    context 'given a normal item' do
      context 'with quality of at least 2' do
        it 'degrades quality by 2 if the sell by date has passed ( <= 0)' do
          items = [Item.new('foo', -1, 3)]
          GildedRose.new(items).update_quality()
          expect(items[0].quality).to eq 1
        end
      end

      it 'degrades quality by 1 if the sell by date has not passed ( > 0)' do
        items = [Item.new('foo', 1, 3)]
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 2
      end
    end

    context 'given an Aged Brie' do
      let (:aged_brie) {Item.new('Aged Brie', 0, 0)}
      let (:subject) { GildedRose.new([aged_brie]) }

      context 'the sell date has passed' do
        it 'increases in quality 2 per day' do
          aged_brie.sell_in = 0
          subject.update_quality
          expect(aged_brie.quality).to eq 2
        end
      end

      context 'the sell date has not passed' do
        it 'increases in quality 1 per day' do
          aged_brie.sell_in = 1
          subject.update_quality
          expect(aged_brie.quality).to eq 1
        end
      end
    end
  end
end

