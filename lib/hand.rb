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

    def return_card_value(card)
        CARD_VALUES.index(card)
    end

    def return_highest_card
        self.cards.each do |card|
            if return_card_value(card.value) > return_card_value(self.highest_card)
                self.highest_card = card.value
            end
        end
    end

    def calculate_straight
        def consecutive?(arr)
            arr.each_cons(2).all? {|a, b| b == a + 1 }
        end
        arr = []
        self.cards.each do |card|
            arr << return_card_value(card.value)
        end
        return true if consecutive?(arr.sort)
        false
    end

    def calculate_full_house
        arr = []
        self.cards.each do |card|
            arr << return_card_value(card.value)
        end
        arr = arr.sort
        if arr[0] == arr[1] && arr[2] == arr[3] && arr[3] == arr[4] || arr[3] == arr[4] && arr[0] == arr[1] && arr[1] == arr[2]
            return true
        end
        false
    end

    def calculate_hand
        pair_count = 0

        pair = false
        two_pair = false
        triple = false
        run = false
        flush = false
        full_house = false
        quad = false
        royal_flush = false
        self.cards.each_with_index do |card1, i|
            self.cards.each_with_index do |card2, j|
                if i < j
                    if card1.value == card2.value
                        if return_card_value(card1.value) > return_card_value(self.highest_card)
                            self.highest_card = card1.value
                        end
                        pair_count += 1
                    end
                end
            end
        end

        if calculate_full_house
            return_highest_card()
            return "full_house"
        elsif self.cards.all? { |card| card.suit == self.cards[0].suit }
            return_highest_card()
            return "flush"
        elsif calculate_straight
            return_highest_card()
            return "straight"
        elsif pair_count == 3
            return "triple"
        elsif pair_count == 2
            return "two_pairs"
        elsif pair_count == 1
            return "pair"
        else
            return_highest_card()
            return self.highest_value
        end
    end



    def reset
        self.highest_value = "nothing"
        self.highest_card = 0
    end
end