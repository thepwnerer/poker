require_relative "card"
require_relative "deck"
require_relative "hand"
require_relative "player"

class Game
    attr_reader :deck
    attr_accessor :players, :pot

    def initialize(p1name, p2name, p3name, p4name)
        @deck = Deck.new
        @players = [Player.new(p1name), Player.new(p2name), Player.new(p3name), Player.new(p4name)]
        self.players.each do |player|
            player.hand = Hand.new(self.deck)
        end
        @pot = 0
    end

    def add_to_pot(amount)
        self.pot += amount
    end


    def bet(player,amount)
        player.remove_money(amount)
        add_to_pot(amount)
    end
end