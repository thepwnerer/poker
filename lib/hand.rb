require_relative "deck"

class Hand
    attr_accessor :cards, :highest_value, :highest_card
    CARD_VALUES = [2,3,4,5,6,7,8,9,10,"J","Q","K","A"]

    def initialize(deck)
        @cards = []
        5.times { self.cards << deck.cards.shift }
        @highest_value = "nothing"
        @highest_card = 2
    end


    def calculate_hand
        suit_count = 0
        pair_count = 0

        pair = false
        two_pair = false
        triple = false
        flush = false
        full_house = false
        quad = false
        royal_flush = false
        run = false
        self.cards.each_with_index do |card1, i|
            self.cards.each_with_index do |card2, j|
                if i < j
                    if card1.value == card2.value
                        if return_card_values(card1.value) > self.highest_card
                            self.highest_card = card1.value
                        end
                        pair_count += 1
                    end
                end
            end
        end
        if pair_count == 2
            return "two_pair"
        elsif pair_count = 1
            return "pair"
        end
    end

    def return_card_values(card)
        CARD_VALUES.index(card)
    end

    def reset
        self.highest_value = "nothing"
        self.highest_card = 0
    end
end