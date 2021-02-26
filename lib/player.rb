require_relative "hand"

class Player
    attr_reader :name
    attr_accessor :hand, :money, :called, :playing_round, :last_bet

    def initialize(name)
        @name = name
        @hand = []
        @money = 1000
        @playing_round = true
        @called = false
        @last_bet = 0
    end

    def remove_money(amount)
        self.money -= amount
    end

end