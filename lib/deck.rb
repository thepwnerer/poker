require_relative "card"
SUITS = ['hearts','diamonds','spades','clubs']
CARDS = ['A',2,3,4,5,6,7,8,9,10,'J','Q','K']

class Deck
attr_accessor :cards

    def initialize()
        @cards = Array.new
        SUITS.each do |suit|
            CARDS.each do |value|
                cards << Card.new(suit,value)
            end
        end
        self.cards = self.cards.shuffle
    end

    def shuf
        self.cards = self.cards.shuffle
    end
end
