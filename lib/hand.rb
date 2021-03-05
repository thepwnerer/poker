require_relative "deck"

class Hand
    attr_accessor :cards, :highest_value, :highest_card, :highest_value_number
    CARD_VALUES = [2,3,4,5,6,7,8,9,10,"J","Q","K","A"]
    WINNING_ORDER = ["nothing","pair","two_pair","triple","run","flush","full_house","quad","straight_flush"]

    def initialize(deck)
        @cards = []
        5.times { self.cards << deck.cards.shift }
        @highest_value_number = 0
        @highest_value = "nothing"
        @highest_card = 2
    end

    def replace(cards, deck)
        cards_array = [cards]
        replace_amount = cards.length
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

    def get_highest_from_middle
        arr = []
        self.cards.each do |card|
            arr << return_card_value(card.value)
        end
        arr = arr.sort
        self.highest_card = CARD_VALUES[arr[2]]
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
        if arr[0] == arr[1] && arr[1] == arr[2] && arr[3] == arr[4] || arr[0] == arr[1] && arr[2] == arr[3] && arr[3] == arr[4]
            return true
        end
        false
    end

    def calculate_quad
        arr = []
        self.cards.each do |card|
            arr << return_card_value(card.value)
        end
        arr = arr.sort
        if arr[0] == arr[1] && arr[1] == arr[2] && arr[2] == arr[3] || arr[1] == arr[2] && arr[2] == arr[3] && arr[3] == arr[4]
            return true
        end
        false
    end

    def calculate_highest_value_number
        self.highest_value_number = WINNING_ORDER.index(self.highest_value)
    end

    def calculate_hand
        pair_count = 0
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


        if self.cards.all? { |card| card.suit == self.cards[0].suit } && calculate_straight
            return_highest_card
            return "straight_flush"
        elsif calculate_quad
            get_highest_from_middle
            return "quad"
        elsif calculate_full_house
            get_highest_from_middle
            return "full_house"
        elsif self.cards.all? { |card| card.suit == self.cards[0].suit }
            return_highest_card
            return "flush"
        elsif calculate_straight
            return_highest_card
            return "straight"
        elsif pair_count == 3
            return "triple"
        elsif pair_count == 2
            return "two_pairs"
        elsif pair_count == 1
            return "pair"
        else
            return_highest_card
            return self.highest_value
        end
    end

    def calculate_value
        hand = self.calculate_hand
        WINNING_ORDER.index(hand)
    end

    def calculate_highest
        self.calculate_hand
        self.highest_card
    end

    def reset
        self.highest_value = "nothing"
        self.highest_card = 0
    end

    def replace(replace_cards, deck)
        cards_array = replace_cards.split("")
        cards_array.map! { |index| index.to_i }
        replace_amount = cards_array.length
        replace_amount.times { self.cards << deck.cards.shift }
        cards_array.each do |delete_index|
            deck.shuf
            deck.cards << self.cards.delete_at(delete_index)
        end
    end

end

=begin
deck = Deck.new

test = Hand.new(deck)

p deck.cards.length

test.cards.each do |card|
    p card
end

test.replace("210",deck)

test.cards.each do |card|
    p card
end
=end