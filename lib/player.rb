class Player
    attr_reader :name
    attr_accessor :hand, :money
    def initialize(name)
        @name = name
        @hand = []
        @money = 1000
    end

    def remove_money(amount)
        self.money -= amount
    end


    
end